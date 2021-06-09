<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="poly.util.CmmUtil" %>
<%
    //전달받은 메시지
    String msg = CmmUtil.nvl((String)request.getAttribute("msg"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <!-- sweet alert2 -->
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>완료!</title>
    <script type="text/javascript">
        alert("<%=msg%>");
        top.location.href="${pageContext.request.contextPath}/searchList.do";
    </script>


</head>
<body>


</body>
</html>