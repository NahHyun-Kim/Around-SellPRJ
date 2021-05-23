<%@ page import="poly.dto.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CartDTO> rList = (List<CartDTO>) request.getAttribute("rList");
    String user_no =(String) session.getAttribute("SS_USER_NO");
    if (rList == null) {
        rList = new ArrayList<CartDTO>();
    }

    int total = 0;
%>
<html>
<head>
    <title>관심상품</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<a href="/index.do">메인으로</a>
<a href="/searchList.do">판매글 </a>
<a href="javascript:history.back()">뒤로가기</a>

<div class="container">

    <div id="cartCnt"></div>
    <div class="row">
        <% for (int i=0; i<rList.size(); i++) {
            CartDTO rDTO = rList.get(i);

            if (rDTO == null) {
                rDTO = new CartDTO();
            }

            total++;

         %>
        <div class="col">
            <input type="checkbox" id="del" value="<%=rDTO.getGoods_no()%>"/>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <img src="/resource/images/<%=rDTO.getImgs()%>" style="width: 150px; object-fit: contain" alt="이미지 불러오기 실패"/>
            </a>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <%=rDTO.getGoods_title()%>
            </a>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <%=rDTO.getGoods_price()%>원
            </a>
        </div>

        <% } %>
    </div>

    <input type="hidden" id="user_no" value="<%=user_no%>"/>
    <button class="btn btn-warning" id="delOne" onclick="selectDel()">선택 상품 삭제</button>
    <button class="btn btn-danger" id="delAll" onclick="deleteAll()">관심상품 전체 비우기</button>
</div>

<script type="text/javascript">
    var res = document.getElementById("cartCnt");
    var total = (<%=total%>);

    console.log("받아온 판매글 개수 : " + total);
    // console.log("String으로 변환되지 않는지? : " + typeof total);

    // 검색 결과가 없다면, 검색 결과가 없다는 멘트와 함께 상품 보러가기 페이지로 이동 링크를 띄운다.
    if (total == 0) {

        var resultMent = "<span style='color:#ff0000'>" + "검색 결과가 없습니다."  + "</span>"
        + "<br/>" + "<span style='color: blue'>" + "<a href='/searchList.do'>상품 보러가기</a>";

        console.log("검색결과 멘트 : " + resultMent);

        $(".btn").hide();

        res.innerHTML = resultMent;
    } else if (total != 0) {

        // 총 상품 건수와 함께, 판매글 목록을 표시함
        var resultMent = "총 " + "<span style='color:red'>" + "<%=total%>" + "</span>" + "건의 상품";

        console.log("검색결과 멘트 : " + resultMent);

        res.innerHTML = resultMent;
    }

    var user_no = document.getElementById("user_no").value;
    console.log("받아온 회원 번호 : " + user_no);

    // 선택한 상품만 장바구니 삭제를 눌렀을 때 함수 실행
    function selectDel() {

    }

    // 전체 상품 비우기를 눌렀을 때 함수 실행
    function deleteAll() {

        console.log("삭제할 회원 번호(관심상품) : " + user_no);
        if (user_no != null) {
            $.ajax({
                url: "/delCart.do",
                type: "post",
                dataType: "json",
                data: {
                    // 해당하는 회원 번호를 장바구니 전체 삭제를 위해 보냄
                    "user_no" : user_no
                },
                success: function(data) {
                    // 삭제에 성공했다면,
                    var delConfirm = confirm("관심상품 목록을 비웠습니다. 상품을 보러 가시겠습니까?");

                    if (data > 0) {// 삭제된 수만큼 data를 반환하여, data==1이 아니라 data>0으로 한다.
                        if (delConfirm) {
                            location.href = "/searchList.do";
                        } else {
                            window.location.reload();
                        }
                    } else if (data == 0) {
                        alert("삭제에 실패했습니다.");
                        window.location.reload();
                    }
                },

                error:function(jqXHR, textStatus, errorThrown) {
                    alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                    console.log(errorThrown);
                }
            })
        }
    }
</script>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
