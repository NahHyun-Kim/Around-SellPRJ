package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import poly.dto.NoticeDTO;
import poly.service.INoticeService;
import poly.util.CmmUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/*
* Controller 선언해야만 Spring 프레임워크에서 Controller인지 인식 가능
* 자바 서블릿 역할 수행
* */
@Controller
public class NoticeController {

    private Logger log = Logger.getLogger(this.getClass());

    /*
    * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
    * NoticeService(INoticeService 사용)
    * */
    @Resource(name="NoticeService")
    private INoticeService noticeService;

    // 판매글 작성 페이지 이동
    @RequestMapping(value="noticeForm", method = RequestMethod.GET)
    public String noticeForm(HttpServletRequest request, HttpServletResponse response,
                             ModelMap model) throws Exception {
        log.info(this.getClass().getName() + "noticeForm(판매글 작성 페이지) Start!");

        return "/notice/newPost";
    }

    /*
    * 판매글 등록
    * */
    @RequestMapping(value="noticeInsert", method=RequestMethod.POST)
    public String noticeInsert(HttpSession session, HttpServletRequest request,
                               HttpServletResponse response, ModelMap model) throws Exception {

        log.info(this.getClass().getName() + ".noticeInsert(게시글 등록 실행) Start!");

        String msg = "";
        String url = "";

        try {
            //form태그의 name 값을 받아옴(request.getParameter)
            String user_no = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO")); //세션으로부터 받아온 회원 번호
            String goods_title = CmmUtil.nvl(request.getParameter("goods_title")); //상품명
            String goods_detail = CmmUtil.nvl(request.getParameter("goods_detail")); //상품 설명
            String goods_price = CmmUtil.nvl(request.getParameter("goods_price")); //상품 가격
            String goods_addr = CmmUtil.nvl(request.getParameter("goods_addr")); //판매 장소(간략)
            String goods_addr2 = CmmUtil.nvl(request.getParameter("goods_addr2")); //판매 장소(상세주소)
            String category = CmmUtil.nvl(request.getParameter("category")); //카테고리
            String user_name = CmmUtil.nvl((String) session.getAttribute("SS_USER_NAME")); //세션으로부터 받은 회원 이름

            // 제대로 값이 들어왔는지 로그를 찍어 확인
            log.info("user_no : " + user_no);
            log.info("goods_title : " + goods_title);
            log.info("goods_detail : " + goods_detail);
            log.info("goods_price : " + goods_price);
            log.info("goods_addr(간략 주소) : " + goods_addr);
            log.info("goods_addr2(상세 주소) : " + goods_addr2);
            log.info("category : " + category);
            log.info("user_name : " + user_name);

            // insert를 위해 전달할 pDTO에 값을 세팅
            NoticeDTO pDTO = new NoticeDTO();

            pDTO.setUser_no(user_no);
            pDTO.setGoods_title(goods_title);
            pDTO.setGoods_detail(goods_detail);
            pDTO.setGoods_price(goods_price);
            pDTO.setGoods_addr(goods_addr);
            pDTO.setGoods_addr2(goods_addr2);
            pDTO.setCategory(category);
            pDTO.setReg_id(user_name);

            // pDTO에 담은 값을 게시글로 등록하는 함수 호출
            noticeService.InsertNoticeInfo(pDTO);

            // 저장이 완료되었다면, 등록이 완료되었음을 보여줌
            msg = "등록이 완료되었습니다.";

        } catch(Exception e){
            
            //등록이 실패되면 오류 메세지를 보여줌
            msg = "게시글 등록에 실패하였습니다. 다시 시도해 주세요. : " + e.toString();
            log.info(e.toString());
            e.printStackTrace();
        } finally {
            log.info(this.getClass().getName() + ".noticeInsert(게시글 등록 실행) End!");

            // 결과 메세지를 model로 전달
            model.addAttribute("msg", msg);
            //아직 리스트 보기가 구현되지 않아, 임시로 url을 index.do로 보냄
            model.addAttribute("url", "/index.do");
        }

        return "/redirect";
    }
}
