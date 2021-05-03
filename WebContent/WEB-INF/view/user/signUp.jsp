<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Around-Sell 회원가입</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<div class="container">
    <form action="/insertUser.do" method="POST">
        <!-- 이메일 입력 후, ajax를 통해 이메일 중복 여부 검사 -->
        <input type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." onfocusout="emailCheck()" required="required"/>
        <a id="btn-id">중복확인</a>
        <br/>
        <input type="text" name="user_name" id="name" placeholder="이름을 입력해 주세요." required="required"/>
        <br/>
        <input type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." required="required"/>
        <br/>
        <input type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." required="required" />
        <br/>

        <input type="text" name="phone_no" id="phone_no" placeholder="-를 제외한 전화번호를 입력해 주세요." onfocusout="phoneCheck" required=""
        <br/>
        <input type="text" name="addr" id="sample5_address" readonly="주소" placeholder="주소를 검색해 주세요"
               required="required"/>
        <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>


<!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
<div id="map"></div>

<input type="submit" value="회원가입">
</form>
</div>
<script>
    function
</script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

<!-- 회원가입 유효성 체크 js -->
<script type="text/javascript" src="/resource/valid/signupCheck.js"></script>
</body>
</html>
