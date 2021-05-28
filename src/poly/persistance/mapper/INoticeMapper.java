package poly.persistance.mapper;

import config.Mapper;
import poly.dto.NoticeDTO;

import java.util.List;

@Mapper("NoticeMapper")
public interface INoticeMapper {

    // 게시판 리스트 불러오기(일반)
    List<NoticeDTO> getNoticeList(NoticeDTO pDTO) throws Exception;

    // 판매글 상위 5개 게시글 불러오기(일반)
    List<NoticeDTO> maxCount(NoticeDTO pDTO) throws Exception;

    // 판매글 카테고리별 게시물 수 불러오기
    List<NoticeDTO> cateCount(NoticeDTO pDTO) throws Exception;

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

    // 특정 회원의 모든 게시글 삭제
    int deleteNoticeAll(NoticeDTO pDTO) throws Exception;

    // 나의 게시판 리스트
    List<NoticeDTO> getMyList(NoticeDTO pDTO) throws Exception;

    // 나의 게시물 삭제
    int delMySell(NoticeDTO pDTO) throws Exception;

}
