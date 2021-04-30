<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="poly.util.CmmUtil" %>
<%
    //Controller에 저장된 세션으로 로그인할 때 생성됨
    String SS_USER_NO = ((String)session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = ((String)session.getAttribute("SS_USER_NAME"));
    String addr2 = CmmUtil.nvl((String)request.getAttribute("addr2"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Around-Sell</title>
</head>
<body>
<a href="/index.do">메인 페이지</a>
<a href="/signup.do">회원가입</a>
<% if (SS_USER_NO == null) { %> <!--세션이 설정되지 않은 경우(=로그인되지 않은 경우) 로그인 표시-->
    <a href="/logIn.do">로그인</a>
<% } else { %> <!--세션이 설정된 경우에는, 이름 + 로그아웃 표시-->
    <%=SS_USER_NO%>번 회원 <%=SS_USER_NAME %>님 환영합니다~ <br>
    <%=(String)request.getAttribute("addr2")%>
    <a href="/logOut.do">로그아웃</a>
<% } %>
</body>
</html>