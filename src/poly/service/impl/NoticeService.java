package poly.service.impl;

import org.springframework.stereotype.Service;
import poly.dto.NoticeDTO;
import poly.persistance.mapper.INoticeMapper;
import poly.service.INoticeService;

import javax.annotation.Resource;
import java.util.List;

@Service("NoticeService")
public class NoticeService implements INoticeService {
    
    @Resource(name="NoticeMapper")
    private INoticeMapper noticeMapper;

    //  판매글 상세보기(List)
    @Override
    public List<NoticeDTO> getNoticeList() throws Exception {
        return noticeMapper.getNoticeList();
    }

    // 판매글 등록하기
    @Override
    public void InsertNoticeInfo(NoticeDTO pDTO) throws Exception {
        noticeMapper.InsertNoticeInfo(pDTO);
    }

    // 판매글 조회하기(상세정보)
    @Override
    public NoticeDTO getNoticeInfo(NoticeDTO pDTO) throws Exception {
        return noticeMapper.getNoticeInfo(pDTO);
    }

    // 판매글 조회 시, 조회수 업데이트
    @Override
    public void updateNoticeHit(NoticeDTO pDTO) throws Exception {
        noticeMapper.updateNoticeHit(pDTO);
    }

    // 판매글 수정하기
    @Override
    public void updateNoticeInfo(NoticeDTO pDTO) throws Exception {
        noticeMapper.updateNoticeInfo(pDTO);
    }

    // 판매글 삭제하기
    @Override
    public void deleteNoticeInfo(NoticeDTO pDTO) throws Exception {
        noticeMapper.deleteNoticeInfo(pDTO);
    }
}
