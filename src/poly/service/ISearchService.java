package poly.service;

import poly.dto.NoticeDTO;

import java.util.Set;

public interface ISearchService {

    // 최근 검색어 저장
    public void insertKeyword(NoticeDTO pDTO) throws Exception;

    // 최근 검색어 불러오기
    public Set getKeyword(NoticeDTO pDTO) throws Exception;

    // 최근 본 상품 저장하기
    public void insertGoods(NoticeDTO pDTO) throws Exception;

    // 최근 본 상품 불러오기
    public Set getGoods(NoticeDTO pDTO) throws Exception;
}
