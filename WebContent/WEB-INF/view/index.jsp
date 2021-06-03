<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="include/session.jsp"%>
<html>
<head>
    <title>Around-Sell</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="include/cssFile.jsp"%>
</head>

<body>
    <!-- preloader -->
    <%@ include file="include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

<a href="/test.do">부트스트랩 테스트</a>
<a href="/index.do">메인 페이지</a>
<a href="/signup.do">회원가입</a>
<% if (SS_USER_NO == null) { %> <!--세션이 설정되지 않은 경우(=로그인되지 않은 경우) 로그인 표시-->
<a href="/logIn.do">로그인</a>
<% } else { %> <!--세션이 설정된 경우에는, 이름 + 로그아웃 표시-->
<%=SS_USER_NO%>번 회원 <%=SS_USER_NAME %>님 환영합니다~
<span><%=SS_USER_ADDR2%></span>
<br>
<div id="weather"><%=SS_USER_ADDR2%> 날씨는?</div>
<button class="btn-info" value="내일">내일 날씨</button>
<button class="btn-info" value="모레">모레 날씨</button>
<input type="hidden" id="getAddr2" value="<%=SS_USER_ADDR2%>"/>
<a href="/logOut.do">로그아웃</a>
<% } %>
<a href="/adminPage.do">관리자 페이지</a>
<a href="/userSearch.do">이메일/비밀번호 찾기</a>
<br />
<a href="/noticeForm.do">판매글 등록하기</a>
<a href="/noticeList.do">판매글 리스트(일반)</a>
<br/>
<a href="/searchList.do">페이징+검색 판매글 페이지</a>
<a href="/myPage.do">마이페이지</a>
<a href="/myCart.do">관심상품</a>
<a href="/mySee.do">최근 본 상품</a>
<input type="hidden" id="ss_no" value="<%=SS_USER_NO%>">
<button type="button" onclick="alertTest()">swal 테스트</button>
<!-- 오피니언 마이닝 테스트 -->
    <input type="text" id="text_message" name="text_message" style="width:400px"/>
    <input type="submit" onclick="doNlp()" value="전송" />
    <div id="nlpRes"></div>

<!-- 크롤링 -->
<script type="text/javascript" src="/resource/js/Weather.js?ver=2"></script>

<script type="text/javascript">

    function doNlp() {
        var text_message = document.getElementById("text_message").value;
        console.log("입력한 text값" + text_message);

        $.ajax({
            url : "nlpAnalysis.do",
            type : "post",
            dataType : "text",
            data : {
                "text_message" : text_message
            },
            success: function(res) {
                console.log("res : " + res);
                document.getElementById("nlpRes").innerHTML = res;
                document.getElementById("text_message").value = "";
            }
        })
    }
</script>
<hr>
<div id="chartdiv"></div>
<hr>
<%
    if (SS_USER_NO == null) {
        System.out.println("null user_no");
    } else { %>
<div>최근 본 상품</div>
<div id="keywordList"></div>
<% } %>

<style>
    #chartdiv {
        width: 500px;
        height: 500px;
    }
</style>
<script type="text/javascript">
    function alertTest() {
        swal.fire("<%=SS_USER_ADDR2%>");
    }
</script>

    <!-- include JS File Start -->
    <%@ include file="include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>