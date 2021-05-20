package poly.dto;

public class SearchCriteria extends Criteria {
    // 현재페이지, 시작페이지, 끝페이지, 게시글 총 갯수, 페이지당 글 갯수(12 또는 15), 마지막 페이지, start, end
    private int nowPage, startPage, endPage, total, cntPerPage, lastPage, start, end;
    // 한 번에 표시할 페이징 번호의 갯수
    private int cntPage = 5;

    private String addr2; //주소(로그인 or 비 로그인)

    private String searchType; //검색할 타입
    private String keyword; //검색어

    private String odType; //정렬 기준(검색 시 제공)

    public String getOdType() {
        return odType;
    }

    public void setOdType(String odType) {
        this.odType = odType;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public SearchCriteria() {

    }

    // getTypeArr()는 검색 조건을 한 글자로 하고, 배열로 만들어서 처리한다.
    // mybatis의 동적 문법으로 사용된다.
    public String[] getTypeArr() {
        return searchType == null? new String[] {}: searchType.split("");
    }

    // 비 로그인, 검색어 없는 경우
    public SearchCriteria(int total, int nowPage, int cntPerPage) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());

    }

    // 로그인, 검색어 없는 경우
    public SearchCriteria(int total, int nowPage, int cntPerPage, String addr2) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());
        setAddr2(addr2);

    }

    // 비 로그인, 검색한 경우(정렬 없는 default)
    public SearchCriteria(int total, int nowPage, int cntPerPage, String searchType, String keyword) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());
        setSearchType(searchType);
        setKeyword(keyword);
        setSearchType(searchType);
        setKeyword(keyword);
    }

    // 로그인, 검색한 경우(정렬 없는 default)
    public SearchCriteria(int total, int nowPage, int cntPerPage, String addr2, String searchType, String keyword) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());
        setSearchType(searchType);
        setKeyword(keyword);
        setAddr2(addr2);
    }

    // 비 로그인, 검색한 경우(정렬 요청)
    public SearchCriteria(String odType, int total, int nowPage, int cntPerPage, String searchType, String keyword) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());
        setSearchType(searchType);
        setKeyword(keyword);
        setSearchType(searchType);
        setKeyword(keyword);
        setOdType(odType);
    }

    // 로그인, 검색한 경우(정렬 요청)
    public SearchCriteria(String odType, int total, int nowPage, int cntPerPage, String addr2, String searchType, String keyword) {
        setNowPage(nowPage);
        setCntPerPage(cntPerPage);
        setTotal(total);
        calcLastPage(getTotal(), getCntPerPage());
        calcStartEndPage(getNowPage(), cntPage);
        calcStartEnd(getNowPage(), getCntPerPage());
        setSearchType(searchType);
        setKeyword(keyword);
        setSearchType(searchType);
        setKeyword(keyword);
        setOdType(odType);
        setAddr2(addr2);
    }

    // 마지막 페이지 계산(전체 게시글수/페이지당 게시글수-> 올림 ex) 102개/20개 -> 6개의 페이지 필요)
    public void calcLastPage(int total, int cntPerPage) {
        setLastPage((int) Math.ceil((double)total / (double)cntPerPage));
    }

    // 시작, 끝 페이지 계산
    public void calcStartEndPage(int nowPage, int cntPage) {
        setEndPage(((int)Math.ceil((double)nowPage / (double)cntPage)) * cntPage);
        if (getLastPage() < getEndPage()) {
            setEndPage(getLastPage());
        }
        setStartPage(getEndPage() - cntPage + 1);
        if (getStartPage() < 1) {
            setStartPage(1);
        }
    }

    // DB 쿼리에서 사용할 start, end값 계산
    public void calcStartEnd(int nowPage, int cntPerPage) {
        // 끝값은 현재 페이지(1,2,3페이지... * 최대 페이지 수) -> 2페이지, 9라 할때 마지막 값은 2*9 = 18
        // 9개씩 페이징된다 가정할 때, 시작은 마지막값(18)-9 + 1인 10번부터 시작한다.
        // rowNum between #{start} and #{end}로, 페이지별 해당되는 게시물을 가져온다.
        setEnd(nowPage * cntPerPage);
        setStart(getEnd() - cntPerPage + 1);
    }

    public int getNowPage() {
        return nowPage;
    }
    public void setNowPage(int nowPage) {
        this.nowPage = nowPage;
    }
    public int getStartPage() {
        return startPage;
    }
    public void setStartPage(int startPage) {
        this.startPage = startPage;
    }
    public int getEndPage() {
        return endPage;
    }
    public void setEndPage(int endPage) {
        this.endPage = endPage;
    }
    public int getTotal() {
        return total;
    }
    public void setTotal(int total) {
        this.total = total;
    }
    public int getCntPerPage() {
        return cntPerPage;
    }
    public void setCntPerPage(int cntPerPage) {
        this.cntPerPage = cntPerPage;
    }
    public int getLastPage() {
        return lastPage;
    }
    public void setLastPage(int lastPage) {
        this.lastPage = lastPage;
    }
    public int getStart() {
        return start;
    }
    public void setStart(int start) {
        this.start = start;
    }
    public int getEnd() {
        return end;
    }
    public void setEnd(int end) {
        this.end = end;
    }
    public int setCntPage() {
        return cntPage;
    }
    public void getCntPage(int cntPage) {
        this.cntPage = cntPage;
    }

    @Override
    public String toString() {
        return "SearchCriteria [nowPage=" + nowPage + ", startPage=" + startPage + ", endPage=" + endPage + ", total=" + total
                + ", cntPerPage=" + cntPerPage + ", lastPage=" + lastPage + ", start=" + start + ", end=" + end
                + ", cntPage=" + cntPage + "]";
    }
}
