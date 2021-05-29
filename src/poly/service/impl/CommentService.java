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
}
