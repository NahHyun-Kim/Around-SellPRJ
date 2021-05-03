<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String SS_USER_NO = ((String) session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = ((String) session.getAttribute("SS_USER_NAME"));
    String SS_USER_ADDR2 = ((String) session.getAttribute("SS_USER_ADDR2"));
%>
<html>
<head>
    <title>Title</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            //페이지가 로드된 후, 크롤링을 실행하여 결과값을 가져옴
            crawling();
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
                    resweather += result.weather;

                    $('#weather').html(resweather);
                }

            })
        }
    </script>
    </head>
<body>
    <a href="/getWeather.do">날씨 크롤링 결과</a>
    <%=SS_USER_ADDR2%> 거주중인
    <%=SS_USER_NO%>번 회원 <%=SS_USER_NAME%>님!
    <br/>
    <a href="/index.do">홈으로 이동</a>
    <a href="/logOut.do">로그아웃</a>
    <a href="/adminPage.do">관리자 페이지</a>
    <br/>
    <hr/>
    <div id="weather"><%=SS_USER_ADDR2%> 날씨는?</div>
    <input type="hidden" id="getAddr2" value="<%=SS_USER_ADDR2%>"/>
</body>
</html>
