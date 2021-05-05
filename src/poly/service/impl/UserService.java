package poly.service.impl;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import poly.dto.UserDTO;
import poly.dto.WeatherDTO;
import poly.persistance.mapper.IUserMapper;
import poly.service.IUserService;

import javax.annotation.Resource;
import java.util.List;

@Service("UserService")
public class UserService implements IUserService {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name="UserMapper")
    private IUserMapper userMapper;

    // 회원가입
    @Override
    public int insertUser(UserDTO pDTO) {
        log.info(this.getClass().getName() + ".insertUser Start!");
        return userMapper.insertUser(pDTO);
    }

    // 이메일 중복 확인
    @Override
    public UserDTO emailCheck(String user_email) {
        return userMapper.emailCheck(user_email);
    }

    // 핸드폰번호 중복 등록 방지
    @Override
    public UserDTO phoneCheck(String phone_no) {
        return userMapper.phoneCheck(phone_no);
    }

    // 로그인하기
    @Override
    public UserDTO getLogin(UserDTO pDTO) {
        return userMapper.getLogin(pDTO);
    }

    // 관리자 회원목록 조회하기
    @Override
    public List<UserDTO> getUser() {
        return userMapper.getUser();
    }

    // 관리자 회원 상세보기 조회
    @Override
    public UserDTO getUserDetail(UserDTO pDTO) {
        return userMapper.getUserDetail(pDTO);
    }

    // 관리자 회원 강제 삭제
    @Override
    public int deleteForceUser(UserDTO pDTO) {
        return userMapper.deleteForceUser(pDTO);
    }

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

        rDTO.setWeather(weather);
        rDTO.setTemperature(temperature);
        rDTO.setRainrate(rainrate);

        log.info("rDTO.temp : " + rDTO.getTemperature());
        log.info("rDTO.weather : " + rDTO.getWeather());
        log.info("rDTO.rainrate : " + rDTO.getRainrate());
        log.info(this.getClass().getName() + ".getWeather End!");

        return rDTO;
    }

    // 회원 정보 수정을 위해 회원 정보 가져오기
    @Override
    public UserDTO getUserInfo(UserDTO pDTO) {
        return userMapper.getUserDetail(pDTO);
    }


}
