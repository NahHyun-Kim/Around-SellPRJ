package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import poly.dto.Criteria;
import poly.service.INoticeService;
import poly.service.IPageService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@Controller
public class PageController {

    private Logger log = Logger.getLogger(this.getClass());

    /*
     * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
     * NoticeService(INoticeService 사용)
     * */
    @Resource(name="NoticeService")
    private INoticeService noticeService;

    @Resource(name="PageService")
    private IPageService pageService;

    @RequestMapping(value="/test")
    public String test() {
        log.info("PageController test jsp Start!!");

        return "/notice/test";
    }

    // 판매글 리스트를 페이징 처리하여 불러오기
    @RequestMapping(value="/pagingList")
    public String pagingList(Criteria pDTO, ModelMap model,
                             @RequestParam(value="nowPage", required = false) String nowPage,
                             @RequestParam(value="cntPerPage", required = false) String cntPerPage)
        throws Exception {

        log.info(this.getClass().getName() + ".pagingList(페이징 판매글 리스트) Start!");

        // 총 게시물 수를 가져옴(count *)
        int total = pageService.cntNotice();
        log.info("가져온 게시물 수(int total) : " + total);

        // 페이지 정보를 받아오지 못할 경우, 기본값을 지정
        if (nowPage == null & cntPerPage == null) {
            nowPage = "1";
            cntPerPage = "9";

        } else if (nowPage == null) {
            nowPage = "1";

        } else if (cntPerPage == null) {
            cntPerPage = "9";

        }

        // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
        pDTO = new Criteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

        model.addAttribute("paging",pDTO);
        model.addAttribute("sellList", pageService.selectPaging(pDTO));

        log.info(this.getClass().getName() + ".pagingList(판매글 리스트 페이징) End!");

        return "/notice/pagingList";
    }

}
