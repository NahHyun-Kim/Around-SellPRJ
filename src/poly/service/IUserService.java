package poly.service;

import poly.dto.UserDTO;

public interface IUserService {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO) throws Exception;
    // 중복 회원가입 방지(이메일 중복확인)
    UserDTO emailCheck(String user_email) throws Exception;

}
