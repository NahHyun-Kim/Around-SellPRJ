package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.MailDTO;
import poly.dto.NoticeDTO;
import poly.dto.UserDTO;
import poly.service.INoticeService;
import poly.service.ISearchService;
import poly.service.IUserService;
import poly.util.CmmUtil;
import poly.util.EncryptUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class MyController {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name="UserService")
    private IUserService userService;

    @Resource(name="NoticeService")
    private INoticeService noticeService;

    @Resource(name="SearchService")
    private ISearchService searchService;

    // 마이페이지
    @RequestMapping(value="/myPage")
    public String myPage() {
        log.info(this.getClass().getName() + ".마이페이지 시작!");
        return "/user/myPage";
    }

    // 나의 판매글 조회 시, 리스트 페이지로 이동
    @RequestMapping(value="/myList")
    public String myList(HttpServletRequest request, HttpServletResponse response, ModelMap model,
                         HttpSession session)
        throws Exception {
        log.info(this.getClass().getName() + "나의 판매글 조회 시작!");

        String user_no = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO"));
        log.info("세션으로부터 받아온 회원 번호 : " + user_no);

        // user_no에 해당하는 판매글 리스트를 가져오기위해 pDTO 에 회원번호를 세팅
        NoticeDTO pDTO = new NoticeDTO();
        pDTO.setUser_no(user_no);

        // 나의 판매글 리스트 가져오기
        // 판매글 정보는 여러개이므로, DTO를 List 형태에 담아 반환한다.
        List<NoticeDTO> rList = noticeService.getMyList(pDTO);

        for(int i=0; i<rList.size(); i++) {
            NoticeDTO rDTO = rList.get(i);

            log.info(i + "번째 img 경로 : " + rDTO.getImgs());

            if (rDTO == null) {
                rDTO = new NoticeDTO();
            }
        }
        log.info("rList null ? : " + (rList == null));

        if (rList == null) {
            rList = new ArrayList<NoticeDTO>();

        }

        // 조회된 리스트 결과값을 model에 보냄
        model.addAttribute("rList", rList);

        // 메모리 효율화를 위한 변수 초기화
        rList = null;

        log.info(this.getClass().getName() + ".getMyList(나의 판매글 리스트) End!");

        return "/user/mySell";

    }

    // ajax로 마이페이지 회원 판매글 삭제
    @ResponseBody
    @RequestMapping(value="delMySell")
    public int delMySell(HttpServletRequest request, HttpServletResponse response, HttpSession session)
        throws Exception {

        log.info(this.getClass().getName() + ".delMySell(ajax 판매글 삭제) Start");
        String del_num = (String) request.getParameter("del_num");
        String user_no = (String) session.getAttribute("SS_USER_NO");

        log.info("받아온 판매글 번호 : " + del_num);
        log.info("받아온 회원 번호 : " + user_no);

        NoticeDTO pDTO = new NoticeDTO();
        pDTO.setGoods_no(del_num);

        log.info("setting 되었는지 ? : " + pDTO.getGoods_no());

        int res = 0;
        // 지정한 회원번호로 판매글 삭제
        res = noticeService.delMySell(pDTO);

        log.info("삭제했는지 ? : " + res);

        // 삭제에 성공했다면
        if (res > 0) {
            log.info("회원 판매글 삭제 성공!");

            // 삭제가 성공했다면, 최근 본 상품 함께 삭제
            NoticeDTO dDTO = new NoticeDTO();
            dDTO.setUser_no(user_no);

            log.info("삭제 요청할 key값 번호 받아오기 성공!(user_no) : " + dDTO.getUser_no());

            // 최근 본 상품에서 삭제함
            searchService.rmKeyword(dDTO);
            log.info("삭제 요청 완료!");
        } else {
            log.info("삭제 실패!");
        }

        pDTO = null;

        return res;
    }

    // 회원정보 수정 폼
    @RequestMapping(value="/updateUserForm", method = RequestMethod.GET)
    public String updateUserForm(HttpServletRequest request, HttpServletResponse response, ModelMap model, HttpSession session)
            throws Exception {
        log.info(this.getClass().getName() + "updateUserForm(회원정보 수정 폼) Start!");
        String user_no = (String) session.getAttribute("SS_USER_NO");

        UserDTO pDTO = new UserDTO();
        pDTO.setUser_no(user_no);

        // 회원정보 수정을 위해 입력된 정보 가져오기(회원정보 조회 함수를 사용한다)
        UserDTO rDTO = userService.getUserInfo(pDTO);
        // 기존 회원정보를 가져오기 위해 사용한 pDTO 변수 초기화
        pDTO = null;
        log.info("rDTO null? : " + (rDTO == null));

        String msg = "";
        String url = "";

        if (rDTO != null) {
            log.info("rDTO에서 가져온 회원번호 : " + rDTO.getUser_no());
            log.info("rDTO에서 가져온 회원 이메일 : " + EncryptUtil.decAES128CBC(rDTO.getUser_email()));

            model.addAttribute("rDTO", rDTO);

        } else {

            rDTO = new UserDTO();
            log.info("회원정보 가져오기 실패!");
            msg = "일치하는 회원정보가 없습니다. 로그인 여부를 확인해 주세요.";
            url = "/logIn.do";

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);
            return "/info";
        }

        return "/user/editUser";

    }

    // 회원정보 수정 로직
    @RequestMapping(value="/updateUser", method = RequestMethod.POST)
    public String updateUser(HttpSession session, HttpServletRequest request, HttpServletResponse response, ModelMap model)
            throws Exception {
        log.info(this.getClass().getName() + ".updateUser(수정 로직) Start!");

        String msg = "";
        String url = "";

        try {
            String user_no = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO")); //회원 번호
            String user_email = CmmUtil.nvl(EncryptUtil.encAES128CBC(request.getParameter("user_email"))); // 회원 이메일
            String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password"))); // 회원 비밀번호
            String user_name = CmmUtil.nvl(request.getParameter("user_name")); //회원 이름
            String addr = CmmUtil.nvl(request.getParameter("addr"));

            // 서울특별시 강서구와 같은 입력에서, 지역구를 가져오기 위해 split 함수 사용
            String[] addrsplit = CmmUtil.nvl(request.getParameter("addr")).split(" ", 3);
            String addr2 = addrsplit[1].trim();

            String phone_no = CmmUtil.nvl(request.getParameter("phone_no")); //핸드폰 번호

            UserDTO pDTO = new UserDTO();
            pDTO.setUser_no(user_no);
            pDTO.setUser_email(user_email);
            pDTO.setPassword(password);
            pDTO.setUser_name(user_name);
            pDTO.setAddr(addr);
            pDTO.setAddr2(addr2);
            pDTO.setPhone_no(phone_no);

            log.info("DTO에 세팅된 회원정보 테스트 : " + pDTO.getAddr2() + pDTO.getUser_name());

            // DB로 update 쿼리를 보내, 회원 정보 수정
            userService.updateUser(pDTO);

            log.info("update 서비스 호출");

            // 세션 초기화(개인정보 수정 시, 날씨 정보와 거리계산에 사용되는 주소값을 다시 생성)
            session.removeAttribute("SS_USER_ADDR");
            session.removeAttribute("SS_USER_ADDR2");
            session.setAttribute("SS_USER_ADDR", addr);
            session.setAttribute("SS_USER_ADDR2", addr2);
            msg = "회원정보가 수정되었습니다.";
            url = "/myList.do";

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);

            pDTO = null;
        } catch (Exception e) {

            // 오류 발생 시, 오류 문구 출력
            msg = "실패하였습니다." + e.toString();
            url = "/updateUserForm.do";

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);
            log.info(e.toString());
            e.printStackTrace();

            return "/info";

        }
        log.info(this.getClass().getName() + ".updateUser(회원정보 수정 로직) End!");

        return "/redirect";
    }

    // 회원정보 수정 시, 비밀번호 (기존 비밀번호 체크) ajax
    @ResponseBody
    @RequestMapping(value="/pwdCheck")
    public int pwdCheck(@RequestParam("password") String password, HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws Exception {
        log.info(this.getClass().getName() + ".pwdCheck Start!");

        log.info("사용자 입력 패스워드 : " + password);

        String shapwd = EncryptUtil.encHashSHA256(password);
        String userno = (String) session.getAttribute("SS_USER_NO");

        log.info("암호화 패스워드 : " + shapwd);
        log.info("유저 번호 : " + userno);

        log.info("userService.pwdCheck Start!");

        UserDTO pDTO = new UserDTO();
        pDTO.setPassword(shapwd);
        pDTO.setUser_no(userno);
        UserDTO rDTO = userService.pwdCheck(pDTO);

        log.info("rDTO null? : " + (rDTO==null));
        int res = 0;

        //값이 있다면(=비밀번호 값이 일치한다면) 1을 리턴
        //res가 1이여야, 유효하여 비밀번호 변경 페이지로 넘어갈 수 있음
        if (rDTO != null) {
            res = 1;
        } else {
            res = 0;
        }

        log.info(this.getClass().getName() + ".pwdCheck End!");
        //res를 리턴하여, ajax를 통해 유효성 체크
        return res;
    }


    // 비밀번호 변경 ajax로 진행
    @ResponseBody
    @RequestMapping(value="/updatePwAjax")
    public int updatePwAjax(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                            @RequestParam(value="password") String password) throws Exception {
        log.info("비밀번호 변경 ajax 진행 시작");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        String member_pw = CmmUtil.nvl(EncryptUtil.encHashSHA256(password));

        log.info("가져온 회원번호 : " + user_no);
        log.info("입력받은 비밀번호(복호화 진행) : " + member_pw);

        // 기존 비밀번호와 일치하는지 확인하기 위해 중복확인 작업
        UserDTO uDTO = new UserDTO();

        uDTO.setPassword(member_pw);
        uDTO.setUser_no(user_no);

        UserDTO rDTO = userService.myPwdChk(uDTO);

        int valid = 0;
        //중복되는 값이 없다면, 기존 비밀번호와 다른 유효성에 맞는 비번 입력
        if (rDTO == null) {
            valid = 0;
        } else { // 기존 값이 있는 것을 입력(다른 비밀번호 입력해야함)
            valid = 1;
        }
        uDTO = null;

        UserDTO pDTO = null;


        // ajax 비밀번호 변경 결과값으로 전송할 변수 res
        int res = 0;

        // 기존 비밀번호와 다를 경우, 비밀번호 변경 진행
        if (valid == 0) {
            log.info("valid 0! 비밀번호 정상 변경 진행");

            try {
                pDTO = new UserDTO();

                //수정할 비밀번호 전달
                pDTO.setUser_no(user_no);
                pDTO.setPassword(member_pw);

                // 비밀번호 DB반영
                userService.updateMyPw(pDTO);

                // 재 로그인을 요청하기 때문에, 현재 로그인 상태를 초기화함
                session.invalidate();

                pDTO = null;
                res = 1;
                log.info("비밀번호 변경 종료");

            } catch (Exception e) {
                log.info("실패 ! " + e.toString());
                e.printStackTrace();
                res = 0;
            }
            pDTO = null;

            // 비밀번호가 기존 비밀번호와 일치하면 문구를 띄워줌
        } else if (valid == 1) {
            log.info("기존 비밀번호와 일치! (valid 1) 재 변경 요청");
            res = 2;
        }
        log.info("비밀번호 변경 ajax 진행 끝!");
        return res;

    }

    // 비밀번호 변경(회원정보 수정 시)
    @RequestMapping("/updateMyPw")
    public String updateMyPw(HttpServletRequest request, HttpServletResponse response, ModelMap model, HttpSession session) throws Exception {
        log.info("비밀번호 변경 시작!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        String member_pw = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password1")));

        log.info("가져온 회원번호 : " + user_no);
        log.info("입력받은 비밀번호 : " + member_pw);

        String msg = "";
        String url = "";

        UserDTO pDTO = null;

        try {
            pDTO = new UserDTO();

            //수정할 비밀번호 전달
            pDTO.setUser_no(user_no);
            pDTO.setPassword(member_pw);

            // 비밀번호 DB반영
            userService.updateMyPw(pDTO);

            // 재 로그인을 요청하기 때문에, 현재 로그인 상태를 초기화함
            session.invalidate();
            msg = "비밀번호가 변경되었습니다. 재 로그인해 주세요!";
            url = "/logIn.do";

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);

            // 변수와 메모리 초기화
            msg = "";
            url = "";
            pDTO = null;
            log.info("비밀번호 변경 종료");

        } catch (Exception e) {
            msg = "실패하였습니다. : ";
            url = "updateUserForm.do";


            log.info(e.toString());
            e.printStackTrace();

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);

            return "/info";

        } finally {
            // 변수와 메모리 초기화
            msg = "";
            url = "";
            pDTO = null;
        }


        log.info("updatePw End!");
        return "/redirect";
    }

    // 회원정보 수정 메뉴에서, 비밀번호 변경을 요청하면 비밀번호 변경 페이지로 이동
    @RequestMapping("/editPwForm")
    public String editPwForm() {
        log.info(this.getClass().getName() + ".비밀번호 변경 페이지 Start!");
        return "/user/editPwForm";
    }

    // 비밀번호 변경 시, 기존 비밀번호와 다른 비밀번호로 변경
    @ResponseBody
    @RequestMapping(value="/myPwdChk", method=RequestMethod.POST)
    public int myPwdChk(HttpSession session, HttpServletRequest request,
                        @RequestParam(value="password") String pwd) throws Exception {
        log.info(this.getClass().getName() + ".비밀번호 기존 비밀번호 확인 Start!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        String email = (String) session.getAttribute("SS_EMAIL");
        String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(pwd));

        log.info("받아온 회원번호 : " + user_no);
        log.info("받아온 (비번 찾기 시) 이메일 : " + email);
        log.info("받아온 비밀번호 (암호화하여 dto에 전달) : " + password);

        UserDTO pDTO = new UserDTO();

            pDTO.setUser_email(email);
            pDTO.setUser_no(user_no);
            pDTO.setPassword(password);

        UserDTO rDTO = null;
        rDTO = userService.myPwdChk(pDTO);

        int res = 0;

         //중복되는 값이 없다면, 기존 비밀번호와 다른 유효성에 맞는 비번 입력
        if (rDTO == null) {
            res = 0;
        } else { // 기존 값이 있는 것을 입력(다른 비밀번호 입력해야함)
            res = 1;
        }
        log.info("myPwd Chk 완료! null(true)이면 중복 아님, false면 기존과 중복! : " + (rDTO == null));

        log.info(this.getClass().getName() + ".비밀번호 기존 비밀번호 확인 End");

        return res;
    }


}
