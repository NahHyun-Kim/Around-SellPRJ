<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="java.util.List" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% List<UserDTO> rList = (List<UserDTO>) request.getAttribute("rList");
    if (rList == null) {
        rList = new ArrayList<UserDTO>();
    }
%>
<html>
<head>
    <title>AroundSell- 회원 관리</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
    <div class="container">
        <h1>회원 관리 - 리스트 조회</h1>
        <div class="row">
            <div class="col-3 text-center"><b>회원 번호</b></div>
            <div class="col-2 text-center"><b>회원 이름</b></div>
            <div class="col-3 text-center"><b>가입일</b></div>
            <div class="col-2 text-center"><b>주소지</b></div>
        </div>

        <% int i=1;
        for(UserDTO r : rList) { %>
        <div class="row">
            <div class="col-3 text-center"><input type="radio" id="<%=CmmUtil.nvl(r.getUser_no())%>"/><%=CmmUtil.nvl(r.getUser_no())%></div>
            <div class="col-2 text-center"><a href="/getUserDetail.do?no=<%=r.getUser_no()%>"><%=CmmUtil.nvl(r.getUser_name()) %></a></div>
            <div class="col-3 text-center"><%=CmmUtil.nvl(r.getReg_dt()) %></div>
            <div class="col-2 text-center"><%=CmmUtil.nvl(r.getAddr2()) %></div>
        </div>
        <% i++;} %>

    </div>
    <!-- bootstrap, css 파일 -->
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
