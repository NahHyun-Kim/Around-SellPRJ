package poly.dto;

public class CommentDTO {

    private String comment_no; // 댓글 번호(pk)
    private String goods_no; // 상품 번호(on delete cascade 설정)
    private String user_no; // 회원 번호(on delete cascade 설정)
    private String content; // 댓글 내용
    private String user_name; // 작성자 이름

    public String getComment_no() {
        return comment_no;
    }

    public void setComment_no(String comment_no) {
        this.comment_no = comment_no;
    }

    public String getGoods_no() {
        return goods_no;
    }

    public void setGoods_no(String goods_no) {
        this.goods_no = goods_no;
    }

    public String getUser_no() {
        return user_no;
    }

    public void setUser_no(String user_no) {
        this.user_no = user_no;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }
}
