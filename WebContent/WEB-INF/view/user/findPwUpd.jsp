<%@ page import="poly.util.CmmUtil"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String user_no = (String) session.getAttribute("SS_USER_NO"); %>
<html>
<head>
    <title>AroundSell-비밀번호 변경</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
    <form action="/updatePw.do" method="post">
        <div class="form-group">
            <label for="password1">비밀번호 : </label>
            <div>
                <input type="password" id="password1" name="password1" placeholder="비밀번호를 입력해 주세요."/>
            </div>
            <div className="check_font" id="pwd1_check"></div>
        </div>
        <div class="form-group">
            <label for="password2">비밀번호 확인 : </label>
            <div>
                <input type="password" id="password2" name="password2" placeholder="비밀번호를 입력해 주세요."/>
            </div>
            <div className="check_font" id="pwd2_check"></div>
        </div>
        <div class="form-group">
            <input type="submit" value="비밀번호 변경하기"/>
        </div>
    </form>

<!-- 이메일/비밀번호 찾기 js -->
<script type="text/javascript" src="/resource/valid/searchUser.js?ver=1"></script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
