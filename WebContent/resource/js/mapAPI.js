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
    var myaddr = document.getElementById("goods_addr2").innerHTML;
    console.log("가져온 주소값 : " + myaddr);

    // 판매 주소지를 담은 myaddr 변수로, 주소지를 검색함
    geocoder.addressSearch(myaddr, function(result, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {

            // 위도, 경도값을 받아와서 저장
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            // 결과값으로 받은 위치를 마커로 표시
            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            // 인포윈도우로 장소에 대한 설명 표시(상호명 - goods_addr 를 받아와 저장)
            var mystore = document.getElementById("goods_addr").innerHTML;
            console.log("가져온 상호명 : " + mystore);

            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">' + mystore + '</div>'
            });
            infowindow.open(map, marker);

            // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
            map.setCenter(coords);
        }
    })
})