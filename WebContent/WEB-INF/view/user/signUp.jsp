<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Around-Sell 회원가입</title>
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

    <form action="/insertUser.do" method="POST" onsubmit="return signupCheck()">
        <!-- 이메일 입력 후, ajax를 통해 이메일 중복 여부 검사 -->
        <div>
            <label for="user_email">이메일</label>
                <input type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." />
            <div class="check_font" id="email_check"></div>
        </div>
        <div>
            <label for="user_name">이름</label>
                <input type="text" name="user_name" id="user_name" placeholder="이름을 입력해 주세요."/>
            <div class="check_font" id="name_check"></div>
        </div>
        <div>
            <label for="password_1">비밀번호</label>
                <input type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." />
            <div class="check_font" id="pw_check1"></div>
        </div>
        <div>
            <label for="password_2">비밀번호 확인</label>
                <input type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요."/>
            <div class="check_font" id="pw_check2"></div>
        </div>
        <div>
            <label for="phone_no">핸드폰 번호</label>
                <input type="text" name="phone_no" id="phone_no" placeholder="-를 제외한 전화번호를 입력해 주세요."/>
            <div class="check_font" id="phone_check"></div>
        </div>
        <div>
            <label for="sample5_address">주소 입력</label>
                <input type="text" name="addr" id="sample5_address" placeholder="주소를 검색해 주세요"/>
                <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>
            <div class="check_font" id="addr_check"></div>
                <!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
                <div id="map"></div>
        </div>
<input type="reset" value="다시 작성">
<input type="submit" value="회원가입">
        <input type="button" onclick="location.href='/logIn.do'" value="로그인"/>
</form>
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

<!-- 회원가입 유효성 체크 js -->

<script type="text/javascript" src="/resource/valid/userCheck.js"></script>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
<script type="text/javascript">
    //close 버튼을 클릭하면, modal창 사라짐
    $("#close").click(function() {
        $(".modal").fadeOut();
    });
</script>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp"%>
</body>
</html>
