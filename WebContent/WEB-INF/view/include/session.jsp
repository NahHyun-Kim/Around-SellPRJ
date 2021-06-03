<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%
    // nav(top)에 공통으로 사용되는 session값
    String SS_USER_NO = ((String) session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = ((String) session.getAttribute("SS_USER_NAME"));
    String SS_USER_ADDR = ((String) session.getAttribute("SS_USER_ADDR"));
    String SS_USER_ADDR2 = ((String) session.getAttribute("SS_USER_ADDR2"));
    System.out.println("회원번호 : " + SS_USER_NO);
    System.out.println("회원번호 : " + (SS_USER_NO == null));

%>