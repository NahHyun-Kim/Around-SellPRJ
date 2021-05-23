<%@ page import="poly.dto.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<CartDTO> rList = (List<CartDTO>) request.getAttribute("rList");

    if (rList == null) {
        rList = new ArrayList<CartDTO>();
    }

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

    <div class="row">
        <% for (int i=0; i<rList.size(); i++) {
            CartDTO rDTO = rList.get(i);

            if (rDTO == null) {
                rDTO = new CartDTO();
            }

         %>
        <div class="col">
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

</div>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
