<%@ page import="poly.util.CmmUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    //Controller에 저장된 세션으로 로그인할 때 생성됨
    String SS_USER_NO = ((String) session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = ((String) session.getAttribute("SS_USER_NAME"));
    String SS_USER_ADDR2 = ((String) session.getAttribute("SS_USER_ADDR2"));
    System.out.println(SS_USER_NO);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Around-Sell</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
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
<!-- 크롤링 -->
<script type="text/javascript" src="/resource/js/Weather.js?ver=2"></script>

<script type="text/javascript">
    // 페이지가 로딩될 때, 최근 본 상품을 불러옴(추후 mainPage에 로그인시 띄울까 고민중)
    $(document).ready(function() {
        // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근 본 상품 불러오기 진행
        var userno = <%=SS_USER_NO%>;
        console.log("받아온 회원번호 : " + userno);

        if (userno != null) {

            $.ajax({
                url: "/getGoods.do",
                type: "post",
                dataType: "JSON",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                success: function(data) {

                    var data = data;

                    // 검색어 값들을 for문을 통해 저장
                    console.log("가져오기 성공!");
                    console.log(data);
                    console.log("타입 : " + typeof data);

                    // 최근 본 상품부터 불러와야 하기 때문에, 역순으로 리스트를 가져옴
                    let searchList = "";

                    for (let i=data.length-1; i>=0; i--) {
                        // String 형태의 값을 변환함 .으로 접근할 수 있는 JSON 객체로 변환
                        var obj = JSON.parse(data[i]);

                        searchList += obj.goods_no + "<br>";
                        searchList += obj.imgs + "<br>";
                        searchList += obj.goods_title + "<br> <hr>";
                    }
                    console.log("불러오기 성공! searchList : " + searchList);

                    // 검색어 목록에 담음
                    $("#keywordList").html(searchList);
                    $("#keywordList").show();

                }
            })
        }
    })
</script>
<hr>
<%
    if (SS_USER_NO == null) {
        System.out.println("null user_no");
    } else { %>
<div>최근 본 상품</div>
<div id="keywordList"></div>
<% } %>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>