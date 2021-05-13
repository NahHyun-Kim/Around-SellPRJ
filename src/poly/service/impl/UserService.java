package poly.service.impl;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
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

    // 회원 정보 수정을 위해 회원 정보 가져오기
    @Override
    public UserDTO getUserInfo(UserDTO pDTO) {
        return userMapper.getUserDetail(pDTO);
    }

    // 비밀번호 변경
    @Override
    public int updatePw(UserDTO pDTO) {
        return userMapper.updatePw(pDTO);
    }

    @Override
    public UserDTO findEmail(UserDTO pDTO) {
        return userMapper.findEmail(pDTO);
    }


    // 핸드폰 번호로 회원 이메일 찾기
    /* @Override
    public String findEmail(String phone_no) {
        return userMapper.findEmail(phone_no);
    } */


}
