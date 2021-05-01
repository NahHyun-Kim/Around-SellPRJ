package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import poly.service.IUserService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
public class MyController {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name="UserService")
    private IUserService userService;

    // 마이페이지
    @RequestMapping(value="/myPage")
    public String myPage() {
        log.info(this.getClass());
        return "/user/myPage";
    }

    // 회원정보 수정 페이지(주소, 비밀번호 변경, 회원 탈퇴)
    @RequestMapping(value="/myPage/editUser")
    public String editUser() {
        log.info(this.getClass());
        return "/user/editUser";
    }

}
