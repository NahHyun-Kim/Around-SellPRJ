package poly.service;

import poly.dto.CommentDTO;

import java.util.List;

public interface ICommentService {

    // 댓글 등록하기(ajax)
    void insertComment(CommentDTO pDTO) throws Exception;

    // 댓글 목록 가져오기(ajax)
    List<CommentDTO> getComment(CommentDTO pDTO) throws Exception;
}
