package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.NoticeDTO;
import poly.dto.UserDTO;
import poly.service.INoticeService;
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

    // 마이페이지
    @RequestMapping(value="/myPage")
    public String myPage() {
        log.info(this.getClass().getName() + ".마이페이지 시작!");
        return "/user/myPage";
    }

    // 나의 판매글 조회 시, 리스트 페이지로 이동
    @RequestMapping(value="/myList", method = RequestMethod.GET)
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
        log.info("rDTO에서 가져온 회원번호 : " + rDTO.getUser_no());
        log.info("rDTO에서 가져온 회원 이메일 : " + EncryptUtil.decAES128CBC(rDTO.getUser_email()));

        String msg = "";
        String url = "";

        if (rDTO != null) {
            model.addAttribute("rDTO", rDTO);

        } else {
            log.info("회원정보 가져오기 실패!");
            msg = "일치하는 회원정보가 없습니다. 로그인 여부를 확인해 주세요.";
            url = "/logIn.do";
            return "redirect";
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

            msg = "회원정보가 수정되었습니다.";
            url = "/myPage.do";

            pDTO = null;
        } catch (Exception e) {

            // 오류 발생 시, 오류 문구 출력
            msg = "실패하였습니다." + e.toString();
            url = "/updateUserForm.do";

            log.info(e.toString());
            e.printStackTrace();
        } finally {
            log.info(this.getClass().getName() + ".updateUser(회원정보 수정 로직) End!");

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);
        }
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

}
