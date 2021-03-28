package poly.dealprj.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import poly.dealprj.domain.User;

@Mapper
public interface UserMapper {

    //id값을 파라미터로 넘겨서 User 객체를 받아옴
    @Select("SELECT * FROM test01 WHERE id = #{id}")
    User findAll(@Param("id") String id);
}
