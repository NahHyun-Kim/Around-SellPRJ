package poly.service;

import poly.dto.Criteria;
import poly.dto.NoticeDTO;

import java.util.List;

public interface IPageService {

    // 페이징 처리한 게시판 리스트 불러오기
    List<NoticeDTO> selectPaging(Criteria pDTO) throws Exception;

    // 페이징을 위한 게시글 수 카운팅
    int cntNotice() throws Exception;

}
