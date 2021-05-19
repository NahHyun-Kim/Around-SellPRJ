package poly.service.impl;

import org.springframework.stereotype.Service;
import poly.dto.Criteria;
import poly.dto.NoticeDTO;
import poly.dto.SearchCriteria;
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

    // 로그인 되었을때 해당 지역구에 해당하는 게시물 수에 맞는 페이징을 위한 게시글 수 카운팅
    @Override
    public int cntAddrNotice(NoticeDTO nDTO) throws Exception {
        return pageMapper.cntAddrNotice(nDTO);
    }

    // 검색한 결과에 해당하는 건수 가져오기
    @Override
    public int cntSearchType(NoticeDTO nDTO) throws Exception {
        return pageMapper.cntSearchType(nDTO);
    }

    // 페이징 처리 + 검색 결과 리스트로 가져오기
    @Override
    public List<NoticeDTO> searchList(SearchCriteria pDTO) throws Exception {
        return pageMapper.searchList(pDTO);
    }

}
