package poly.service;

import poly.dto.NoticeDTO;

import java.util.List;

public interface INoticeService {

    // 게시판 리스트
    List<NoticeDTO> getNoticeList() throws Exception;

    // 게시판 등록하기
    void InsertNoticeInfo(NoticeDTO pDTO) throws Exception;

    // 게시판 상세보기
    NoticeDTO getNoticeInfo(NoticeDTO pDTO) throws Exception;

    // 게시판 조회수 업데이트
    void updateNoticeHit(NoticeDTO pDTO) throws Exception;

    // 게시판 글 수정
    void updateNoticeInfo(NoticeDTO pDTO) throws Exception;

    // 게시판 글 삭제
    void deleteNoticeInfo(NoticeDTO pDTO) throws Exception;

}
