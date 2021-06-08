<%@ page import="poly.dto.UserDTO" %>
<%@ include file="../include/session.jsp" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
%>
<html>
<head>
    <title>마이페이지</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>

</head>
<body>
<!-- preloader -->
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->

    이름 : <%=CmmUtil.nvl(rDTO.getUser_name())%>
    이메일 : <%=CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()))%>
    전화번호 : <%=CmmUtil.nvl(rDTO.getPhone_no())%>
    주소 : <%=CmmUtil.nvl(rDTO.getAddr())%>
    가입일 : <%=CmmUtil.nvl(rDTO.getReg_dt())%>
    <a href="/updateUserForm.do">회원정보 수정하기</a>

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>
</body>
</html>
