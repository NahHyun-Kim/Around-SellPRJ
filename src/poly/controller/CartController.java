package poly.controller;

import org.apache.avro.generic.GenericData;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.CartDTO;
import poly.dto.NoticeDTO;
import poly.service.ICartService;
import poly.service.IMailService;
import poly.service.INoticeService;
import poly.service.IUserService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class CartController {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    @Resource(name = "CartService")
    private ICartService cartService;

    // 관심상품 페이지(불러오기)
    @RequestMapping(value="/myCart")
    public String getCart(HttpServletRequest request, ModelMap model, HttpSession session) throws Exception {

        log.info(this.getClass().getClass() + ".관심상품 페이지 불러오기 Start!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        log.info("회원번호 받아왔는지 : " + user_no);

        List<CartDTO> rList = new ArrayList<CartDTO>();
        // 로그인을 하지 않은 상태라면, 로그인 창으로 이동
        try {
            if (user_no == null) {
                model.addAttribute("msg", "로그인 후 이용해 주세요.");
                model.addAttribute("url", "logIn.do");
                return "/redirect";

                // 로그인이 되었다면, 해당 사용자가 담은 장바구니 상품을 보여줌
            } else {
                CartDTO pDTO = new CartDTO();
                pDTO.setUser_no(user_no);

                rList = (List<CartDTO>) cartService.myCart(pDTO);
                log.info("rDTO 값 받아왔는지 ? : " + (rList == null));

                pDTO = null;
            }
        } catch(Exception e) {
            log.info("에러 발생!" + e.toString());
            e.printStackTrace();
        }
        finally {
            model.addAttribute("rList", rList);
        }
        log.info(this.getClass().getClass() + ".관심상품 페이지 불러오기 End!");

        return "/cart/myCart";
    }

    // 관심상품 등록하기
    @ResponseBody
    @RequestMapping(value="/insertCart")
    public int insertCart(HttpServletRequest request, HttpSession session, HttpServletResponse response) throws Exception {

        log.info(this.getClass().getClass() + ".관심상품 등록 Start!");

        String gn = (String) request.getParameter("gn");
        String user_no = (String) session.getAttribute("SS_USER_NO");

        log.info("가져온 판매글 번호, 회원 번호 : " + gn);
        log.info("가져온 회원 번호 : " + user_no);

        CartDTO pDTO = new CartDTO();
        pDTO.setGoods_no(gn);
        pDTO.setUser_no(user_no);

        int res = cartService.InsertCart(pDTO);

        log.info("등록 성공 ? : " + res);

        log.info("관심상품 등록 End!");

        return res;
    }

    // 관심상품 삭제하기


}
