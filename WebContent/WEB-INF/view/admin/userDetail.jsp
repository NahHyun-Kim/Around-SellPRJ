<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");%>
<html>
<head>
    <title>AroundSell- 회원 상세정보 조회</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<div class="container">
    <h1>회원 상세정보 조회</h1>
    <div class="row">
        <div class="col-sm-3 text-center"><b>회원 번호</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getUser_no())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>회원 이름</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getUser_name())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>이메일</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()))%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>가입일</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getReg_dt())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>주소지</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getAddr2())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>상세 주소</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getAddr())%></div>
    </div>
    <a href="javascript:window.history.back();"><i class="bx bx-server"></i>뒤로가기</a>
</div>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
