<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@page import="poly.util.CmmUtil"%>
<%
    String msg = CmmUtil.nvl((String)request.getAttribute("msg"));
    String url = CmmUtil.nvl((String)request.getAttribute("url"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <script type="text/javascript">
        alert("<%=msg%>");
        location.href="<%=url%>";
    </script>
</head>
<body>

</body>
</html>