package poly.controller;

import org.springframework.stereotype.Controller;

import org.apache.log4j.Logger;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import poly.dto.MailDTO;
import poly.dto.UserDTO;
import poly.service.IMailService;
import poly.service.IUserService;
import poly.util.CmmUtil;
import poly.util.EncryptUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
 * Controller 선언해야만 Spring 프레임워크에서 Controller인지 인식 가능
 * 자바 서블릿 역할 수행
 * */
@Controller
public class UserController {

    @Resource(name="MailService")
    private IMailService mailService;

    @Resource(name="UserService")
    private IUserService userService;

    private Logger log = Logger.getLogger(this.getClass());

    //회원가입 화면
    @RequestMapping(value="signup")
    public String SignUp(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
        log.info(this.getClass().getName() + ".signup 시작!");
        return "/user/signUp";
    }

    //회원가입 진행
    @RequestMapping(value="/insertUser", method= RequestMethod.POST)
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
        String[] addrsplit = CmmUtil.nvl(request.getParameter("addr")).split(" ",3);
        String addr2 = addrsplit[1].trim();

        UserDTO pDTO = new UserDTO();

        log.info("pDTO 세팅 시작");
        // jsp에서 가져온 값을 DTO에 저장
        pDTO.setUser_email(user_email);
        pDTO.setPassword(password);
        pDTO.setUser_name(user_name);
        pDTO.setAddr(addr);
        pDTO.setAddr2(addr2);

        // 회원정보가 제대로 전달되었는지 로그를 통해 확인
        log.info("user_email : " + user_email);
        log.info("password : " + password);
        log.info("user_name : " + user_name);
        log.info("addr : " + addr);
        log.info("지역구(addr2) : " + addr2);

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
                msg =  "회원정보를 확인 후 가입을 진행해 주세요.";
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
}
