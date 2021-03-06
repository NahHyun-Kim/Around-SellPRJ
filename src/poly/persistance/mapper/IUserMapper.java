package poly.persistance.mapper;

import config.Mapper;
import poly.dto.UserDTO;

import java.util.List;

@Mapper("UserMapper")
public interface IUserMapper {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO);

    // 회원 가입 전, 중복 회원가입 방지
    UserDTO emailCheck(String user_email);

    // 핸드폰 번호 중복 등록 방지
    UserDTO phoneCheck(String phone_no);

    //  로그인하기
    UserDTO getLogin(UserDTO pDTO);

    // 관리자 권한으로 회원 탈퇴
    int deleteForceUser(UserDTO pDTO);

    // 관리자 회원 목록 조회
    List<UserDTO> getUser();

    // 관리자 회원 상세정보 조회
    UserDTO getUserDetail(UserDTO pDTO);

    // 비밀번호 변경
    int updatePw(UserDTO pDTO);

    // 회원정보 수정
    void updateUser(UserDTO pDTO);

    // 핸드폰 번호로 회원 이메일 찾기
    UserDTO findEmail(UserDTO pDTO);

    // 비밀번호 변경 시, 유효성 체크를 위함
    UserDTO pwdCheck(UserDTO pDTO);

    // 회원정보 수정 시 비밀번호 변경
    void updateMyPw(UserDTO pDTO);

    // 비밀번호 변경 시, 기존 비밀번호와 다른 비밀번호로 변경
    UserDTO myPwdChk(UserDTO pDTO);

    // 회원 다중삭제 기능 구현
    int deleteUser(UserDTO pDTO);

}