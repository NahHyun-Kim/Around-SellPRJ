package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import poly.dto.NoticeDTO;
import poly.service.INoticeService;
import poly.util.CmmUtil;
import poly.util.DateUtil;
import poly.util.FileUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/*
* Controller 선언해야만 Spring 프레임워크에서 Controller인지 인식 가능
* 자바 서블릿 역할 수행
* */
@Controller
public class NoticeController {

    private Logger log = Logger.getLogger(this.getClass());

    /*
    * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
    * NoticeService(INoticeService 사용)
    * */
    @Resource(name="NoticeService")
    private INoticeService noticeService;

    // 업로드되는 파일이 저장되는 기본 폴더 설정
    final private String FILE_UPLOAD_SAVE_PATH = "C:/PersonalProject/WebContent/resource//images";

    // 판매글 작성 페이지 이동
    @RequestMapping(value="/noticeForm", method = RequestMethod.GET)
    public String noticeForm(HttpServletRequest request, HttpServletResponse response,
                             ModelMap model) throws Exception {
        log.info(this.getClass().getName() + "noticeForm(판매글 작성 페이지) Start!");

        return "/notice/newPost";
    }

    /*
    * 판매글 리스트 보여주기(이미지 등록 완료, 페이징 구현중)
    * */
    @RequestMapping(value="/noticeList", method = RequestMethod.GET)
    public String noticeList(HttpServletRequest request, HttpServletResponse response,
                             ModelMap model) throws Exception {

        log.info(this.getClass().getName() + ".noticeList(판매글 리스트) Start!");

        // 판매글 리스트 가져오기
        // 판매글 정보는 여러개이므로, DTO를 List 형태에 담아 반환한다.
        List<NoticeDTO> rList = noticeService.getNoticeList();

        if (rList == null) {
            rList = new ArrayList<NoticeDTO>();

        }

        // 조회된 리스트 결과값을 model에 보냄
        model.addAttribute("rList", rList);

        // 메모리 효율화를 위한 변수 초기화
        rList = null;

        log.info(this.getClass().getName() + ".noticeList(판매글 리스트) End!");

        return "/notice/noticeList";
    }

    /*
    * 판매글 등록
    * */
    @RequestMapping(value="/noticeInsert", method=RequestMethod.POST)
    public String noticeInsert(HttpSession session, MultipartHttpServletRequest request,
                               HttpServletResponse response, ModelMap model, @RequestParam(value="fileUpload") MultipartFile mf) throws Exception {

        log.info(this.getClass().getName() + ".noticeInsert(게시글 등록 실행) Start!");



        String msg = "";
        // String url = "";

        try {

            // 업로드하는 실제 파일명
            String org_file_name = mf.getOriginalFilename();

            // 파일의 확장자를 가져와, 이미지 파일만 실행되도록 함
            String ext = org_file_name.substring(org_file_name.lastIndexOf(".") + 1, org_file_name.length()).toLowerCase();

            //form태그의 name 값을 받아옴(request.getParameter)
            String user_no = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO")); //세션으로부터 받아온 회원 번호
            String goods_title = CmmUtil.nvl(request.getParameter("goods_title")); //상품명
            String goods_detail = CmmUtil.nvl(request.getParameter("goods_detail")); //상품 설명
            String goods_price = CmmUtil.nvl(request.getParameter("goods_price")); //상품 가격
            String goods_addr = CmmUtil.nvl(request.getParameter("goods_addr")); //판매 장소(간략)
            String goods_addr2 = CmmUtil.nvl(request.getParameter("goods_addr2")); //판매 장소(상세주소)
            String category = CmmUtil.nvl(request.getParameter("category")); //카테고리
            String user_name = CmmUtil.nvl((String) session.getAttribute("SS_USER_NAME")); //세션으로부터 받은 회원 이름

            // 판매 상세 주소지 입력에서, 지역구를 가져오기 위해 split 함수 사용
            String[] addrsplit = CmmUtil.nvl(request.getParameter("goods_addr2")).split(" ", 3);
            String addr2 = addrsplit[1].trim();

            // 제대로 값이 들어왔는지 로그를 찍어 확인
            log.info("user_no : " + user_no);
            log.info("goods_title : " + goods_title);
            log.info("goods_detail : " + goods_detail);
            log.info("goods_price : " + goods_price);
            log.info("goods_addr(간략 주소) : " + goods_addr);
            log.info("goods_addr2(상세 주소) : " + goods_addr2);
            log.info("addr2(지역구) : " + addr2);
            log.info("category : " + category);
            log.info("user_name : " + user_name);

            // insert를 위해 전달할 pDTO에 값을 세팅
            NoticeDTO pDTO = new NoticeDTO();

            if (ext.equals("jpeg") || ext.equals("jpg") || ext.equals("gif") || ext.equals("png")) {


                String save_file_name = DateUtil.getDateTime("24hhmmss") + "." + ext;

                // 웹서버에 업로드한 파일 저장하는 물리적 경로
                String save_file_path = FileUtil.mkdirForDate(FILE_UPLOAD_SAVE_PATH);
                // 이미지가 저장되는 폴더 경로
                //이미지가 저장되는 폴더경로
                String save_folder_name = save_file_path.substring(save_file_path.length()-10);

                log.info("폴더경로 제대로 되었는지 확인 : " + save_folder_name);

                String full_img = save_folder_name + "/" + save_file_name;
                log.info("이미지 풀 경로 : " + full_img);

                // 업로드되는 파일을 서버에 저장(전체경로+파일명.확장자 형태로 저장)
                mf.transferTo(new File(save_file_path + "/" + save_file_name));

                pDTO.setImgs(full_img);
                log.info("img(폴더 경로) : " + pDTO.getImgs());
            }
            pDTO.setUser_no(user_no);
            pDTO.setGoods_title(goods_title);
            pDTO.setGoods_detail(goods_detail);
            pDTO.setGoods_price(goods_price);
            pDTO.setGoods_addr(goods_addr);
            pDTO.setGoods_addr2(goods_addr2);
            pDTO.setAddr2(addr2);
            pDTO.setCategory(category);
            pDTO.setReg_id(user_name);

            // pDTO에 담은 값을 게시글로 등록하는 함수 호출
            noticeService.InsertNoticeInfo(pDTO);

            // 저장이 완료되었다면, 등록이 완료되었음을 보여줌
            msg = "등록이 완료되었습니다.";

        } catch(Exception e){
            
            //등록이 실패되면 오류 메세지를 보여줌
            msg = "게시글 등록에 실패하였습니다. 다시 시도해 주세요. : " + e.toString();
            log.info(e.toString());
            e.printStackTrace();
        } finally {
            log.info(this.getClass().getName() + ".noticeInsert(게시글 등록 실행) End!");

            // 결과 메세지를 model로 전달
            model.addAttribute("msg", msg);
            //아직 리스트 보기가 구현되지 않아, 임시로 url을 index.do로 보냄
            // model.addAttribute("url", "/index.do");
        }

        return "/notice/MsgToList";
    }

    // 게시글 상세보기
    @RequestMapping(value="/noticeInfo", method=RequestMethod.GET)
    public String noticeInfo(HttpServletRequest request, HttpServletResponse response,
                             ModelMap model) throws Exception {

        log.info(this.getClass().getName() + ".noticeInfo(게시판 상세보기) Start!");

        // form 객체의 판매글 번호(pk)를 받아옴
        String goods_no = CmmUtil.nvl(request.getParameter("nSeq"));

        log.info("form으로부터 받아온 goods_no : " + goods_no);

        // 값 전달은 DTO 객체를 이용하여 처리. pDTO를 통해 전달한다(특정 게시글 조회)
        NoticeDTO pDTO = new NoticeDTO();

        pDTO.setGoods_no(goods_no);

        // 게시글을 조회했기 때문에, 조회수를 증가하는 로직 작성
        // 판매글 번호에 해당하는 값을 pDTO에 담아 전달하여, 해당 판매글의 조회수가 증가
        noticeService.updateNoticeHit(pDTO);

        log.info("Hit(조회수) update Success!");

        // 판매글 상세정보 가져오기
        NoticeDTO rDTO = noticeService.getNoticeInfo(pDTO);

        if (rDTO == null)
        {
            rDTO = new NoticeDTO();
            log.info("is null");
        }



        log.info("getNoticeInfo Success!");

        // 조회된 리스트를 model에 결과값 넣어줌
        model.addAttribute("rDTO", rDTO);

        // 메모리의 효율화를 위해 사용한 변수를 초기화
        rDTO = null;
        pDTO = null;

        log.info(this.getClass().getName() + ".noticeInfo(게시글 상세 조회 + 조회수 업데이트) End!");

        return "/notice/noticeInfo";
    }

    //판매글 수정 화면 표시
    @RequestMapping(value="noticeEditInfo", method = RequestMethod.GET)
    public String noticeEditInfo(HttpServletRequest request, HttpServletResponse response,
                                 ModelMap model) throws Exception {

        log.info(this.getClass().getName() + ".noticeEditInfo(게시글 수정 페이지) Start!");

        String goods_no = CmmUtil.nvl(request.getParameter("nSeq")); //게시글 번호 받아오기
        
        log.info("goods_no(받아온 게시글 번호) : " + goods_no);
        
        // pDTO로 update쿼리를 전달할 DTO 생성
        NoticeDTO pDTO = new NoticeDTO();
        pDTO.setGoods_no(goods_no);
        
        // 수정할 정보 가져오기(상세보기 쿼리를 통해 가져와서 수정 --> 이미 등록된 내용을 가져옴)
        NoticeDTO rDTO = noticeService.getNoticeInfo(pDTO);
        
        if (rDTO == null) {
            rDTO = new NoticeDTO();
        }
        
        // 조회한 리스트 결과값 넣어주기
        model.addAttribute("rDTO", rDTO);
        
        // 메모리 효율화를 위해 변수를 초기화
        rDTO = null;
        pDTO = null;
        
        log.info(this.getClass().getName() + ".noticeEditInfo(게시글 수정 페이지) End!");
        
        return "/notice/editPost";
}

    /*
    * 판매글 수정 등록(update 쿼리 날리기)
    * */
    @RequestMapping(value="/noticeUpdate", method=RequestMethod.POST)
    public String noticeUpdate(HttpSession session, HttpServletRequest request, 
                               HttpServletResponse response, ModelMap model, @RequestParam(value="fileUpload") MultipartFile mf)
            throws Exception {
        log.info(this.getClass().getName() + ".noticeUpdate(게시판 수정 등록) Start!");

        String msg = "";
        String url = "";

        // update할 값을 pDTO에 담기 위해 NoticeDTO 객체 생성
        NoticeDTO pDTO = new NoticeDTO();

        try {
            // 업로드하는 실제 파일명
            String org_file_name = mf.getOriginalFilename();

            // 파일의 확장자를 가져와, 이미지 파일만 실행되도록 함
            String ext = org_file_name.substring(org_file_name.lastIndexOf(".") + 1, org_file_name.length()).toLowerCase();

            String user_no = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO")); //회원 번호
            String goods_no = CmmUtil.nvl(request.getParameter("nSeq")); //글번호
            String goods_title = CmmUtil.nvl(request.getParameter("goods_title")); // 상품명(제목)
            String goods_detail = CmmUtil.nvl(request.getParameter("goods_detail")); // 상품 설명(게시글 내용)
            String goods_price = CmmUtil.nvl(request.getParameter("goods_price")); // 상품 가격
            String goods_addr = CmmUtil.nvl(request.getParameter("goods_addr")); // 판매 간략한 주소(상호명)
            String goods_addr2 = CmmUtil.nvl(request.getParameter("goods_addr2")); // 판매 상세주소
            String category = CmmUtil.nvl(request.getParameter("category")); //카테고리

            // 판매 상세 주소지 입력에서, 지역구를 가져오기 위해 split 함수 사용
            String[] addrsplit = CmmUtil.nvl(request.getParameter("goods_addr2")).split(" ", 3);
            String addr2 = addrsplit[1].trim();

            log.info("update할 user_no : " + user_no);
            log.info("update할 글번호 : " + goods_no);
            log.info("update할 상품명 : " + goods_title);
            log.info("update할 상품설명 : " + goods_detail);
            log.info("update할 상품 가격 : " + goods_price);
            log.info("update할 상호명 : " + goods_addr);
            log.info("update할 상세 주소 : " + goods_addr2);
            log.info("update할 지역구 : " + addr2);
            log.info("update할 카테고리 : " + category);

            if (ext.equals("jpeg") || ext.equals("jpg") || ext.equals("gif") || ext.equals("png")) {


                String save_file_name = DateUtil.getDateTime("24hhmmss") + "." + ext;

                // 웹서버에 업로드한 파일 저장하는 물리적 경로
                String save_file_path = FileUtil.mkdirForDate(FILE_UPLOAD_SAVE_PATH);
                // 이미지가 저장되는 폴더 경로
                //이미지가 저장되는 폴더경로
                String save_folder_name = save_file_path.substring(save_file_path.length()-10);

                log.info("폴더경로 제대로 되었는지 확인 : " + save_folder_name);

                String full_img = save_folder_name + "/" + save_file_name;
                log.info("이미지 풀 경로 : " + full_img);

                // 업로드되는 파일을 서버에 저장(전체경로+파일명.확장자 형태로 저장)
                mf.transferTo(new File(save_file_path + "/" + save_file_name));

                pDTO.setImgs(full_img);
                log.info("img(폴더 경로) : " + pDTO.getImgs());
            } else { // 기존 파일이 그대로인 경우(새로운 파일업로드로부터 이미지를 받아오지 못함)
                log.info("새로운 이미지 파일 들어오지 않음(기존 이미지 사용)");
                NoticeDTO nDTO = new NoticeDTO();
                nDTO.setGoods_no(goods_no);
                log.info("goods_no : " + goods_no);
                NoticeDTO rDTO = noticeService.getNoticeInfo(nDTO);

                nDTO = null;
                log.info("rDTO에서 가져온 이미지 주소값 : " + rDTO.getImgs());

                String def_img = CmmUtil.nvl(rDTO.getImgs());
                log.info("실패한 경우 받아온 이미지 경로(nvl) : " + def_img);
                pDTO.setImgs(def_img);
                log.info("setting 되었는지?" + pDTO.getImgs());
            }

            pDTO.setUser_no(user_no);
            pDTO.setGoods_no(goods_no);
            pDTO.setGoods_title(goods_title);
            pDTO.setGoods_detail(goods_detail);
            pDTO.setGoods_price(goods_price);
            pDTO.setGoods_addr(goods_addr);
            pDTO.setGoods_addr2(goods_addr2); //상세 주소
            pDTO.setAddr2(addr2); //지역구
            pDTO.setCategory(category);

            log.info("pDTO 세팅 여부 : " + pDTO.getAddr2());

            noticeService.updateNoticeInfo(pDTO);
            log.info("update 완료!");

            msg = "수정되었습니다.";
            url = "/noticeInfo.do?nSeq=" + goods_no;

            // 메모리 효율화를 위해 변수 초기화
            pDTO = null;

        } catch(Exception e) {
            msg = "실패하였습니다." + e.toString();
            url = "/noticeList.do";
            // url = "/noticeList.do";
            log.info(e.toString());
            e.printStackTrace();
            return "/redirect";
        } finally {
            log.info(this.getClass().getName() + ".noticeUpdate(게시판 수정 등록) End!");

            // redirect로 결과 메시지 전달
            model.addAttribute("msg", msg);
            model.addAttribute("url", url);
        }
        return "/redirect";
    }

    /*
    * 판매글 삭제
    * */
    @RequestMapping(value="/noticeDelete", method = RequestMethod.GET)
    public String noticeDelet(HttpSession session, HttpServletRequest request, HttpServletResponse response,
                              ModelMap model) throws Exception {

        log.info(this.getClass().getName() + ".noticeDelete(판매글 삭제) Start!");

        String msg = "";

        try {
            String goods_no = CmmUtil.nvl(request.getParameter("nSeq")); //글번호

            log.info("받아온 글 번호 : " + goods_no);

            // 판매글 번호를 DTO에 담기 위해 pDTO 객체 생성
            NoticeDTO pDTO = new NoticeDTO();
            pDTO.setGoods_no(goods_no);

            // 게시글 삭제하기 DB 쿼리 보내기
            noticeService.deleteNoticeInfo(pDTO);

            msg = "삭제가 완료되었습니다.";

            // 메모리 효율화를 위한 변수 초기화
            pDTO = null;
        } catch (Exception e) {
            msg = "실패하였습니다." + e.toString();
            log.info("삭제 실패! : " + e.toString());
            e.printStackTrace();

        } finally {
            log.info(this.getClass().getName() + ".noticeDelete End!");

            // 결과 메시지 model에 전달
            model.addAttribute("msg", msg);
        }

        return "/notice/MsgToList";

    }
}