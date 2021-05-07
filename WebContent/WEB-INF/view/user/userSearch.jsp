<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>아이디 & 비밀번호 찾기</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            document.getElementById("searchP").style.display = "none";
            document.getElementById("searchE").style.display = "";
        })
    </script>
</head>
<body>
    <div>
    <div>
        <input type="radio" id="search_1" name="search_total" onclick="search_check(1)"/>
        <label for="search_1">이메일 찾기</label>
    </div>
    <div>
        <input type="radio" id="search_2" name="search_total" onclick="search_check(2)"/>
        <label for="search_2">비밀번호 찾기</label>
    </div>
    <div id="searchE">
        <div>
            <label for="inputPhone_1">핸드폰 번호</label>
        </div>
            <input type="text" id="inputPhone_1" name="inputName_1" placeholder="ex)01012345678"/>
    </div>
    <div id="searchP">
        <div>
            <label for="inputEmail_1">이메일</label>
        </div>
            <input type="email" id="inputEmail_1" name="inputEmail_1" placeholder="가입 시 이메일을 입력해 주세요."/>
    </div>
        <button id="searchBtn2" type="button">확인</button>
        <input type="reset"/>
    </div>

    <div id="background_modal">
        <div>
            <h4><b>회원님의 이메일은?</b> <span class="close"></span>
            </h4>
            <br>
            <h2 id="email_value"></h2>
            <br>
            <button type="button" id="pw"
        </div>
    </div>
    <!-- 회원가입 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/searchUser.js"></script>

    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/user.css"/>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
