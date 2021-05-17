package poly.service;

import poly.dto.UserDTO;
import poly.dto.WeatherDTO;

import java.util.List;

public interface IUserService {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO);

    // 중복 회원가입 방지(이메일 중복확인)
    UserDTO emailCheck(String user_email);

    // 핸드폰 번호 중복 등록 방지
    UserDTO phoneCheck(String phone_no);

    // 로그인하기
    UserDTO getLogin(UserDTO pDTO);

    // 관리자 회원목록 조회
    List<UserDTO> getUser();

    // 관리자 회원 상세정보 조회(회원정보 조회, 수정을 위해서도 사용된다.)
    UserDTO getUserDetail(UserDTO pDTO);

    // 관리자 권한으로 회원 탈퇴
    int deleteForceUser(UserDTO pDTO);

    // 회원 정보 수정을 위한 회원정보 가져오기
    UserDTO getUserInfo(UserDTO pDTO);

    // 비밀번호 변경
    int updatePw(UserDTO pDTO);

    // 회원정보 수정
    void updateUser(UserDTO pDTO);

    // 핸드폰 번호로 회원 이메일 찾기
    UserDTO findEmail(UserDTO pDTO);

    // 비밀번호 변경 시, 유효성 체크를 위함
    UserDTO pwdCheck(UserDTO pDTO);
}
