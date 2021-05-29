package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.CommentDTO;
import poly.service.*;
import poly.util.CmmUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
public class CommentController {

    // 댓글 컨트롤러
    private Logger log = Logger.getLogger(this.getClass());

    @Resource(name = "UserService")
    private IUserService userService;

    @Resource(name = "NoticeService")
    private INoticeService noticeService;

    @Resource(name = "CommentService")
    private ICommentService commentService;

    // 댓글 등록하기(getNoticeInfo 화면에서, 댓글 등록 시 ajax로 진행된다.)
    @ResponseBody
    @RequestMapping(value="/insertComment.do")
    public int insertComment(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                             @RequestParam(value="content") String content,
                             @RequestParam(value="goods_no") String goods_no,
                             @RequestParam(value="user_no") String user_no,
                             @RequestParam(value="user_name") String user_name)
        throws Exception {

        // RequestParam으로 ajax에서 댓글 내용을 받아온다.
        // user_no, user_name은 세션에서 받아올 수 있다.
        log.info(this.getClass().getName() + ".insertComment(댓글 등록 ajax) 시작!");

        log.info("값 잘 받아왔는지(@RequestParam값) : "  + content + goods_no + user_name + user_no);

        int res = 0;


        try {

            // 댓글 DTO 생성 + insert 할 값을 pDTO에 세팅
            CommentDTO pDTO = new CommentDTO();

            pDTO.setGoods_no(goods_no);
            pDTO.setUser_no(user_no);
            pDTO.setContent(content);
            pDTO.setUser_name(user_name);

            // 댓글 insert
            commentService.insertComment(pDTO);
            log.info("댓글 insert 성공!");

            res = 1;
            pDTO = null;
        }
        catch (Exception e) {

            log.info("insert 실패! : " + e.toString());
            e.printStackTrace();
        }

        log.info("최종 insert 여부(0이면 실패, 1이면 성공) : " + res);
        log.info(this.getClass().getName() + ".insertComment(댓글 등록 ajax) 완료!");

        return res;
    }

    // 댓글 리스트 가져오기(ajax)
    // 댓글 등록 성공시, 게시글 상세보기 로딩 시 실행되도록 ajax를 함수에 담아 구현(예정)
    @ResponseBody
    @RequestMapping(value="/getComment")
    public List<CommentDTO> getComment(HttpServletRequest request, HttpSession session,
                                       @RequestParam(value="goods_no") String goods_no)
        throws Exception {

        log.info(this.getClass().getName() + ".getComment(댓글 목록 가져오기) Start!");
        log.info("가져온 상품 번호 : " + goods_no);

        CommentDTO pDTO = new CommentDTO();
        pDTO.setGoods_no(goods_no);

        // 글번호에 해당하는 댓글 목록 가져오기(1개 이상의 데이터는 List 형태로 받음)
        List<CommentDTO> rList = commentService.getComment(pDTO);
        log.info("rList null? (댓글 목록 없으면 true) : " + (rList == null));

        if (rList == null) {
            rList = new ArrayList<>();
        }

        log.info(this.getClass().getName() + ".getComment(댓글 목록 가져오기) End!");

        return rList;
    }
}
