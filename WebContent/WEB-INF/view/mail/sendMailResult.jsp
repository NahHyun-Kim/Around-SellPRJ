<%@page import="static poly.util.CmmUtil.nvl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    
    String jspRes = nvl((String)request.getAttribute("res"),"0");
    
    String toMail = nvl(request.getParameter("toMail")); // 받는사람
    String title = nvl(request.getParameter("title")); //제목
    String contents = nvl(request.getParameter("contents")); // 내용
   
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 발송 결과 보기</title>
</head>
<body>
<%
//메일 발송이 성공했다면...
if(jspRes.equals("1")){
	
	out.println(toMail + "로 메일 전송이 성공하였습니다.");
	out.println("메일 제목 : " + title);
	out.println("메일 내용 : " + contents);
}else{
	out.println(toMail + "로 메일 전송이 실패하였습니다.");
}
%>
</body>
</html>