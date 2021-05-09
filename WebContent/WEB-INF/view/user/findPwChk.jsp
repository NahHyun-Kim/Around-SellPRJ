<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%
    String msg = CmmUtil.nvl((String)request.getAttribute("msg"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>AroundSell-임시 비밀번호 확인</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        alert("<%=msg%>");
    </script>
</head>
<body>
    <h1>입력한 이메일로 받은 인증번호를 입력하세요.</h1>
        <form action="/findAuth.do" method="post">
            <div class="form-group">
            <label for="user_auth">인증번호 입력 : </label>
                <div>
                    <input type="text" id="user_auth" name="user_auth" placeholder="인증번호를 입력하세요"/>
                </div>
            </div>
            <div class="form-group">
                <input type="submit" value="인증번호 전송"/>
            </div>
        </form>

    <!-- 이메일/비밀번호 찾기 js -->
    <script type="text/javascript" src="/resource/valid/searchUser.js"></script>

    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/user.css"/>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
