package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
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

}
