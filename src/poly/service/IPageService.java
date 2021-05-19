package poly.service;

import poly.dto.Criteria;
import poly.dto.NoticeDTO;
import poly.dto.SearchCriteria;

import java.util.List;

public interface IPageService {

    // 페이징 처리한 게시판 리스트 불러오기
    List<NoticeDTO> selectPaging(Criteria pDTO) throws Exception;

    // 페이징을 위한 게시글 수 카운팅
    int cntNotice() throws Exception;

    // 로그인 되었을때 해당 지역구에 해당하는 게시물 수에 맞는 페이징을 위한 게시글 수 카운팅
    int cntAddrNotice(NoticeDTO nDTO) throws Exception;

    // 검색한 결과에 해당하는 건수 가져오기
    int cntSearchType(NoticeDTO nDTO) throws Exception;

    // 페이징 처리 + 검색 결과 리스트로 가져오기
    List<NoticeDTO> searchList(SearchCriteria pDTO) throws Exception;
}
