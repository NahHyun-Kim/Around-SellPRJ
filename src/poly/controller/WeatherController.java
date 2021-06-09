package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import poly.dto.WeatherDTO;
import poly.service.IMailService;
import poly.service.INoticeService;
import poly.service.IUserService;
import poly.service.IWeatherService;
import poly.util.CmmUtil;
import poly.util.privateUtil;
import test.Test;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.util.ArrayList;
import java.util.List;

@Controller
public class WeatherController {

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    @Resource(name = "WeatherService")
    private IWeatherService weatherService;

    private Logger log = Logger.getLogger(this.getClass());

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

    @RequestMapping(value="apiTest")
    public String apiTest(HttpServletRequest request, HttpServletResponse response) {
        return "/weather/apiTest";
    }

    //통합대기환경지수 페이지 호출
    @ResponseBody
    @RequestMapping(value="getAir", method= RequestMethod.GET)
    public List<WeatherDTO> getCaiList(HttpServletRequest request, HttpServletResponse response) throws Exception{

        log.info(this.getClass().getName() + "getAir start!!");

        WeatherDTO pDTO = new WeatherDTO();
        List<WeatherDTO> rList = new ArrayList<>();

        try{

            while(true){
                // parsing할 url 지정(API 키 포함해서)
                String url = "http://openAPI.seoul.go.kr:8088/" + privateUtil.openApi + "/xml/ListAirQualityByDistrictService/1/25/";
                log.info("인증키 포함 url : " + url);

                DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
                DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
                Document doc = dBuilder.parse(url);

                // root tag
                doc.getDocumentElement().normalize();
                System.out.println("Root element :" + doc.getDocumentElement().getNodeName());

                // 파싱할 tag
                NodeList nList = doc.getElementsByTagName("row");

                System.out.println("파싱할 리스트 수 : "+ nList.getLength());

                for(int temp = 0; temp < nList.getLength(); temp++){
                    Node nNode = nList.item(temp);
                    if(nNode.getNodeType() == Node.ELEMENT_NODE){

                        Element eElement = (Element) nNode;
                        System.out.println("######################");

                        pDTO.setMsrstename(CmmUtil.nvl(Test.getTagValue("MSRSTENAME", eElement))); //측정소명(자치구)
                        pDTO.setGrade(CmmUtil.nvl(Test.getTagValue("GRADE", eElement)));//지수등급
                        pDTO.setPm10(CmmUtil.nvl(Test.getTagValue("PM10", eElement))); //미세먼지
                        pDTO.setPm25(CmmUtil.nvl(Test.getTagValue("PM25", eElement))); //초미세먼지


                        rList.add(pDTO); // 측정 정보 List 형태로 저장

                        // pDTO 변수 초기화
                        pDTO = null;

                        if(pDTO == null) {
                            pDTO = new WeatherDTO();
                        }
                    }
                }
                break;
            }


        } catch (Exception e){
            e.printStackTrace();
        }

        return rList;

    }
}
