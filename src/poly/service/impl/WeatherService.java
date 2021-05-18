package poly.service.impl;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.stereotype.Service;
import poly.dto.WeatherDTO;
import poly.persistance.mapper.IUserMapper;
import poly.service.IWeatherService;

import javax.annotation.Resource;

@Service("WeatherService")
public class WeatherService implements IWeatherService {

    private Logger log = Logger.getLogger(this.getClass());

    // 위치기반 날씨정보 크롤링
    @Override
    public WeatherDTO getWeather(String addr2) throws Exception {

        log.info(this.getClass().getName() + ".getWeather Start!");

        WeatherDTO rDTO = new WeatherDTO();

        // 날씨 정보를 가져올 사이트 주소
        String url = "http://www.google.com/search?q=" + addr2 + "+날씨" ;
        log.info("url : " + url);

        // JSOUP 라이브러리를 통해 사이트가 접속되면, 그 사이트의 전체 HTML 소스를 저장할 변수
        Document doc = null;

        // 사이트 접속(http 프로토콜만 가능)
        doc = Jsoup.connect(url).get();

        String temperature = doc.select("span#wob_tm").text();
        String weather = doc.select("span#wob_dc").text();
        String rainrate = doc.select("span#wob_pp").text();
        String imgs = doc.select("img.wob_tci").attr("src");

        rDTO.setWeather(weather);
        rDTO.setTemperature(temperature);
        rDTO.setRainrate(rainrate);
        rDTO.setImgs(imgs);

        log.info("rDTO.temp : " + rDTO.getTemperature());
        log.info("rDTO.weather : " + rDTO.getWeather());
        log.info("rDTO.rainrate : " + rDTO.getRainrate());
        log.info("rDTO.Img주소 : " + rDTO.getImgs());
        log.info(this.getClass().getName() + ".getWeather End!");

        return rDTO;
    }

    @Override
    public WeatherDTO getNext(WeatherDTO pDTO) throws Exception {
        log.info(this.getClass().getName() + ".getWeather Start!");

        WeatherDTO rDTO = new WeatherDTO();

        // 날씨 정보를 가져올 사이트 주소
        String url = "http://www.google.com/search?q=" + pDTO.getAddr2() + "+" + pDTO.getDay() + "+날씨" ;
        log.info("크롤링할 url : " + url);

        // JSOUP 라이브러리를 통해 사이트가 접속되면, 그 사이트의 전체 HTML 소스를 저장할 변수
        Document doc = null;

        // 사이트 접속(http 프로토콜만 가능)
        doc = Jsoup.connect(url).get();

        String temperature = doc.select("span#wob_tm").text();
        String weather = doc.select("span#wob_dc").text();
        String rainrate = doc.select("span#wob_pp").text();
        String imgs = doc.select("img.wob_tci").attr("src");

        rDTO.setWeather(weather);
        rDTO.setTemperature(temperature);
        rDTO.setRainrate(rainrate);
        rDTO.setImgs(imgs);

        log.info("rDTO.temp : " + rDTO.getTemperature());
        log.info("rDTO.weather : " + rDTO.getWeather());
        log.info("rDTO.rainrate : " + rDTO.getRainrate());
        log.info("rDTO.Img주소 : " + rDTO.getImgs());
        log.info(this.getClass().getName() + ".getWeather End!");

        return rDTO;
    }

}
