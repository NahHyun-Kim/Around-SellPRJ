package poly.dto;

public class NoticeDTO {

    // 상품 관련
    private String goods_no; //상품 번호
    private String goods_title; //상품명(판매글 제목)
    private String goods_detail; //상품 설명(판매글 내용)
    private String goods_price; //상품 가격
    private String goods_addr; //상품 판매 장소(간략)
    private String goods_addr2; //상품 판매 상세 주소
    private String addr2; //상품 지역구
    private String category; //상품 분류(카테고리)
    private String hit; //조회수
    private String reg_dt; //등록일(default current_date)

    private String imgs; //이미지 경로(경로+이름)

    // 지도 관련
    private String laty; //위도
    private String longx; //경도

    // 회원 관련
    private String user_no; //회원 번호
    private String reg_id; //등록자(user_name)

    /*
    * org.apache.ibatis.reflection.ReflectionException: There is no getter for property named 'typeArr' in 'class poly.dto.NoticeDTO'
    * 부분의 오류 캐치를 위해 작성
    * */

    // 검색어 관련
    private String searchType; //검색 종류
    private String keyword; //검색어

    private String cnt; //count 수

    public String getCnt() {
        return cnt;
    }

    public void setCnt(String cnt) {
        this.cnt = cnt;
    }

    public String getLaty() {
        return laty;
    }

    public void setLaty(String laty) {
        this.laty = laty;
    }

    public String getLongx() {
        return longx;
    }

    public void setLongx(String longx) {
        this.longx = longx;
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

    // getTypeArr()는 검색 조건을 한 글자로 하고, 배열로 만들어서 처리한다.
    // mybatis의 동적 태그를 활용함
    public String[] getTypeArr() {
        return searchType == null? new String[] {}: searchType.split("");
    }

    public String getImgs() {
        return imgs;
    }

    public void setImgs(String imgs) {
        this.imgs = imgs;
    }

    public String getAddr2() {
        return addr2;
    }

    public void setAddr2(String addr2) {
        this.addr2 = addr2;
    }

    public String getGoods_no() {
        return goods_no;
    }

    public void setGoods_no(String goods_no) {
        this.goods_no = goods_no;
    }

    public String getGoods_title() {
        return goods_title;
    }

    public void setGoods_title(String goods_title) {
        this.goods_title = goods_title;
    }

    public String getGoods_detail() {
        return goods_detail;
    }

    public void setGoods_detail(String goods_detail) {
        this.goods_detail = goods_detail;
    }

    public String getGoods_price() {
        return goods_price;
    }

    public void setGoods_price(String goods_price) {
        this.goods_price = goods_price;
    }

    public String getGoods_addr() {
        return goods_addr;
    }

    public void setGoods_addr(String goods_addr) {
        this.goods_addr = goods_addr;
    }

    public String getGoods_addr2() {
        return goods_addr2;
    }

    public void setGoods_addr2(String goods_addr2) {
        this.goods_addr2 = goods_addr2;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getHit() {
        return hit;
    }

    public void setHit(String hit) {
        this.hit = hit;
    }

    public String getReg_dt() {
        return reg_dt;
    }

    public void setReg_dt(String reg_dt) {
        this.reg_dt = reg_dt;
    }

    public String getUser_no() {
        return user_no;
    }

    public void setUser_no(String user_no) {
        this.user_no = user_no;
    }

    public String getReg_id() {
        return reg_id;
    }

    public void setReg_id(String reg_id) {
        this.reg_id = reg_id;
    }
}
