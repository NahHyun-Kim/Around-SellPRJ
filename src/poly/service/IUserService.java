package poly.service;

import poly.dto.UserDTO;

import java.util.List;

public interface IUserService {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO) throws Exception;
    // 중복 회원가입 방지(이메일 중복확인)
    UserDTO emailCheck(String user_email) throws Exception;
    // 로그인하기
    UserDTO getLogin(UserDTO pDTO) throws Exception;
    // 관리자 회원목록 조회
    List<UserDTO> getUser();
    // 관리자 회원 상세정보 조회
    UserDTO getUserDetail(UserDTO pDTO);
}
