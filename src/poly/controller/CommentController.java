package poly.controller;

import org.apache.hadoop.mapreduce.v2.app.commit.CommitterEventType;
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
    // 댓글 등록 성공시, 게시글 상세보기 로딩 시 실행되도록 ajax를 함수에 담아 구현
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

        pDTO = null;
        return rList;
    }

    // 댓글 삭제하기(ajax)
    @ResponseBody
    @RequestMapping(value="/delComment")
    public int delComment(HttpServletRequest request, HttpServletResponse response, HttpSession session,
                          @RequestParam(value="comment_no") String comment_no) throws Exception {

        log.info(this.getClass().getName() + ".delComment(댓글 삭제 ajax) 시작!");
        log.info("받아온 댓글 번호(comment_no, pk) : " + comment_no);

        int res = 0;

        try {

            CommentDTO pDTO = new CommentDTO();
            pDTO.setComment_no(comment_no);

            // 댓글 삭제 요청
            commentService.delComment(pDTO);
            res = 1;

            pDTO = null;

        } catch (Exception e) {
            log.info("삭제 실패! : " + e.toString());
            e.printStackTrace();

        }


        log.info(this.getClass().getName() + ".delComment(댓글 삭제 ajax) 끝!" + res);

        return res;
    }

    // 댓글 수정 시, 기존 댓글 내용을 가져오기
    @ResponseBody
    @RequestMapping(value="/getCommentDetail")
    public CommentDTO getCommentDetail(HttpServletRequest request, HttpServletResponse response,
                                       @RequestParam(value="comment_no") String comment_no)
        throws Exception {

        log.info(this.getClass().getName() + ".getCommentDetail(댓글 내용 가져오기) Start!");
        log.info("가져온 댓글 번호(for 수정) : " + comment_no);

        CommentDTO pDTO = new CommentDTO();
        pDTO.setComment_no(comment_no);

        CommentDTO rDTO = commentService.getCommentDetail(pDTO);
        log.info("rDTO 값(수정을 위한 기존 댓글 정보 받아오기) null? null이면 True : " + (rDTO == null));

        pDTO = null;
        log.info(this.getClass().getName() + ".getCommentDetail(댓글 내용 가져오기) End!");

        return rDTO;
    }

    // 댓글 수정 로직 ajax
    @ResponseBody
    @RequestMapping(value="editComment")
    public int editComment(HttpServletRequest request, HttpServletResponse response,
                           @RequestParam(value="comment_no") String comment_no,
                           @RequestParam(value="user_name") String user_name,
                           @RequestParam(value="content") String content) throws Exception {

        log.info(this.getClass().getName() + ".editComment(ajax 댓글 수정 로직 진행) Start!");

        log.info("받아온 수정할 댓글 번호, 회원 이름, 내용 : " + comment_no + " " + user_name + " " + content);

        int res = 0;

        try {
            // 수정할 댓글 정보를 pDTO에 세팅
            // pk인 댓글 번호에 해당하는 정보를 수정한다.
            CommentDTO pDTO = new CommentDTO();
            pDTO.setContent(content);
            pDTO.setUser_name(user_name);
            pDTO.setComment_no(comment_no);

            commentService.editComment(pDTO);
            log.info("수정 성공! (editCommet 함수 실행!)");

            // 수정에 성공했다면 ,res = 1 반환
            res = 1;
        }
        catch(Exception e) {
            log.info("수정 에러 발생! : " + e.toString());
            e.printStackTrace();
        }

        log.info(this.getClass().getName() + ".editComment(ajax 댓글 수정 로직 진행) 끝!" + res);

        return res;
    }
}
