package poly.service.impl;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import poly.dto.UserDTO;
import poly.persistance.mapper.IUserMapper;
import poly.service.IUserService;

import javax.annotation.Resource;

@Service("UserService")
public class UserService implements IUserService {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name="UserMapper")
    private IUserMapper userMapper;

    // 회원가입
    @Override
    public int insertUser(UserDTO pDTO) throws Exception {
        log.info(this.getClass().getName() + ".insertUser Start!");
        return userMapper.insertUser(pDTO);
    }

    // 이메일 중복 확인
    @Override
    public UserDTO emailCheck(String user_email) throws Exception {
        return userMapper.emailCheck(user_email);
    }


}
