 $(document).ready(function() {
    //페이지가 로드된 후, 크롤링을 실행하여 결과값을 가져옴
     // 값을 가져올 때 .val()로는 가져오지 못함, value;를 사용해서 가져오기 성공
     var user_no = document.getElementById("ss_no").value;
     console.log("user_no(value) : " + user_no);
     // 로그인 되지 않은 상태에서 불필요한 크롤링이 되는 것을 방지하기 위해, 로그인 한 경우에만 크롤링 진행
     // null값이면 크롤링이 진행되지 않음(null로 입력하면 인식이 안되어, 문자열 null로 입력)
     if (user_no != "null") {
    crawling();
     }
})
    function crawling() {
    console.log('페이지 로딩 후, ajax 호출 시작');
    console.log("addr2 : " + $("#getAddr2").val())
    // ajax 호출
    $.ajax({
    url : "/getWeather.do",
    type : "post",
    data : { //요청 시 포함되어질 데이터
    "addr2" : $("#getAddr2").val()
},
    dataType : "JSON", //응답 데이터 형식
    contentType : "application/json; charset=UTF-8", //요청하는 컨텐트 타입
    success : function(result) {

    console.log(result);
    var resweather = "";
    resweather += result.temperature + "도 ";
    resweather += result.weather + '<img src="' + result.imgs + '" alt="이미지 불러오기 실패" style="width:45px"/>' + "이며, 강수 확률은 ";
    resweather += result.rainrate + " 입니다.";

    //resweather += <img src={result.imgs} alt="이미지 불러오기 실패"/>;
    $('#weather').html(resweather);
}

})
}

 // 다음 날짜들의 날씨를 가져오기 위한 함수
 // target 프로퍼티는 this와 같은 역할을 하며, 클릭한 값을 받아옴
 $('.btn-info').on('click', (e) => {
     var day = e.target.value;
     var addr2 = $("#getAddr2").val();
     console.log("넘겨줄 날짜 정보 : " + day);
     console.log("넘겨줄 주소 정보 : " + addr2);

     // controller에서 @RequestParam String 값으로 받기 위해, 문자열 형태로 선언한다.
     // 보낼 "name값="+선언한 name의 value값+'&또다른 name값='+선언한 또다른 name의 value값; 형태
     var sendData = "addr2="+addr2+'&day='+day;
     console.log('String 형태로 담은 데이터 파라미터 : ' + sendData);

     // 사용자 주소와 날짜 값을 name/value 형태로 담는다.
     // var allData = {"addr2" : $("#getAddr2").val(), "when" : day};

     // ajax 호출
     $.ajax({
         url : "/getNext.do",
         type : "post",
         data : sendData,
         dataType : "JSON", //응답 데이터 형식
         success : function(res) {

             console.log(res);
             var resweather = "";
             resweather += res.temperature + "도 ";
             resweather += res.weather + '<img src="' + res.imgs + '" alt="이미지 불러오기 실패" style="width:45px"/>' + "이며, 강수 확률은 ";
             resweather += res.rainrate + " 입니다.";
             $('#weather').html(resweather);

             console.log("이미지 주소 : " + res.imgs);
             console.log("resweather : " + resweather);
 },
         //"<img src=\"" + res.imgs + "alt=\"이미지 불러오기 실패\"/>";
         error:function(jqXHR, textStatus, errorThrown) {
             alert("에러 발생! \n" + textStatus + ":" + errorThrown);
             console.log(errorThrown);
         }
     })
 })
