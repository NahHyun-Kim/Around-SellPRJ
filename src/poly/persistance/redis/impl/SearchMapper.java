package poly.persistance.redis.impl;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.stereotype.Component;
import poly.dto.NoticeDTO;
import poly.persistance.redis.ISearchMapper;
import poly.util.CmmUtil;

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Component("SearchMapper")
public class SearchMapper implements ISearchMapper {

    private Logger log = Logger.getLogger(this.getClass());

    @Autowired
    public RedisTemplate<String, Object> redisDB;

    // 최근 검색어 저장
    @Override
    public void insertKeyword(NoticeDTO pDTO) throws Exception {
        log.info(this.getClass().getName() + ".insertKeyword Start!");

        String user_no = pDTO.getUser_no();
        String keyword = pDTO.getKeyword();

        // 회원 번호로 키 생성
        String redisKey = "UserNo_" + user_no;

        /*
        * Redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입)
        */
        redisDB.setKeySerializer(new StringRedisSerializer()); // String 타입
        redisDB.setValueSerializer(new StringRedisSerializer());

        // 저장된 전체 레코드 수
        long cnt = redisDB.opsForZSet().size(redisKey);

        // 값이 저장될때마다 컬렉션 크기 +1 하면 1,2,3,4와 같은 순서로 저장
        redisDB.opsForZSet().add(redisKey, keyword, cnt+1);
        redisDB.expire(redisKey, 2, TimeUnit.DAYS); // 2일 후 삭제됨.

        log.info(this.getClass().getName() + ".insertKeyword End!");
    }

    // 최근 검색어 불러오기
    @Override
    public Set getKeyword(NoticeDTO pDTO) throws Exception {

        log.info(this.getClass().getName() + ".getKeyword Start!");

        String user_no = pDTO.getUser_no();

        String redisKey = "UserNo_" + user_no;

        /*
        * Redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입으로 지정함)
         */
        redisDB.setValueSerializer(new StringRedisSerializer()); //String 타입
        redisDB.setValueSerializer(new StringRedisSerializer());

        // 중복 데이터를 저장할 수 없고, 입력된 순서대로 데이터를 관리하는 LinkedHashSet
        Set rSet = new LinkedHashSet();

        // 저장된 key값이 있다면, 전체 레코드 수만큼(중복 제거) 0부터 cnt까지 범위의 검색어를 가져옴
        if (redisDB.hasKey(redisKey)) {

            // 저장된 전체 레코드 수
            long cnt = redisDB.opsForZSet().size(redisKey);
            rSet = (Set) redisDB.opsForZSet().range(redisKey, 0, cnt);

            if (rSet == null) {
                rSet = new LinkedHashSet<String>();
            }

            Iterator<String> it = rSet.iterator();

            while(it.hasNext()) { //다음 값이 있을때까지
                String value = CmmUtil.nvl((String) it.next());
                log.info("가져온 검색어 : " + value);
            }
        }

        log.info(this.getClass().getName() + ".getKeyword End!");
        return rSet;
    }


}
