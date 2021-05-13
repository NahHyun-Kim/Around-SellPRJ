package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.WeatherDTO;
import poly.service.IMailService;
import poly.service.INoticeService;
import poly.service.IUserService;
import poly.service.IWeatherService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class WeatherController {

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    @Resource(name = "WeatherService")
    private IWeatherService weatherService;

    private Logger log = Logger.getLogger(this.getClass());
    // 크롤링한 결과를 실시간으로 보여주는 페이지 임시 작성
    @RequestMapping(value = "/crawlingRes")
    public String crawlingRes() {
        log.info("crawlingRes 결과 페이지 Start!");
        return "/weather/crawlingRes";
    }

    // 날씨정보를 가져와서, responsebody로 넘기기
    @ResponseBody
    @RequestMapping(value = "/getWeather")
    public WeatherDTO getWeather(HttpSession session, HttpServletRequest request)
            throws Exception {
        log.info("getWeather 크롤링 Start!");

        String addr2 = (String) session.getAttribute("SS_USER_ADDR2");
        log.info("가져온 주소 세션 : " + addr2);

        // 임시로 크롤링할 url을 제대로 받아오는지 확인
        String url = "https://www.google.com/search?q=" + addr2 + "+날씨";
        log.info("url test : " + url);

        // 세션에서 가져온 상세주소 값을 서비스로 넘겨줌(크롤링 시 주소 사용)
        WeatherDTO rDTO = weatherService.getWeather(addr2);
        log.info("rDTO null? : " + (rDTO == null));
        log.info("rDTO.weather : " + rDTO.getWeather());

        // 값을 받아왔다면, model에 값을 넘겨줌
        if (rDTO != null) {
            //model.addAttribute("rDTO", rDTO);
            log.info("크롤링한 DTO 전송 완료");
        }

        addr2 = "";
        return rDTO;
    }

    @ResponseBody
    @RequestMapping(value="/getNext")
    public WeatherDTO getNext(HttpServletRequest request, @RequestParam String day, @RequestParam String addr2) throws Exception {

        log.info(this.getClass().getName() + ".getNext(날씨) Start!");

        log.info("day : " + day);
        log.info("addr2 : " + addr2);

        WeatherDTO pDTO = new WeatherDTO();
        pDTO.setAddr2(addr2);
        pDTO.setDay(day);

        log.info("가져온 주소 세션 : " + pDTO.getAddr2());
        log.info("requestParam으로 받아온 day값 : " + pDTO.getDay());

        // 임시로 크롤링할 url을 제대로 받아오는지 확인
        String url = "https://www.google.com/search?q=" + addr2 + "+" + pDTO.getDay() + "+날씨";
        log.info("url test : " + url);

        // 세션에서 가져온 상세주소 값을 서비스로 넘겨줌(크롤링 시 주소 사용)
        WeatherDTO rDTO = weatherService.getNext(pDTO);
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
