package poly.persistance.mapper;

import config.Mapper;
import poly.dto.CommentDTO;

import java.util.List;

@Mapper("CommentMapper")
public interface ICommentMapper {

    // 댓글 등록하기(ajax)
    void insertComment(CommentDTO pDTO) throws Exception;

    // 댓글 목록 가져오기(ajax)
    List<CommentDTO> getComment(CommentDTO pDTO) throws Exception;

    // 댓글 삭제하기(ajax)
    void delComment(CommentDTO pDTO) throws Exception;

    // 댓글을 수정 시, 내용 표시를 위해 기존 댓글정보를 가져옴(댓글번호)
    CommentDTO getCommentDetail(CommentDTO pDTO) throws Exception;

    // 댓글 수정하기(ajax)
    void editComment(CommentDTO pDTO) throws Exception;

    // 댓글 수 체크
    int commentCnt(CommentDTO pDTO) throws Exception;
}
