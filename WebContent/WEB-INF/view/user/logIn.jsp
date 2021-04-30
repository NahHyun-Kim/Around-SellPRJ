<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Around-Sell 로그인</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<div class="container">
    <form action="/getLogin.do" method="POST">
        <!-- 이메일, 비밀번호를 입력하여 로그인 -->
        <input type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." required="required"/>
        <br/>
        <input type="password" name="password" id="password" placeholder="비밀번호를 입력해 주세요." required="required"/>
        <br/>

        <input type="submit" value="로그인">
        <input type="button" value="회원가입" onclick="location.href='/signup.do'">
    </form>
</div>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

<!-- 회원가입 유효성 체크 js -->
<script type="text/javascript" src="/resource/valid/signupCheck.js"></script>
</body>
</html>

