package poly.controller;

import org.springframework.stereotype.Controller;

import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.*;
import poly.service.ICartService;
import poly.service.IMailService;
import poly.service.INoticeService;
import poly.service.IUserService;
import poly.util.CmmUtil;
import poly.util.EncryptUtil;
import poly.util.TemppwdUtil;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

/*
 * Controller 선언해야만 Spring 프레임워크에서 Controller인지 인식 가능
 * 자바 서블릿 역할 수행
 * */
@Controller
public class UserController {

    @Resource(name = "MailService")
    private IMailService mailService;

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    private Logger log = Logger.getLogger(this.getClass());

    //로그인 화면
    @RequestMapping(value = "logIn")
    public String logIn() {
        log.info(this.getClass().getName() + ".login 시작!");
        return "/user/logIn";
    }

    //로그인 진행
    @RequestMapping(value = "/getLogin", method = RequestMethod.POST)
    public String getLogin(HttpServletRequest request, HttpSession session,
                           Model model) throws Exception {
        log.info("getLogin Start!");

        // 이메일은 복호화가 가능한 AES128, 비밀번호는 복호화 불가능한 HASHSHA256 사용
        String user_email = CmmUtil.nvl(EncryptUtil.encAES128CBC(request.getParameter("user_email")));
        String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password")));

        log.info("String user_email : " + EncryptUtil.decAES128CBC(user_email));
        log.info("String password : " + password);

        UserDTO pDTO = new UserDTO();

        log.info("pDTO.set 시작");

        pDTO.setUser_email(user_email);
        pDTO.setPassword(password);

        log.info("pDTO.user_email : " + pDTO.getUser_email());
        log.info("pDTO.password : " + pDTO.getPassword());
        log.info("userService.getLogin 시작");

        UserDTO rDTO = userService.getLogin(pDTO);

        log.info("rDTO null? : " + (rDTO == null));
        String msg = "";
        String url = "";

        // 로그인에 실패한 경우
        if (rDTO == null) {
            msg = "로그인에 실패했습니다. 다시 시도해 주세요.";
            url = "/logIn.do"; //재 로그인
        }
        // 로그인 성공한 경우(rDTO != null)
        else {
            log.info("rDTO.user_name: " + rDTO.getUser_name());
            log.info("rDTO.user_no : " + rDTO.getUser_no());
            log.info("rDTO.addr : " + rDTO.getAddr());
            log.info("rDTO.addr2 : " + rDTO.getAddr2());
            msg = "환영합니다!";

            String user_no = rDTO.getUser_no();
            String user_name = rDTO.getUser_name();
            String addr = rDTO.getAddr();
            String addr2 = rDTO.getAddr2();

            log.info("addr : " + addr);
            log.info("addr2 : " + addr2);

            // 회원 번호로 세션 올림, "ㅇㅇㅇ님, 환영합니다" 같은 문구 표시를 위해 user_name도 세션에 올림
            session.setAttribute("SS_USER_NO", user_no);
            session.setAttribute("SS_USER_NAME", user_name);
            session.setAttribute("SS_USER_ADDR", addr);
            session.setAttribute("SS_USER_ADDR2", addr2);
            log.info("session.setAttribute 완료");

            url = "/getIndex.do"; //로그인 성공 후 리턴할 페이지

            // 관리자 권한으로 로그인 시, 관리자 페이지로 이동
            if (user_no.equals("0")) {
                log.info("adminPage Start!");
                url = "/adminPage.do";
            }
        }

        model.addAttribute("msg", msg);
        model.addAttribute("url", url);
        log.info("msg : " + msg);
        log.info("url : " + url);


        pDTO = null;
        rDTO = null;
        log.info("getLogin end");

        return "/redirect";
    }

    // 로그아웃
    @RequestMapping(value = "/logOut")
    public String logOut(HttpSession session, ModelMap model) throws Exception {
        log.info("logOut Start!");

        String msg = "로그아웃 되었습니다.";
        String url = "/getIndex.do";

        // 세션 삭제(user_name, user_no) - invalidate() 또는 removeAttribute 함수 사용
        session.removeAttribute("SS_USER_NAME");
        session.removeAttribute("SS_USER_NO");
        session.removeAttribute("SS_USER_ADDR");
        session.removeAttribute("SS_USER_ADDR2");

        // 세션이 정상적으로 삭제되었는지 로그를 통해 확인
        log.info("session deleted ? : " + session.getAttribute("SS_USER_NO"));
        model.addAttribute("msg", msg);
        model.addAttribute("url", url);

        log.info("session delete, model.addAttribute 끝!");
        log.info("logOut End!");

        return "/redirect";
    }

    //회원가입 화면
    @RequestMapping(value = "/signup")
    public String SignUp(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
        log.info(this.getClass().getName() + ".signup 시작!");
        return "/user/signUp";
    }

    //회원가입 진행
    @RequestMapping(value = "/insertUser", method = RequestMethod.POST)
    public String insertUser(HttpServletRequest request, ModelMap model, HttpSession session) throws Exception {

        log.info("insertUser Start!");

        // 회원가입 jsp 에서 입력받은 값 가져오기
        // 민감 정보인 이메일은 AES128-CBC로 암호화함
        String user_email = CmmUtil.nvl(EncryptUtil.encAES128CBC(request.getParameter("user_email")));
        // 비밀번호는 복호화되지 않도록 HASHSHA256 단일 알고리즘으로 암호화함
        String password = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password")));
        String user_name = CmmUtil.nvl(request.getParameter("user_name"));
        String addr = CmmUtil.nvl(request.getParameter("addr"));

        // 서울특별시 강서구와 같은 입력에서, 지역구를 가져오기 위해 split 함수 사용
        String[] addrsplit = CmmUtil.nvl(request.getParameter("addr")).split(" ", 3);
        String addr2 = addrsplit[1].trim();
        String phone_no = CmmUtil.nvl(request.getParameter("phone_no"));

        UserDTO pDTO = new UserDTO();

        log.info("pDTO 세팅 시작");
        // jsp에서 가져온 값을 DTO에 저장
        pDTO.setUser_email(user_email);
        pDTO.setPassword(password);
        pDTO.setUser_name(user_name);
        pDTO.setAddr(addr);
        pDTO.setAddr2(addr2);
        pDTO.setPhone_no(phone_no);

        // 회원정보가 제대로 전달되었는지 로그를 통해 확인
        log.info("user_email : " + user_email);
        log.info("password : " + password);
        log.info("user_name : " + user_name);
        log.info("addr : " + addr);
        log.info("지역구(addr2) : " + addr2);
        log.info("phone_number : " + phone_no);

        log.info("pDTO 세팅 끝");

        log.info("res 시작");
        // DB에 값이 잘 저장되었다면, 1 반환
        int res = userService.insertUser(pDTO);
        log.info("res : " + res);

        String msg = "";
        String url = "";

        if (res > 0) {
            // 회원가입이 완료되었다면, 이메일 발송
            log.info("회원가입 이메일 발송 시작");

            MailDTO mDTO = new MailDTO();

            // 발송할 이메일을 복호화하여 가져옴
            mDTO.setToMail(EncryptUtil.decAES128CBC(CmmUtil.nvl(pDTO.getUser_email())));
            mDTO.setTitle("Around-Sell 회원가입을 축하드립니다.");
            mDTO.setContents(CmmUtil.nvl(pDTO.getUser_name()) + "님의 회원가입을 축하드립니다.");

            // mDTO에 세팅한 내용으로, 메일 발송
            mailService.doSendMail(mDTO);
            mDTO = null;
            log.info("회원가입 이메일 발송 완료");

            if (res > 0) {
                msg = "회원가입을 축하드립니다.";
            } else {
                msg = "회원정보를 확인 후 가입을 진행해 주세요.";
            }


        } else {
            msg = "회원정보를 확인 후 가입을 진행해 주세요.";
        }

        url = "/getIndex.do";
        log.info("model.addAttribute");
        model.addAttribute("msg", msg);
        model.addAttribute("url", url);

        pDTO = null;
        log.info("insertUser End!");
        return "/redirect";
    }

    /* 이메일 중복 확인
     * @ResponseBody 사용으로, http에 값(res) 전달 */
    @ResponseBody
    @RequestMapping(value = "/signup/emailCheck", method = RequestMethod.POST)
    public int emailCheck(HttpServletRequest request) throws Exception {
        log.info("Email check Start");

        String user_email = CmmUtil.nvl(EncryptUtil.encAES128CBC(request.getParameter("user_email")));
        log.info("user_email : " + user_email);

        log.info("userService.emailCheck Start!");
        UserDTO rDTO = userService.emailCheck(user_email);

        log.info("rDTO : " + rDTO);
        log.info("userService.emailCheck End!");

        int res = 0;

        // 값이 있다면, res = 1
        if (rDTO != null) {
            res = 1;
        }

        rDTO = null;

        log.info("res : " + res);
        log.info("Email Check End!");
        return res;
    }

    // 폰번호 중복 확인
    @ResponseBody
    @RequestMapping(value = "/signup/phoneCheck", method = RequestMethod.POST)
    public int phoneCheck(HttpServletRequest request) throws Exception {
        log.info(this.getClass().getName() + ".phoneCheck Start!");

        String phone_no = CmmUtil.nvl(request.getParameter("phone_no"));
        log.info("phone_no : " + phone_no);

        log.info("userService.phoneCheck Start!");
        UserDTO rDTO = userService.phoneCheck(phone_no);
        log.info("userService.phoneCheck End!");

        int res = 0;

        //값이 있다면(=중복되는 값이 존재한다면) 1을 리턴
        if (rDTO != null) {
            res = 1;
        }

        log.info(this.getClass().getName() + ".phoneCheck End!");
        //res를 리턴하여, ajax를 통해 유효성 체크
        return res;
    }

    /*
     * 관리자 화면
     * */
    @RequestMapping(value = "/adminPage")
    public String adminPage(ModelMap model) {
        log.info("/adminPage Start!");

        return "/admin/adminPage";
    }

    /*
     * 관리자 회원관리 화면
     * */
    @RequestMapping(value = "/getUser")
    public String userAdmin(ModelMap model) throws Exception {
        log.info(this.getClass().getName() + ".userAdmin Start!");

        // getMember() 함수를 통해 회원정보 리스트를 가져와 List 변수에 담음
        List<UserDTO> rList = userService.getUser();

        // rList가 제대로 생성되지 않은 경우, 메모리에 올려 생성함
        if (rList == null) {
            rList = new ArrayList<UserDTO>();
        }

        log.info("rList : " + rList);

        // List 형태로 model에 넘겨줌(회원 리스트)
        model.addAttribute("rList", rList);

        // 메모리 효율화를 위해, 사용 후 변수 초기화
        rList = null;
        log.info(this.getClass().getName() + ".userAdmin End!");
        return "/admin/userList";
    }

    // 관리자 회원 정보 상세보기
    @RequestMapping(value = "/getUserDetail")
    public String getUserDetail(HttpServletRequest request, ModelMap model)
            throws Exception {

        log.info(this.getClass().getName() + ".getUserDetail Start!");
        // 회원 번호 받아오기
        String user_no = request.getParameter("no");

        UserDTO pDTO = new UserDTO();
        NoticeDTO nDTO = new NoticeDTO();

        pDTO.setUser_no(user_no);
        nDTO.setUser_no(user_no);

        log.info("회원 번호 pDTO : " + pDTO.getUser_no());
        log.info("회원의 판매글을 보여주기위한 pDTO : " + nDTO.getUser_no());

        UserDTO rDTO = userService.getUserDetail(pDTO);
        // 회원의 판매글 정보를 함께 가져오기 위해 List형태로 가져옴
        List<NoticeDTO> nList = noticeService.getMyList(nDTO);

        log.info("nList null? " + (nList == null));

        // 결과가 없을 경우, 메시지와 함께 회원 목록으로 리다이렉트
        if (rDTO == null) {
            model.addAttribute("msg", "삭제에 성공했습니다.");
            model.addAttribute("url", "/getUser.do");
            return "/redirect";
        }

        model.addAttribute("rDTO", rDTO);
        model.addAttribute("nList", nList);

        log.info(this.getClass().getName() + ".getUserDetail End!");
        return "/admin/userDetail";
    }

    /* 관리자 권한으로 회원 삭제 */
    @ResponseBody
    @RequestMapping(value = "/deleteForceUser", method = RequestMethod.POST)
    public int deleteUser(HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
        log.info("deleteForceUser Start!");

        String user_no = CmmUtil.nvl(request.getParameter("user_no"));
        String SS_USER_NO = (String) session.getAttribute("SS_USER_NO");
        log.info("삭제할 회원 번호 : " + user_no);

        UserDTO pDTO = new UserDTO();
        //NoticeDTO nDTO = new NoticeDTO();

        pDTO.setUser_no(user_no);
        //nDTO.setUser_no(user_no);

        log.info("pDTO에 보낼 회원 번호 : " + pDTO.getUser_no());
        //log.info("판매글 삭제에 사용될 회원 번호 : " + nDTO.getUser_no());

        // 회원 탈퇴 시 알림 메일 전송을 위해 DTO 생성
        UserDTO rDTO = userService.getUserInfo(pDTO);
        String email = EncryptUtil.decAES128CBC(rDTO.getUser_email());
        log.info("이메일 발송을 위해 복호화한 이메일 : " + email);

        int res = userService.deleteForceUser(pDTO);
        // 회원이 등록한 판매글도 함께 삭제 (외래키 delete cascade 로 변경)
        // int success = noticeService.deleteNoticeAll(nDTO);

        log.info("res? : " + res);
        // log.info("판매글 delete success? : " + success);

        if (res > 0) { // 회원 탈퇴에 성공했다면,
            log.info("deleteForceUser 성공");
            session.invalidate();

            MailDTO mDTO = new MailDTO();

            // 발송할 이메일을 복호화하여 가져옴
            mDTO.setToMail(email);
            mDTO.setTitle("Around-Sell 회원이 탈퇴되었습니다.");
            mDTO.setContents(CmmUtil.nvl(rDTO.getUser_name()) + "님이 탈퇴되었습니다.");

            // mDTO에 세팅한 내용으로, 메일 발송
            mailService.doSendMail(mDTO);
            mDTO = null;
            log.info("회원가입 이메일 발송 완료");
        } else {
            log.info("deleteForceUser 실패");
        }

        pDTO = null;

        log.info(".deleteForceUser End!");
        return res;
    }


    // 회원 정보 조회, 수정을 위해 회원목록을 가져옴
    @RequestMapping(value = "/getUserInfo")
    public String getUser(HttpSession session, HttpServletRequest request, HttpServletResponse response,
                          ModelMap model) throws Exception {
        log.info(this.getClass().getName() + ".getUser Start!");
        // 로그인한 세션의 회원 번호로 상세정보 조회를 위해 회원번호를 저장함
        String user_no = (String) session.getAttribute("SS_USER_NO");

        UserDTO pDTO = new UserDTO();
        pDTO.setUser_no(user_no);
        log.info("회원 정보 조회를 위한 user_no : " + pDTO.getUser_no());

        // 회원번호에 해당하는 회원 정보를 가져옴
        UserDTO rDTO = userService.getUserDetail(pDTO);
        log.info("rDTO null? : " + (rDTO == null));

        if (rDTO == null) {
            rDTO = new UserDTO();
        }

        model.addAttribute("rDTO", rDTO);
        log.info("model에 rDTO값 전송 완료");
        log.info(this.getClass().getName() + ".getUser End!");

        return "/user/myInfo";
    }

    // 이메일, 비밀번호 찾기 폼
    @RequestMapping(value = "/userSearch")
    public String userSearchPage(HttpServletRequest request, HttpServletResponse response, ModelMap model)
            throws Exception {

        log.info(".userSearch Page 시작!");
        return "/user/userSearch";
    }

    // 이메일 찾기
    @RequestMapping(value = "/findEmailUser")
    public String findEmailUser(HttpServletRequest request, HttpServletResponse response, ModelMap model)
            throws Exception {
        log.info(this.getClass().getName() + ".findEmailUser Start!");
        String phone_no = CmmUtil.nvl(request.getParameter("inputPhone"));
        log.info("phone_no : " + phone_no);

        UserDTO pDTO = new UserDTO();
        pDTO.setPhone_no(phone_no);

        UserDTO rDTO = userService.findEmail(pDTO);
        log.info("res : " + rDTO.getUser_email());

        String email = CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()));
        log.info("복호화한 email : " + email);

        // 이메일 복호화
        rDTO.setUser_email(email);

        String url = "";
        String msg = "";

        if (rDTO == null) {
            msg = "일치하는 회원 정보가 없습니다.";
            url = "/userSearch.do";
        } else { //값이 존재한다면
            msg = "회원님의 이메일은 : " + email + " 입니다.";
            url = "/userSearch.do";
        }
        model.addAttribute("msg", msg);
        model.addAttribute("url", url);

        return "/redirect";
    }

    // 비밀번호 찾기 시, 인증번호 발송
    @RequestMapping(value = "/findPassword")
    public String findPassword(HttpServletRequest request, ModelMap model, HttpSession session)
            throws InvalidAlgorithmParameterException, UnsupportedEncodingException, NoSuchPaddingException,
            NoSuchAlgorithmException, BadPaddingException, InvalidKeyException, IllegalBlockSizeException {
        log.info("인증번호 발송 시작!");

        String email = EncryptUtil.encAES128CBC(CmmUtil.nvl(request.getParameter("inputEmail")));
        session.setAttribute("SS_EMAIL", email);

        String auth = "";
        String msg = "";
        String url = "";

        // 랜덤한 8자 인증번호값 담기
        auth = TemppwdUtil.SendTemporaryMail();

        log.info("인증번호 : " + auth);
        MailDTO mDTO = new MailDTO();

        try {
            email = EncryptUtil.decAES128CBC(email);
            log.info("디코딩한 이메일 : " + email);

            // 인증번호 발송 관련 정보를 mailDTO 에 세팅
            mDTO.setToMail(email);
            mDTO.setTitle("AroundSell 인증 번호입니다.");
            mDTO.setContents("인증번호는 : " + auth + "입니다. 인증번호 입력 후, 비밀번호를 변경해 주세요.");

            // 세팅한 정보로 메일 발송
            mailService.doSendMail(mDTO);

            msg = "이메일로 인증번호를 발송하였습니다. 인증번호 입력 후, 비밀번호를 변경해 주세요.";

            model.addAttribute("msg", msg);
            session.setAttribute("SS_AUTH", auth);

            // 변수와 메모리 초기화
            msg = "";
            url = "";
            mDTO = null;

            log.info("인증번호 메일 발송 끝!");

            return "/user/findPwChk";

        } catch (Exception e) {
            msg = "이메일 발송 실패 : " + e.toString();
            url = "/";
            log.info(email.toString());
            e.printStackTrace();

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);
        } finally {
            // 변수, 메모리 초기화
            msg = "";
            url = "";
            mDTO = null;
        }

        log.info("인증번호 발송 끝!");
        return "/redirect";
    }

    // 인증번호 검사
    @RequestMapping(value="/findAuth", method=RequestMethod.POST)
    public String findAuth(HttpServletRequest request, ModelMap model, HttpSession session)
        throws Exception {
        log.info("인증번호 검사 Start!");
        String user_auth = CmmUtil.nvl(request.getParameter("user_auth"));
        String auth = CmmUtil.nvl((String) session.getAttribute("SS_AUTH"));

        log.info("사용자 입력 인증번호 : " + user_auth);
        log.info("세션에 저장된 인증번호 : " + auth);

        String msg = "";
        String url = "";

        // 이메일 인증번호와 사용자가 입력한 인증번호 비교
        if (user_auth.equals(auth)) {
            url = "/findPwUpdate.do";
            msg = "인증에 성공했습니다.";
        }
        else {
            url = "/getIndex.do";
            msg = "인증에 실패했습니다. 다시 시도해 주세요.";
        }
        model.addAttribute("msg", msg);
        model.addAttribute("url", url);

        // 인증번호 후 세션 비우기
        session.removeAttribute("SS_AUTH");

        log.info("인증번호 검사 End!");

        return "/redirect";
    }

    // 인증번호가 일치할 경우, 비밀번호 변경 페이지로 이동
    @RequestMapping("/findPwUpdate")
    public String findPwUpdate() {
        log.info(this.getClass().getName() + ".비밀번호 변경 페이지 Start!");
        return "/user/findPwUpd";
    }

    // 비밀번호 변경하기
    @RequestMapping(value = "updatePw")
    public String updatePw(HttpServletRequest request, HttpSession session, ModelMap model) throws Exception {
        log.info("updatePw start!");
        String email = CmmUtil.nvl((String) session.getAttribute("SS_EMAIL"));
        String member_pw = CmmUtil.nvl(EncryptUtil.encHashSHA256(request.getParameter("password1")));

        log.info("email : " + email);
        log.info("member_pw : " + member_pw);

        String msg = "";
        String url = "";

        UserDTO pDTO = null;

        try {
            pDTO = new UserDTO();

            //where에 email을 사용, 수정할 비밀번호 전달
            pDTO.setUser_email(email);
            pDTO.setPassword(member_pw);

            // 비밀번호 DB반영
            userService.updatePw(pDTO);

            msg = "비밀번호가 변경되었습니다.";
            url = "/logIn.do";

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);

            // 변수와 메모리 초기화
            msg = "";
            url = "";
            pDTO = null;
            log.info("비밀번호 변경 종료");

        } catch (Exception e) {
            msg = "실패하였습니다. : " + e.toString();
            url = "/";


            log.info(e.toString());
            e.printStackTrace();

            model.addAttribute("msg", msg);
            model.addAttribute("url", url);

        } finally {
            // 변수와 메모리 초기화
            msg = "";
            url = "";
            pDTO = null;
        }

        // 세션 비워주기
        session.removeAttribute("SS_EMAIL");

        log.info("session deleted ? : " + session.getAttribute("SS_EMAIL"));

        log.info("updatePw End!");
        return "/redirect";
    }

    // 회원 다중 삭제 구현
    @ResponseBody
    @RequestMapping(value="/deleteUser")
    public int deleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session
                ,@RequestParam(value="valueArr[]") List<String> valueArr) throws Exception{

        log.info(this.getClass().getName() + ".deleteUser(다중 회원 삭제) Start!");

        int res = 0;
        String userNum = "";
        String user_no = (String) session.getAttribute("SS_USER_NO");

        log.info("받아온 회원번호(관리자 - 0) : " + user_no);

        UserDTO pDTO = new UserDTO();

        try {
            // 로그인된 관리자만 회원 삭제 가능
            if (user_no != null && user_no.equals("0")) {

                //valueArr에 담아져 온 회원번호를 세팅하여, 값의 개수만큼 삭제 진행
                for (String i : valueArr) {
                    userNum = i; //userNumber에 값을 담아, dto에 세팅
                    pDTO.setUser_no(userNum);

                    log.info("pDTO에 세팅 되었는지(회원번호/다중) : " + pDTO.getUser_no());
                    userService.deleteUser(pDTO);
                    // 외래키 설정으로, 회원이 작성한 판매글과 장바구니도 함께 삭제됨(on delete cascade)

                    log.info("회원 삭제 완료! : " + userNum);

                }
                //성공하였다면, res값을 1로 세팅(ResponseBody에서 1을 전송하면, 성공을 반환)
                res = 1;
            } else if (!user_no.equals("0")) {
                log.info("회원 아님!");
            }
        } catch (Exception e) {
            log.info("에러! " + e.toString());
            e.printStackTrace();
        }
        finally {

        }
        log.info(this.getClass().getName() + ".회원 삭제하기(다중) End!");

        return res;
    }
}