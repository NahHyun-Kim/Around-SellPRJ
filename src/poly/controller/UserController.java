package poly.controller;

import org.springframework.stereotype.Controller;

import org.apache.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.MailDTO;
import poly.dto.UserDTO;
import poly.dto.WeatherDTO;
import poly.service.IMailService;
import poly.service.IUserService;
import poly.util.CmmUtil;
import poly.util.EncryptUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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
            log.info("rDTO.addr2 : " + rDTO.getAddr2());
            msg = "환영합니다!";

            String user_no = rDTO.getUser_no();
            String user_name = rDTO.getUser_name();
            String addr2 = rDTO.getAddr2();

            log.info("addr2 : " + addr2);

            // 회원 번호로 세션 올림, "ㅇㅇㅇ님, 환영합니다" 같은 문구 표시를 위해 user_name도 세션에 올림
            session.setAttribute("SS_USER_NO", user_no);
            session.setAttribute("SS_USER_NAME", user_name);
            session.setAttribute("SS_USER_ADDR2", addr2);
            log.info("session.setAttribute 완료");

            url = "/index.do"; //로그인 성공 후 리턴할 페이지

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
        String url = "/index.do";

        // 세션 삭제(user_name, user_no) - invalidate() 또는 removeAttribute 함수 사용
        session.removeAttribute("SS_USER_NAME");
        session.removeAttribute("SS_USER_NO");

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

        url = "/index.do";
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
        UserDTO pDTO = userService.emailCheck(user_email);

        log.info("pDTO : " + pDTO);
        log.info("userService.emailCheck End!");

        int res = 0;

        // 값이 있다면, res = 1
        if (pDTO != null) {
            res = 1;
        }

        pDTO = null;

        log.info("res : " + res);
        log.info("Email Check End!");
        return res;
    }

    // 폰번호 중복 확인
    @ResponseBody
    @RequestMapping(value="/signup/phoneCheck", method = RequestMethod.POST)
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

        // 회원 번호 받아오기
        String user_no = request.getParameter("no");

        UserDTO pDTO = new UserDTO();
        pDTO.setUser_no(user_no);

        UserDTO rDTO = userService.getUserDetail(pDTO);

        // 결과가 없을 경우, 메시지와 함께 회원 목록으로 리다이렉트
        if (rDTO == null) {
            model.addAttribute("msg", "삭제에 성공했습니다.");
            model.addAttribute("url", "/getUser.do");
            return "/redirect";
        }

        model.addAttribute("rDTO", rDTO);
        return "/admin/userDetail";
    }

    /* 관리자 권한으로 회원 삭제 */
    @ResponseBody
    @RequestMapping(value = "/deleteForceUser", method = RequestMethod.POST)
    public int deleteUser(HttpServletRequest request, ModelMap model) {
        log.info("deleteForceUser Start!");

        String user_no = CmmUtil.nvl(request.getParameter("user_no"));

        log.info("삭제할 회원 번호 : " + user_no);

        UserDTO pDTO = new UserDTO();
        pDTO.setUser_no(user_no);
        log.info("pDTO에 보낼 회원 번호 : " + pDTO.getUser_no());

        //구현 예정
        int res = userService.deleteForceUser(pDTO);
        log.info("res? : " + res);

        if (res > 0) {
            log.info("deleteForceUser 성공");
        } else {
            log.info("deleteForceUser 실패");
        }

        pDTO = null;

        log.info(".deleteForceUser End!");
        return res;
    }


    @RequestMapping(value="/crawlingRes")
    public String crawlingRes() {
        log.info("crawlingRes 결과 페이지 Start!");
        return "/crawlingRes";
    }

    @ResponseBody
    @RequestMapping(value = "/getWeather")
    public WeatherDTO getWeather(HttpSession session, HttpServletRequest request)
        throws Exception {
        log.info("getWeather 크롤링 Start!");

        String addr2 = (String) session.getAttribute("SS_USER_ADDR2");
        log.info("가져온 주소 세션 : " + addr2);

        // 임시로 크롤링할 url을 제대로 받아오는지 확인
        String url = "https://www.google.com/search?q=" + addr2 + "+날씨" ;
        log.info("url test : " + url);

        // 세션에서 가져온 상세주소 값을 서비스로 넘겨줌(크롤링 시 주소 사용)
        WeatherDTO rDTO = userService.getWeather(addr2);
        log.info("rDTO null? : " + (rDTO == null));
        log.info("rDTO.weather : " + rDTO.getWeather());

        // 값을 받아왔다면, model에 값을 넘겨줌
        if (rDTO != null) {
            //model.addAttribute("rDTO", rDTO);
            log.info("크롤링한 DTO 전송 완료");
        }

        return rDTO;
    }


}