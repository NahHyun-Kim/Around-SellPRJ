package poly.service.impl;

import org.springframework.stereotype.Service;
import poly.dto.Criteria;
import poly.dto.NoticeDTO;
import poly.persistance.mapper.INoticeMapper;
import poly.persistance.mapper.IPageMapper;
import poly.service.IPageService;

import javax.annotation.Resource;
import java.util.List;

@Service("PageService")
public class PageService implements IPageService {

    // NoticeMapper를 메모리에 올림
    @Resource(name="NoticeMapper")
    private INoticeMapper noticeMapper;

    // PageMapper를 메모리에 올림
    @Resource(name="PageMapper")
    private IPageMapper pageMapper;


    // 페이징 처리한 게시판 리스트 불러오기
    @Override
    public List<NoticeDTO> selectPaging(Criteria pDTO) throws Exception {
        return pageMapper.selectPaging(pDTO);
    }

    // 페이징을 위한 게시글 수 카운팅
    @Override
    public int cntNotice() throws Exception {
        return pageMapper.cntNotice();
    }

}
