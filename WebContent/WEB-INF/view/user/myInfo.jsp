<%@ page import="poly.dto.UserDTO" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    이름 : <%=CmmUtil.nvl(rDTO.getUser_name())%>
    이메일 : <%=CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()))%>
    전화번호 : <%=CmmUtil.nvl(rDTO.getPhone_no())%>
    주소 : <%=CmmUtil.nvl(rDTO.getAddr())%>
    가입일 : <%=CmmUtil.nvl(rDTO.getReg_dt())%>
    <a href="/updateUserForm.do">회원정보 수정하기</a>
</body>
</html>
