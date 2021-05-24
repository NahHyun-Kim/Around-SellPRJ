package poly.service;

import poly.dto.NoticeDTO;

import java.util.Set;

public interface ISearchService {

    // 최근 검색어 저장
    public void insertKeyword(NoticeDTO pDTO) throws Exception;

    // 최근 검색어 불러오기
    public Set getKeyword(NoticeDTO pDTO) throws Exception;
    
}
