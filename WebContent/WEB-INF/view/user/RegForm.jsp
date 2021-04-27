<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<input type="email" name="email" id="email" placeholder="이메일을 입력해 주세요." required="required" />
<br/>
<input type="text" name="name" id="name" placeholder="이름을 입력해 주세요." required="required" />
<br/>
<input type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." required="required" />
<br/>
<input type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." required="required />
<br/>

<div class="form__field">
    <input type="text" id="sample2_postcode" placeholder="우편번호" autocomplete="off">
    <input type="button" onclick="sample2_execDaumPostcode()" value="우편번호 찾기" required="required"/>
    <br />
    <input type="text" name="addr" id="addr" placeholder="주소를 선택해 주세요." required="required" autocomplete="off">
</div>

<div class="form__field">
<input type="text" id="sample5_address" placeholder="주소">
<input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"><br>
</div>

<div id="map" style="width:350px;height:200px;margin-top:10px;display:none"></div>

<!-- 팝업창 닫기를 위한 코드 -->
<div id="layer"
     style="display: none; position: fixed; overflow: hidden; z-index: 1; -webkit-overflow-scrolling: touch;">

    <img src="//t1.daumcdn.net/postcode/resource/images/close.png"
         id="btnCloseLayer"
         style="cursor: pointer; position: absolute; right: -3px; top: -3px; z-index: 1"
         onclick="closeDaumPostcode()" alt="닫기 버튼">

</div>

<!-- example5, 주소 입력 시 주소 + 지도 표시하는 예제 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script>
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new daum.maps.LatLng(37.537187, 127.005476), // 지도의 중심좌표
            level: 5 // 지도의 확대 레벨
        };

    //지도를 미리 생성
    var map = new daum.maps.Map(mapContainer, mapOption);
    //주소-좌표 변환 객체를 생성
    var geocoder = new daum.maps.services.Geocoder();
    //마커를 미리 생성
    var marker = new daum.maps.Marker({
        position: new daum.maps.LatLng(37.537187, 127.005476),
        map: map
    });

    function sample5_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.address; // 최종 주소 변수

                // 주소 정보를 해당 필드에 넣는다.
                document.getElementById("sample5_address").value = addr;
                // 주소로 상세 정보를 검색
                geocoder.addressSearch(data.address, function(results, status) {
                    // 정상적으로 검색이 완료됐으면
                    if (status === daum.maps.services.Status.OK) {

                        var result = results[0]; //첫번째 결과의 값을 활용

                        // 해당 주소에 대한 좌표를 받아서
                        var coords = new daum.maps.LatLng(result.y, result.x);
                        // 지도를 보여준다.
                        mapContainer.style.display = "block";
                        map.relayout();
                        // 지도 중심을 변경한다.
                        map.setCenter(coords);
                        // 마커를 결과값으로 받은 위치로 옮긴다.
                        marker.setPosition(coords)
                    }
                });
            }
        }).open();
    }

</script>

<div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript" src="/resource/js/addrAPI.js"></script>
</body>
</html>
