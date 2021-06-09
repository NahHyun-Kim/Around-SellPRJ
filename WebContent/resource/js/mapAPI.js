// dom 객체가 준비되면, 리스트의 상세값을 받아와 지도 및 상호명을 표시함
$(document).ready(function() {

    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };

    // 지도를 표시할 div와  지도 옵션으로  지도 생성(mapContainer : #map, mapOption : 지도 레벨이나 위,경도 지표)
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 주소-좌표 변환 geocoder 객체 생성
    var geocoder = new kakao.maps.services.Geocoder();

    // goods_addr 에서 가져온 innerHtml 또는 innerText값을 myaddr 변수에 담음
    // document.getElementByid("id값").value; 또는 val 은 input 태그에서 가져올 수 있고, div 태그에선 안 먹힘
    // 따라서, 가져온 값.innerHTML 또는 innerText로 값을 가져올 수 있다.
    var selladdr = document.getElementById("goods_addr2").innerHTML;
    var useraddr = document.getElementById("user_addr").innerHTML;

    var la1 = document.getElementById("lat1");
    var lo1 = document.getElementById("lon1");
    var la2 = document.getElementById("lat2");
    var lo2 = document.getElementById("lon2");

    console.log("가져온 주소값 : " + selladdr);
    console.log("가져온 회원 주소값 : " + useraddr);

    // 판매 주소지를 담은 myaddr 변수로, 주소지를 검색함
    geocoder.addressSearch(selladdr, function addr1(result, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {

            // 위도, 경도값을 받아와서 저장
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            console.log(result);
            // 위도, 경도를 구분하여 거리 계산을 위해 변수 선언
            lat1 = result[0].y;
            lon1 = result[0].x;
            $(la1).text(lat1);
            $(lo1).text(lon1);

            console.log("판매 주소 변환 완료 : " + coords);
            console.log("판매주소 위도(lat1) : " + lat1);
            console.log("판매주소 경도(lon1) : " + lon1);

            // 마커 이미지의 이미지 주소입니다
            var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

            // 마커 이미지의 이미지 크기 입니다
            var imageSize = new kakao.maps.Size(24, 35);

            // 마커 이미지를 생성합니다
            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

            // 결과값으로 받은 위치를 마커로 표시
            var marker = new kakao.maps.Marker({
                map: map,
                position: coords,
                image : markerImage // 마커 이미지
            });


            // 인포윈도우로 장소에 대한 설명 표시(상호명 - goods_addr 를 받아와 저장)
            var mystore = document.getElementById("goods_addr").innerHTML;
            console.log("가져온 상호명 : " + mystore);

            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px; text-align:center;padding:6px 0px 6px 0px; margin-left: 5px; font-family: \'Noto Sans KR\'">' + mystore + '</div>'
            });
            infowindow.open(map, marker);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);

            // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
            var mapTypeControl = new kakao.maps.MapTypeControl();

            // 지도에 컨트롤을 추가해야 지도위에 표시됩니다
            // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
            map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

            // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
            var zoomControl = new kakao.maps.ZoomControl();
            map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        }


    })

    /*
    * 회원 주소 변환(맵에는 표시하지 않고, 거리 계산 및 길찾기 용도로 사용)
    * */
    // 회원의 주소지를 담은 myaddr 변수로, 주소지를 검색함
    geocoder.addressSearch(useraddr, function addr2(result2, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {

            // 위도, 경도값을 받아와서 저장
            var coords2 = new kakao.maps.LatLng(result2[0].y, result2[0].x);

            // 위도, 경도를 구분하여 거리 계산을 위해 변수 선언
            lat2 = result2[0].y;
            lon2 = result2[0].x;
            $(la2).text(lat2);
            $(lo2).text(lon2);

            console.log("if 회원 coords : " + coords2);
            console.log("if 회원 위도(lat2) : " + lat2);
            console.log("if 회원 경도(lon2) : " + lon2);
            // 결과값으로 받은 위치를 마커로 표시
            /* var marker = new kakao.maps.Marker({
                map: map,
                position: coords2
            }); */
        }
    })


})


$(document).on('load', function(){
    console.log("로드 완료");
    var la1 = document.getElementById("lat1").innerText;
    var lo1 = document.getElementById("lon1").innerText;
    var la2 = document.getElementById("lat2").innerText;
    var lo2 = document.getElementById("lon2").innerText;
    console.log("가져온 위도값 : " + la1);
    console.log(lo1);
    console.log(la2);
    console.log(lo2);
})
