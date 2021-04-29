
    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
    mapOption = {
    center: new daum.maps.LatLng(37.537187, 127.005476), // 지도의 중심좌표
    level: 3 // 지도의 확대 레벨, 숫자가 작을수록 확대하여 보여준다.
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

            // 주소 검색 팝업 띄울 시, 영문 링크명 지정
            popupName: 'postcodePopup';

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
        },
        // 주소 검색 테마 색상 지정하여 변경
        theme: {
            bgColor: "#FDE2FC", //바탕 배경색
            searchBgColor: "#D7BAD9", //검색창 배경색
            //contentBgColor: "", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
            pageBgColor: "#F9D2FC", //페이지 배경색
            //textColor: "", //기본 글자색
            queryTextColor: "#FFFFFF" //검색창 글자색
            //postcodeTextColor: "", //우편번호 글자색
            //emphTextColor: "", //강조 글자색
            //outlineColor: "", //테두리
        },


    }).open();
}
