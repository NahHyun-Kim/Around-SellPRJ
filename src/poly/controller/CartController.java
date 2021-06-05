package poly.controller;

import org.apache.avro.generic.GenericData;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.CartDTO;
import poly.dto.NoticeDTO;
import poly.service.*;
import poly.util.CmmUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Controller
public class CartController {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    @Resource(name = "CartService")
    private ICartService cartService;

    @Resource(name = "SearchService")
    private ISearchService searchService;

    // 관심상품 페이지(불러오기)
    @RequestMapping(value="/myCart")
    public String getCart(HttpServletRequest request, ModelMap model, HttpSession session) throws Exception {

        log.info(this.getClass().getClass() + ".관심상품 페이지 불러오기 Start!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        log.info("회원번호 받아왔는지 : " + user_no);

        List<CartDTO> rList = new ArrayList<CartDTO>();
        // 로그인을 하지 않은 상태라면, 로그인 창으로 이동
        try {
            /*if (user_no == null) {
                model.addAttribute("msg", "로그인 후 이용해 주세요.");
                model.addAttribute("url", "logIn.do");
                //model.addAttribute("type", "info");
                return "/redirect";

                // 로그인이 되었다면, 해당 사용자가 담은 장바구니 상품을 보여줌
            } else {*/
                CartDTO pDTO = new CartDTO();
                pDTO.setUser_no(user_no);

                rList = (List<CartDTO>) cartService.myCart(pDTO);
                log.info("rDTO 값 받아왔는지 ? : " + (rList == null));

                pDTO = null;
           // }
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

        //int success = cartService.cartChk(pDTO);
        //log.info("중복 되었는지(1이면 중복) ? : " + success);

        int res = 0;
        //if (success > 0) { // 중복되었다면, success값을 리턴하여 insert가 실행되지 않도록 함.
            //return success;
        //} else if (success == 0) {
            res = cartService.InsertCart(pDTO);

            log.info("등록 성공 ? : " + res);

        //}

        log.info("관심상품 등록 End!");

        return res;
    }

    // 관심상품 등록 전, 중복 여부 체크
    @ResponseBody
    @RequestMapping
    public int cartChk(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                       @RequestParam(value="user_no") String user_no,
                       @RequestParam(value="gn") String gn) throws Exception {

        log.info(this.getClass().getName() + "중복 체크 시작!");

        log.info("받아온 회원번호 : " + user_no);
        log.info("받아온 상품번호 : " + gn);

        CartDTO pDTO = new CartDTO();
        pDTO.setUser_no(user_no);
        pDTO.setGoods_no(gn);

        CartDTO rDTO = cartService.cartChk(pDTO);
        log.info("rDTO에 값이 있는지 ? : " + (rDTO == null));

        int success = 0;

        // 중복값이 없으면, 0을 리턴하여 그 뒤에 insert를 호출
        if (rDTO == null) {
            success = 0;
            // 중복값이 있으면, 1을 리턴하여 false
        } else {
            success = 1;
        }

        log.info("중복 체크 여부? (1이면 있음, 0이면 없음) : " + success);
        log.info(this.getClass().getName() + "중복 체크 끝!");

        return success;

    }

    //관심상품 삭제하기
    @ResponseBody
    @RequestMapping(value="/deleteCart")
    public int deleteCart(HttpServletRequest request, HttpServletResponse response,
                          HttpSession session, @RequestParam(value="valueArr[]") List<String> valueArr) throws Exception {
        log.info(this.getClass().getName() + ".관심상품 삭제하기 Start!");

        int res = 0;
        String cartNum = "";
        String user_no = (String) session.getAttribute("SS_USER_NO");

        log.info("받아온 회원번호 : " + user_no);

        CartDTO pDTO = new CartDTO();

        if (user_no != null) {
            pDTO.setUser_no(user_no);
            log.info("pDTO에 세팅 되었는지? : " + pDTO.getUser_no());

            // valueArr에 담아져 온 상품번호를 세팅하여, 삭제 진행
            // 리스트형 변수 valueArr가 가지고 있는 값의 개수만큼 반복
            for (String i : valueArr) {
                cartNum = i;
                pDTO.setGoods_no(cartNum);
                log.info("pDTO에 세팅 되었는지(굿즈번호) : " + pDTO.getGoods_no());
                cartService.deleteCart(pDTO);

                log.info("cartNum 삭제 완료!: " + cartNum);

            }
            res = 1;
        }
        log.info(this.getClass().getName() + ".관심상품 삭제하기 End!");
        return res;
    }

    // 최근 본 상품 페이지 시작
    @RequestMapping(value="mySee")
    public String mySee(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                        ModelMap model) throws Exception {

        log.info("최근 본 상품 페이지 시작!");

        return "/cart/mySee";
    }
    
    /*최근 본 상품 불러오기*/
    //, produces = "application/text; charset=utf8"
    @ResponseBody
    @RequestMapping(value="getGoods")
    public Set getGoods(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

        log.info(this.getClass().getName() + ".getGoods(최근 본 상품 불러오기) Start!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        log.info("user_no(회원을 위한 최근 본 상품) : " + user_no);

        NoticeDTO pDTO = new NoticeDTO();
        pDTO.setUser_no(user_no);

        // 회원번호에 해당하는 최근검색어 가져오기(redis)
        Set rList = searchService.getGoods(pDTO);

        if (rList == null) {
            rList = new LinkedHashSet<>();
        }
        pDTO = null;

        log.info(this.getClass().getName() + ".getGoods(최근 본 상품 불러오기) End!");

        return rList;
    }
}
