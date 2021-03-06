package poly.persistance.redis;

import poly.dto.NoticeDTO;

import java.util.Set;

public interface ISearchMapper {

    // 최근 검색어 저장하기
    public void insertKeyword(NoticeDTO pDTO) throws Exception;

    // 최근 검색어 불러오기
    public Set getKeyword(NoticeDTO pDTO) throws Exception;

    // 최근 본 상품 저장하기
    public void insertGoods(NoticeDTO pDTO) throws Exception;

    // 최근 본 상품 불러오기
    public Set getGoods(NoticeDTO pDTO) throws Exception;

    // 최근 본 상품 삭제하기
    public void rmKeyword(NoticeDTO pDTO) throws Exception;
}