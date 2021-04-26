<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 전송페이지</title>
</head>
<body>
<form action="/mail/sendMail.do" method="post">
<table border="1">
<tr>
	<td><h3>받는사람</h3></td>
	<td><input type="text" name="toMail" style="width:500px;" required></td>
</tr>
<tr>
	<td><h3>메일제목</h3></td>
	<td><input type="text" name="title" style="width:500px;" required></td>
</tr>
<tr>
	<td><h3>메일내용</h3></td>
	<td><input type="text" name="contents" style="width:500px; height:300px;" required></td>
</tr>
</table>
<br>
<input type="submit" value="메일전송">
</form>
</body>
</html>