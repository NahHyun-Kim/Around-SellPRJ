<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>아이디 & 비밀번호 찾기</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
    <div class="container">
    <div>
        <input type="radio" id="search_1" name="search_total" onclick="search_check(1)" checked="checked"/>
        <label for="search_1">이메일 찾기</label>
    </div>
    <div>
        <input type="radio" id="search_2" name="search_total" onclick="search_check(2)"/>
        <label for="search_2">비밀번호 찾기</label>
    </div>

    <!-- 이메일 찾기 -->
    <form action="/findEmailUser.do", method="post", onsubmit="return emailSearch()">
    <div id="searchE">

        <!-- 이메일을 찾기 위해 핸드폰 번호를 입력 -->
        <div class="form-group">
            <label for="inputPhone">핸드폰 번호</label>
            <div>
            <input type="text" id="inputPhone" name="inputPhone" placeholder="ex)01012345678"/>
            </div>
        </div>

        <!-- 입력 시 이메일 찾기 활성화-->
        <div class="form-group">
            <input type="submit" value="이메일 찾기"/>
        </div>
    </div>
    </form>

    <!-- 비밀번호 찾기 -->
    <!-- 아직 진행중이라 임시로 action 주소를 /userSearch.do로 설정, 추후 변경 예정 -->
    <form action="/findPassword.do", method="post", onsubmit="return emailSearch()">
        <!-- 로딩 시, default 값으로 이메일 찾기가 표시되기 때문에 기본 표시에서 숨겨 놓는다. -->
    <div id="searchP" style="display: none;">

        <!-- 비밀번호를 찾기 위해 이메일을 입력 -->
        <div class="form-group">
            <label for="inputEmail">이메일</label>
            <div>
                <input type="email" id="inputEmail" name="inputEmail" placeholder="가입 시 이메일을 입력해 주세요."/>
            </div>
        </div>

        <!-- 입력 시 비밀번호 찾기 활성화(인증메일 발송), 입력하지 않은 경우/일치하지 않는 경우 모달 창 띄움 -->
        <div class="form-group">
            <input type="submit" value="비밀번호 찾기"/>
        </div>
    </div>
    </form>

    </div>

    <!--
    <div id="background_modal">
        <div>
            <h4><b>회원님의 이메일은?</b> <span class="close"></span>
            </h4>
            <br>
            <h2 id="email_value"></h2>
            <br>
            <button type="button" id="pwSearch_btn">비밀번호 찾기</button>
        </div>
    </div>
    -->

    <!-- 값을 입력하지 않을 경우, 입력할 것을 알려주는 모달창 -->
    <div class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"></h5>
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
    <script>

        $(document).ready(function() {


        /* div 자체에서 style=display:none;을 주고, 필요할 때 show 또는 "" 해도 될듯 하다.
        $(document).ready(function() {
        document.getElementById("background_modal").style.display = "none";
        }) */

        $("#close").click(function() {
            $(".modal").fadeOut();
        });
    </script>
    <!-- 이메일/비밀번호 찾기 js -->
    <script type="text/javascript" src="/resource/valid/searchUser.js"></script>

    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/user.css"/>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
