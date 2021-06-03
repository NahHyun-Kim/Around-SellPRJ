<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Around-Sell 로그인</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>
</head>

<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

<div class="container">

    <form action="/getLogin.do" method="POST" onsubmit="return loginChk()">
        <!-- 이메일, 비밀번호를 입력하여 로그인 -->
        <div>
            <label for="user_email">이메일</label>
            <input type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." />
            <div class="check_font" id="email_check"></div>
        </div>
        <div>
            <label for="password">비밀번호</label>
            <input type="password" name="password" id="password" placeholder="비밀번호를 입력해 주세요."/>
            <div class="check_font" id="pwd_check"></div>
        </div>
        <input type="submit" value="로그인">
        <input type="button" value="회원가입" onclick="location.href='/signup.do'">
        <input type="button" value="이메일/비밀번호 찾기" onclick="location.href='/userSearch.do'">
    </form>
</div>
<div class="modal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button id="close" type="button" class="btn btn-info" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
</div>
    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/user.css"/>
    <!--<script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>-->

     <!-- 로그인 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/loginCheck.js"></script>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>

