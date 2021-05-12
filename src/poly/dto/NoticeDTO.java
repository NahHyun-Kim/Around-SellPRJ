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

    private String img; //이미지
    private String thumb; //썸네일 이미지

    // 회원 관련
    private String user_no; //회원 번호
    private String reg_id; //등록자(user_name)

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getThumb() {
        return thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
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
