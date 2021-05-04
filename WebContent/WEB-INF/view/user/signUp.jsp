<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Around-Sell 회원가입</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <!-- 회원가입 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/signupCheck.js"></script>
</head>
<body>
<div class="container">
    <form action="/insertUser.do" method="POST">
        <!-- 이메일 입력 후, ajax를 통해 이메일 중복 여부 검사 -->
        <div>
            <label for="user_email">이메일</label>
                <input type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." onfocusout="emailCheck()" required="required"/>
            <div class="check_font" id="email_check"></div>
        </div>
        <div>
            <label for="user_name">이름</label>
                <input type="text" name="user_name" id="user_name" placeholder="이름을 입력해 주세요." required="required"/>
            <div class="check_font" id="name_check"></div>
        </div>
        <div>
            <label for="password_1">비밀번호</label>
                <input type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." required="required"/>
            <div class="check_font" id="pw_check"></div>
        </div>
        <div>
            <label for="password_2">비밀번호 확인</label>
                <input type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." required="required" />
            <div class="check_font" id="pw2_check"></div>
        </div>
        <div>
            <label for="phone_no">핸드폰 번호</label>
                <input type="text" name="phone_no" id="phone_no" placeholder="-를 제외한 전화번호를 입력해 주세요." onfocusout="phoneCheck()" required="required"/>
            <div class="check_font" id="phone_check"></div>
        </div>
        <div>
            <label for="sample5_address">주소 입력</label>
                <input type="text" name="addr" id="sample5_address" readonly="주소" placeholder="주소를 검색해 주세요"
               required="required"/>
                <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>
            <div class="check_font" id="addr_check"></div>
                <!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
                <div id="map"></div>
        </div>

<input type="submit" value="회원가입">
</form>

</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

<script type="text/javascript">

    // 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
    var nmchk = document.getElementById("name_check");

    // 이름에 특수문자가 들어가지 않도록 설정
    $("#user_name").blur(function() {
        if (nameJ.test($("#user_name").val())) {
            console.log(nameJ.test($("#user_name").val()));
            $(nmchk).text('이름이 입력되었습니다 :)');
            $(nmchk).css('color', 'green');
        } else if ($("#user_name").val() == "") { //이름이 입력되지 않았다면
            $(nmchk).text('이름을 입력해 주세요.');
            $(nmchk).css('color', 'red');
        } else { //이름 형식이 유효하지 않다면
            $(nmchk).text('이름을 확인해 주세요.');
            $(nmchk).css('color', 'red');
        }
    });

    // 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
    var adchk = document.getElementById("addr_check");

    // 주소에 공백이 들어가지 않도록 설정(빈 값)
    $("#sample5_address").blur(function() {
        if ($("#sample5_address").val() == "") {
            $(adchk).text('주소를 선택해 주세요.');
            $(adchk).css('color', 'red');
        } else {
            $(adchk).text('주소가 입력되었습니다 :)');
            $(adchk).css('color', 'green');
        }
    });

    //폰번호 01012345678 형식으로, 조건에 맞는 형태만 사용
    var phoneJ = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
    var phchk = document.getElementById("phone_check");

    function phoneCheck() {
        if (phoneJ.test($("#phone_no").val()) == false) {
            if ($("#phone_no").val() == "") {
                $(phchk).text('핸드폰 번호를 입력해 주세요.');
                $(phchk).css('color', 'red');
            }
            else { //빈 값도 false로 인식되어, if문 안에서 조건을 따로 줌.
                $(phchk).text('유효하지 않은 핸드폰 번호입니다.');
                $(phchk).css('color', 'red');
        }

        } else { // 유효성을 만족한다면
            // ajax 호출
            $.ajax({
                url : "/signup/phoneCheck.do",
                type : "post",
                dataType : "json",
                data : {
                    "phone_no" : $("#phone_no").val()
                },
                success : function (data) {
                    if (data == 1) {
                        $(phchk).text('이미 가입된 핸드폰 번호입니다.');
                        $(phchk).css('color', 'red');
                    } else {
                        $(phchk).text('사용 가능한 핸드폰 번호입니다 :)');
                        $(phchk).css('color', 'green');
                    }
                }
            })
        }

    };
</script>
</body>
</html>
