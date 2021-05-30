package poly.service.impl;

import org.springframework.stereotype.Service;
import poly.dto.CommentDTO;
import poly.persistance.mapper.ICommentMapper;
import poly.service.ICommentService;

import javax.annotation.Resource;
import java.util.List;

@Service("CommentService")
public class CommentService implements ICommentService {

    @Resource(name="CommentMapper")
    private ICommentMapper commentMapper;

    // 댓글 등록하기(ajax)
    @Override
    public void insertComment(CommentDTO pDTO) throws Exception {
        commentMapper.insertComment(pDTO);
    }

    // 댓글 목록 가져오기(ajax)
    @Override
    public List<CommentDTO> getComment(CommentDTO pDTO) throws Exception {
        return commentMapper.getComment(pDTO);
    }

    // 댓글 삭제하기(ajax)
    @Override
    public void delComment(CommentDTO pDTO) throws Exception {
        commentMapper.delComment(pDTO);
    }

    // 댓글을 수정 시, 내용 표시를 위해 기존 댓글정보를 가져옴(댓글번호)
    @Override
    public CommentDTO getCommentDetail(CommentDTO pDTO) throws Exception {
        return commentMapper.getCommentDetail(pDTO);
    }

    // 댓글 수정하기(ajax)
    @Override
    public void editComment(CommentDTO pDTO) throws Exception {
        commentMapper.editComment(pDTO);
    }
}
