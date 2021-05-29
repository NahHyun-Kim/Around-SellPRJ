package poly.service.impl;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import poly.dto.NoticeDTO;
import poly.persistance.redis.ISearchMapper;
import poly.service.ISearchService;

import javax.annotation.Resource;
import java.util.Set;

@Service("SearchService")
public class SearchService implements ISearchService {

    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name="SearchMapper")
    private ISearchMapper searchMapper;

    // 최근 검색어 저장
    @Override
    public void insertKeyword(NoticeDTO pDTO) throws Exception {
        searchMapper.insertKeyword(pDTO);
    }

    // 최근 검색어 불러오기
    @Override
    public Set getKeyword(NoticeDTO pDTO) throws Exception {
        return searchMapper.getKeyword(pDTO);
    }

    // 최근 본 상품 저장하기
    @Override
    public void insertGoods(NoticeDTO pDTO) throws Exception {
        searchMapper.insertGoods(pDTO);
    }

    // 최근 본 상품 불러오기
    @Override
    public Set getGoods(NoticeDTO pDTO) throws Exception {
        return searchMapper.getGoods(pDTO);
    }

    // 최근 본 상품 삭제하기(판매글 수정 또는 삭제시)
    @Override
    public void rmKeyword(NoticeDTO pDTO) throws Exception {
        searchMapper.rmKeyword(pDTO);
    }
}
