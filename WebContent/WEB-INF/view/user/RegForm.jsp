<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>회원가입</title>
    <style>
        #map {
            width: 350px;
            height: 200px;
            margin-top: 10px;
            display: none
        }
    </style>
</head>
<body>

<input type="email" name="email" id="email" placeholder="이메일을 입력해 주세요." required="required"/>
<br/>
<input type="text" name="name" id="name" placeholder="이름을 입력해 주세요." required="required"/>
<br/>
<input type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." required="required"/>
<br/>
<input type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." required="required" />
<br/>

<div class="form__field">
<input type="text" id="sample5_address" readonly="주소" placeholder="\주소를 검색해 주세요" required="required"/>
<input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색" /><br>
</div>
<br/>
<input type="text" id="addr2" name="addr2" placeholder="상세 주소를 입력해 주세요." autocomplete="off"/>

<!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
<div id="map"></div>

<!-- 팝업창 닫기를 위한 코드 -->
<div id="layer"
     style="display: none; position: fixed; overflow: hidden; z-index: 1; -webkit-overflow-scrolling: touch;">

    <img src="//t1.daumcdn.net/postcode/resource/images/close.png"
         id="btnCloseLayer"
         style="cursor: pointer; position: absolute; right: -3px; top: -3px; z-index: 1"
         onclick="closeDaumPostcode()" alt="닫기 버튼">

</div>

<!-- 도로명주소 API js파일 -> example5, 주소 입력 시 주소 + 지도 표시하는 예제 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>


<div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap"
         style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>
</body>
</html>
