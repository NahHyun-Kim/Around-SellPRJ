package poly.persistance.mapper;

import config.Mapper;
import poly.dto.UserDTO;

@Mapper("UserMapper")
public interface IUserMapper {

    // 회원 가입하기(회원정보 등록)
    int insertUser(UserDTO pDTO) throws Exception;

    // 회원 가입 전, 중복 회원가입 방지
    UserDTO emailCheck(String user_email) throws Exception;
}
