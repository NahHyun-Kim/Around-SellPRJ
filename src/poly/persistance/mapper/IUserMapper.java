package poly.persistance.mapper;

import config.Mapper;
import poly.dto.UserDTO;

import java.util.List;

@Mapper("UserMapper")
public interface IUserMapper {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO) throws Exception;

    // 회원 가입 전, 중복 회원가입 방지
    UserDTO emailCheck(String user_email) throws Exception;

    //  로그인하기
    UserDTO getLogin(UserDTO pDTO) throws Exception;

    // 관리자 권한으로 회원 탈퇴
    int deleteForceUser(UserDTO pDTO) throws Exception;

    // 관리자 회원 조회
    List<UserDTO> getMember() throws Exception;
}