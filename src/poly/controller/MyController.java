package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import poly.dto.NoticeDTO;
import poly.service.INoticeService;
import poly.service.IUserService;
import poly.util.CmmUtil;

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
    // 회원정보 수정 페이지(주소, 비밀번호 변경, 회원 탈퇴)
    @RequestMapping(value="/myPage/editUser")
    public String editUser() {
        log.info(this.getClass());
        return "/user/editUser";
    }

}
