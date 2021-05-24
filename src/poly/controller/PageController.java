package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.Criteria;
import poly.dto.NoticeDTO;
import poly.dto.SearchCriteria;
import poly.service.INoticeService;
import poly.service.IPageService;
import poly.service.ISearchService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Controller
public class PageController {

    private Logger log = Logger.getLogger(this.getClass());

    /*
     * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
     * NoticeService(INoticeService 사용)
     * */
    @Resource(name="NoticeService")
    private INoticeService noticeService;

    @Resource(name="PageService")
    private IPageService pageService;

    @Resource(name="SearchService")
    private ISearchService searchService;

    // 판매글 리스트를 페이징 처리하여 불러오기
    @RequestMapping(value="/pagingList")
    public String pagingList(Criteria pDTO, ModelMap model, HttpSession session,
                             @RequestParam(value="nowPage", required = false) String nowPage,
                             @RequestParam(value="cntPerPage", required = false) String cntPerPage)
        throws Exception {

        log.info(this.getClass().getName() + ".pagingList(페이징 판매글 리스트) Start!");

        // 가입 주소를 기반으로 검색해야 하기 때문에, 주소값을 받아와 dto에 저장
        String addr2 = (String) session.getAttribute("SS_USER_ADDR2");
        log.info("addr null? : " + (addr2==null));

        log.info("가져온 주소(addr2) : " + addr2);


        // 페이지 정보를 받아오지 못할 경우, 기본값을 지정
        if (nowPage == null & cntPerPage == null) {
            nowPage = "1";
            cntPerPage = "9";

        } else if (nowPage == null) {
            nowPage = "1";

        } else if (cntPerPage == null) {
            cntPerPage = "9";

        }

        int total = 0;

       if (addr2 == null) {
            // 총 게시물 수를 가져옴(count *)
            total = pageService.cntNotice();
            log.info("가져온 전체 게시물 수(int total) : " + total);

           // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
           pDTO = new Criteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

       } else if (addr2 != null) {
            NoticeDTO nDTO = new NoticeDTO();
            nDTO.setAddr2(addr2);

           // 지역구에 해당하는 게시물 수를 가져옴(total count가 달라짐 -> 이에 따른 페이징 필요)
            total = pageService.cntAddrNotice(nDTO);
            log.info("가져온 지역구에 해당하는 게시물 수 : " + total);

            nDTO = null;
           pDTO = new Criteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), addr2);
        }

        model.addAttribute("paging",pDTO);
        model.addAttribute("sellList", pageService.selectPaging(pDTO));

        log.info("addr2값 세팅 되었는지 : " + pDTO.getAddr2());

        pDTO = null;
        log.info(this.getClass().getName() + ".pagingList(판매글 리스트 페이징) End!");

        return "/notice/pagingList";
    }

    // 판매글 리스트를 페이징 처리하여 불러오기(전체 + 검색 + 정렬)
    @RequestMapping(value="/searchList")
    public String searchList(SearchCriteria pDTO, HttpServletRequest request, ModelMap model, HttpSession session,
                             @RequestParam(value="nowPage", required = false) String nowPage,
                             @RequestParam(value="cntPerPage", required = false) String cntPerPage,
                             @RequestParam(value="searchType", required = false) String searchType,
                             @RequestParam(value="keyword", required = false) String keyword,
                             @RequestParam(value="odType", required = false) String odType)
            throws Exception {

        log.info(this.getClass().getName() + ".pagingList(페이징 판매글 리스트) Start!");

        // 가입 주소를 기반으로 검색해야 하기 때문에, 주소값을 받아와 dto에 저장
        String addr2 = (String) session.getAttribute("SS_USER_ADDR2");
        String user_no = (String) session.getAttribute("SS_USER_NO");

        log.info("addr null? : " + (addr2==null));

        log.info("가져온 주소(addr2) : " + addr2);


        // 페이지 정보를 받아오지 못할 경우, 기본값을 지정
        if (nowPage == null & cntPerPage == null) {
            nowPage = "1";
            cntPerPage = "9";

        } else if (nowPage == null) {
            nowPage = "1";

        } else if (cntPerPage == null) {
            cntPerPage = "9";

        }

        int total = 0;

        log.info("가져온 검색 타입 : " + searchType);
        log.info("가져온 검색어 : " + keyword);
        log.info("가져온 정렬 : " + odType);

        // 제대로 받아왔는지 확인
        log.info("searchType 받아옴(isNull이면 true) ? : " + (searchType==null));
        log.info("keyword 받아옴(isNull이면 true) ? : " + (keyword == null));
        log.info("odType 받아옴(정렬 없으면 true, 정렬 있으면 false)" + (odType == null));

        // 비 로그인 상태로 페이지 로딩 또는 검색을 진행한다면
        if (addr2 == null) {
            if (searchType == null && keyword == null) {
                log.info("비 로그인 + 기본 페이지 로딩(검색어 없음)");
                // 총 게시물 수를 가져옴(count *)
                total = pageService.cntNotice();
                log.info("가져온 전체 게시물 수(int total) : " + total);

                // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
                pDTO = new SearchCriteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

                log.info("비 로그인 + 기본 페이지 로딩(검색어 없음) pDTO 세팅 끝!");

            } else { // 비 로그인 상태로, 검색했다면
                // 1. 비 로그인 + 검색 + 정렬 안함
                if (odType == null) {
                    log.info("비 로그인 + 검색 진행 + 정렬X");

                NoticeDTO nDTO = new NoticeDTO();
                nDTO.setCategory(searchType); // 임시로 searchType 사용
                nDTO.setGoods_title(keyword); // 임시로 keyword 사용(count를 위함)

                // 로그인 안한 상태의 검색어에 해당하는 게시물 수를 가져옴
                // addr2에 세팅된 값이 없기 때문에, null 값 전달(아마도! 추후 검사 예정)
                total = pageService.cntSearchType(nDTO);
                log.info("가져온 (비로그인, 전체 범위) 검색 결과 게시물 수 : " + total);

                nDTO = null;
                // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
                pDTO = new SearchCriteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), searchType, keyword);

                log.info("비 로그인 + 검색 진행 + 정렬X pDTO 세팅 끝!");

                // 2. 비 로그인 + 검색 + 정렬 진행
                } else {
                    log.info("비 로그인 + 검색 진행 + 정렬 진행");
                    NoticeDTO nDTO = new NoticeDTO();
                    nDTO.setCategory(searchType); // 임시로 searchType 사용
                    nDTO.setGoods_title(keyword); // 임시로 keyword 사용(count를 위함)

                    /*
                    * 로그인 안한 상태의 검색어에 해당하는 게시물 수를 가져옴
                    * addr2에 세팅된 값이 없기 때문에, null 값 전달(아마도! 추후 검사 예정)
                    * 정렬은 게시글 수에 영향을 미치지 않기 때문에 기존 검색결과 카운팅 함수 그대로 사용
                    * */
                    total = pageService.cntSearchType(nDTO);
                    log.info("가져온 (비로그인, 검색, 정렬) 결과 게시물 수 : " + total);

                    nDTO = null;
                    // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
                    pDTO = new SearchCriteria(odType, total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), searchType, keyword);

                    log.info("비 로그인 + 검색 진행 + 정렬 진행 pDTO 세팅 끝!");
                }
            }
        }

        // 로그인 상태로 페이지 로딩 또는 검색을 진행한다면
        else if (addr2 != null) {
            if (searchType == null && keyword == null) {
                log.info("로그인 + 기본 페이지 로딩(검색어 없음");

                NoticeDTO nDTO = new NoticeDTO();
                nDTO.setAddr2(addr2);

                // 지역구에 해당하는 게시물 수를 가져옴(count *)
                // @param addr2
                total = pageService.cntAddrNotice(nDTO);

                log.info("가져온 가입 지역구 전체 게시물 수(int total) : " + total);

                // @RequestParam과 db쿼리를 통해 가져온 total 값을 pDTO에 세팅
                // 오버로딩한 SearchCriteria 객체를 사용하여, pDTO에 값을 지정
                pDTO = new SearchCriteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), addr2);

                nDTO = null;
                log.info("로그인 + 기본 페이지 로딩(검색어 없음) pDTO 세팅 끝!");

            } else { // 로그인 상태로, 검색했다면(검색 결과에 따른 정렬 제공)

                // 1. 로그인 + 검색 + 정렬 안함
                if (odType == null) {
                    log.info("비 로그인 + 검색 진행 + 정렬X");

                    NoticeDTO nDTO = new NoticeDTO();
                    nDTO.setCategory(searchType); // 임시로 searchType 사용
                    nDTO.setGoods_title(keyword); // 임시로 keyword 사용(count를 위함)
                    nDTO.setAddr2(addr2);

                    log.info("로그인 상태로 검색 진행 예정 -> addr2 세팅? : " + nDTO.getAddr2());

                    // 로그인 안한 상태의 검색어에 해당하는 게시물 수를 가져옴
                    total = pageService.cntSearchType(nDTO);
                    log.info("가져온 지역구(로그인 O) + 검색된 게시물 수 : " + total);

                    nDTO = null;
                    // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
                    pDTO = new SearchCriteria(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), addr2, searchType, keyword);


                    /** 로그인한 사용자의 최근 검색어 저장을 위해 cDTO에 회원번호, 검색어를 셋팅
                     * 검색+정렬의 경우에는 이미 검색된 단어로 정렬하기 때문에, 같은 키워드로 첫 검색 시에만 최근검색어를 저장
                     **/

                    NoticeDTO cDTO = new NoticeDTO();
                    cDTO.setUser_no(user_no);
                    cDTO.setKeyword(keyword);

                    try {
                        // 최근검색어 redis에 저장
                        searchService.insertKeyword(cDTO);

                    } catch(Exception e) {
                        log.info("최근검색어 insert 실패! : " + e.toString());
                        e.printStackTrace();
                    }

                    log.info("(Controller) 검색어 Insert 완료!");

                    cDTO = null;
                    //nDTO = null;
                    log.info("로그인 + 검색 진행 pDTO 세팅 끝!");
                }

                // 2. 로그인 + 검색 + 정렬 진행
                else {
                    log.info("로그인 + 검색 진행 + 정렬 진행");
                    NoticeDTO nDTO = new NoticeDTO();
                    nDTO.setCategory(searchType); // 임시로 searchType 사용
                    nDTO.setGoods_title(keyword); // 임시로 keyword 사용(count를 위함)
                    nDTO.setAddr2(addr2);

                    /*
                     * 로그인 안한 상태의 검색어에 해당하는 게시물 수를 가져옴
                     * addr2에 세팅된 값이 없기 때문에, null 값 전달(아마도! 추후 검사 예정)
                     * 정렬은 게시글 수에 영향을 미치지 않기 때문에 기존 검색결과 카운팅 함수 그대로 사용
                     * */
                    total = pageService.cntSearchType(nDTO);
                    log.info("가져온 (로그인, 검색, 정렬) 결과 게시물 수 : " + total);

                    nDTO = null;
                    // @RequestParam과 db쿼리를 통해 가져온 값을 pDTO에 세팅
                    pDTO = new SearchCriteria(odType, total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage), addr2, searchType, keyword);

                    log.info("로그인 + 검색 진행 + 정렬 진행!");
                }
            }
        }

        // try-catch문을 사용하여 db 쿼리에 오류없이 전달하여 값을 받아오는지 확인
        try {
            pageService.searchList(pDTO);
        } catch(Exception e) {
            log.info("받아오기 실패!" + e.toString());
            e.printStackTrace();
        }
        /*
        NoticeDTO rDTO = new NoticeDTO();
        List<NoticeDTO> rList = pageService.searchList(pDTO);

        for(int i=0; i<rList.size(); i++) {
            NoticeDTO nDTO = rList.get(i);
            System.out.println("검색 결과 가져온 값들(상품명) : " + nDTO.getGoods_title());
            System.out.println("검색 결과 가져온 값들(주소-비로그인시 null) : " + rDTO.getAddr2());
        } */

        model.addAttribute("paging",pDTO);
        model.addAttribute("searchList", pageService.searchList(pDTO));

        pDTO = null;

        log.info(this.getClass().getName() + ".SearchList(판매글 검색 페이징) End!");

        return "/notice/searchList";
    }

    // 최근 검색어 불러오기
    @ResponseBody
    @RequestMapping(value="/getKeyword")
    public Set getKeyword(HttpSession session) throws Exception {

        log.info(this.getClass().getName() + ".getKeyword(최근검색어 불러오기) Start!");

        String user_no = (String) session.getAttribute("SS_USER_NO");
        log.info("user_no(회원을 위한 검색어 저장) : " + user_no);

        NoticeDTO pDTO = new NoticeDTO();
        pDTO.setUser_no(user_no);
        
        // 회원번호에 해당하는 최근검색어 가져오기(redis)
        Set rList = searchService.getKeyword(pDTO);

        if (rList == null) {
            rList = new LinkedHashSet();
        }
        pDTO = null;

        log.info(this.getClass().getName() + ".getKeyword(최근검색어 불러오기) End!");

        return rList;
    }
}
