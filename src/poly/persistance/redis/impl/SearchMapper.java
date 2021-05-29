package poly.persistance.redis.impl;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.stereotype.Component;
import poly.dto.NoticeDTO;
import poly.dto.RedisDTO;
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
        log.info("가져온 키값(유저번호 붙인) : " + redisKey);

        /*
        * Redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입으로 지정함)
         */
        redisDB.setKeySerializer(new StringRedisSerializer()); //String 타입
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

    // 최근 본 상품 저장하기
    @Override
    public void insertGoods(NoticeDTO pDTO) throws Exception {

        log.info(this.getClass().getName() + ".Mapper 최근상품 저장 시작!");

        String user_no = pDTO.getUser_no();
        String imgs = pDTO.getImgs();
        String goods_title = pDTO.getGoods_title();
        String goods_no = pDTO.getGoods_no();

        // json 형태의 String으로 redis에 저장(추후 불러올때, json.parse로 json 객체로 변환)
        String jsonGoods = "{\"" + "goods_no" + "\" : \"" + goods_no + "\", \""
                + "imgs" + "\" : \"" + imgs + "\", \"" + "goods_title" + "\" : \"" + goods_title + "\"}";

        /*
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(jsonGoods);
        JSONObject jsonObj = (JSONObject) obj; */

        String redisKey = "Goods_UserNo_" + user_no;
        log.info("키값 : " + redisKey);

        log.info("mapper에서 pDTO값 가져왔는지 ? : " + goods_no);

        // redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입으로 지정)
        redisDB.setKeySerializer(new StringRedisSerializer());

        // DTO를 JSON구조로 변경
        redisDB.setValueSerializer(new StringRedisSerializer());

        log.info("json 형태 결과값 : " + jsonGoods);

        // 추가해봄
        // 저장된 key값이 있다면, 전체 레코드 수만큼(중복 제거) min-0 ~ max-cnt 범위의 검색어를 가져옴
        try {
        if (redisDB.hasKey(redisKey)) {

            log.info("이미 키 있음! 조회 시작");

            Set rSet = (Set) redisDB.opsForSet().members(redisKey);

            Iterator<String> it = rSet.iterator();

            while (it.hasNext()) {
                String value = CmmUtil.nvl((String) it.next());

                /* 이미 최근 본 상품에 들어가 있는 데이터라면, 기존 데이터를 삭제하고 새로운 cnt로 최신 목록으로 insert함
                 */
                if (value.equals(jsonGoods)) {
                    long flag = redisDB.opsForZSet().remove(redisKey, jsonGoods);
                }
            }
                   }
        } catch (Exception e) {

        } finally {

                long cnt = redisDB.opsForZSet().size(redisKey);

                System.out.println("cnt :" + cnt);
                // 값이 저장될때마다 컬렉션 크기 +1 하면 1,2,3,4와 같은 순서로 저장
                //redisDB.opsForZSet().add(redisKey, jsonGoods, cnt+1);
                redisDB.opsForZSet().add(redisKey, jsonGoods, cnt);

                redisDB.expire(redisKey, 2, TimeUnit.DAYS); // 2일 후 삭제됨.

                // 저장되는 데이터의 유효기간(TTL)은 2일로 정의
                redisDB.expire(redisKey, 2, TimeUnit.DAYS);

                log.info(this.getClass().getName() + ".Mapper 최근상품 저장 끝!");

            }
        }


    // 최근 본 상품 불러오기
    @Override
    public Set getGoods(NoticeDTO pDTO) throws Exception {

        log.info(this.getClass().getName() + ".getGoods Start!");

        String user_no = pDTO.getUser_no();

        String redisKey = "Goods_UserNo_" + user_no;
        log.info("가져온 키값(유저번호 붙인) : " + redisKey);

        /*
         * Redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입으로 지정함)
         */
        redisDB.setKeySerializer(new StringRedisSerializer()); //String 타입
        redisDB.setValueSerializer(new StringRedisSerializer());

        // 중복 데이터를 저장할 수 없고, 입력된 순서대로 데이터를 관리하는 LinkedHashSet
        Set rSet = new LinkedHashSet();

        // 저장된 key값이 있다면, 전체 레코드 수만큼(중복 제거) cnt부터 0까지(최근 저장부터 가져옴) 범위의 검색어를 가져옴
        if (redisDB.hasKey(redisKey)) {

            // 저장된 전체 레코드 수
            long cnt = redisDB.opsForZSet().size(redisKey);
            rSet = (Set) redisDB.opsForZSet().rangeByScore(redisKey, 0, cnt+1);

            if (rSet == null) {
                rSet = new LinkedHashSet<String>();
            }

            Iterator<String> it = rSet.iterator();

            while(it.hasNext()) { //다음 값이 있을때까지
                String value = CmmUtil.nvl((String) it.next());
                log.info("가져온 상품값 : " + value);
            }
        }

        log.info(this.getClass().getName() + ".getKeyword End!");
        return rSet;
    }

    // 최근 본 상품 삭제
    @Override
    public void rmKeyword(NoticeDTO pDTO) throws Exception {

        log.info(this.getClass().getName() + ".rmKeyword 시작!");

        String user_no = pDTO.getUser_no();
        String imgs = pDTO.getImgs();
        String goods_title = pDTO.getGoods_title();
        String goods_no = pDTO.getGoods_no();

        // json 형태의 String으로 redis에 저장(추후 불러올때, json.parse로 json 객체로 변환)
        String jsonGoods = "{\"" + "goods_no" + "\" : \"" + goods_no + "\", \""
                + "imgs" + "\" : \"" + imgs + "\", \"" + "goods_title" + "\" : \"" + goods_title + "\"}";


        String redisKey = "Goods_UserNo_" + user_no;
        log.info("키값 : " + redisKey);

        log.info("mapper에서 pDTO값 가져왔는지 ? : " + goods_no);

        // redis 저장 및 읽기에 대한 데이터 타입 지정(String 타입으로 지정)
        redisDB.setKeySerializer(new StringRedisSerializer());

        // DTO를 JSON구조로 변경
        redisDB.setValueSerializer(new StringRedisSerializer());

        log.info("json 형태 결과값 : " + jsonGoods);

        // 해당되는
        try {
                Set rSet = (Set) redisDB.opsForSet().members(redisKey);

                Iterator<String> it = rSet.iterator();

                while (it.hasNext()) {
                    String value = CmmUtil.nvl((String) it.next());

                    System.out.println("value : " + value);
                    /* 최근 본 상품에 들어가 있는 데이터일 것이기 때문에, 기존 데이터를 삭제한다.
                     */
                    if (value.equals(jsonGoods)) {
                        log.info("중복 값 있음. 삭제함");
                        redisDB.opsForZSet().remove(redisKey, jsonGoods);
                        log.info("삭제 완료");
                    }
                }

       } catch (Exception e) {

        }
        log.info("rmKeyword end!");
    }
}
