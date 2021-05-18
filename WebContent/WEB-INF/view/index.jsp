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
<a href="/crawlingRes.do">크롤링 테스트</a>
<a href="/getUserInfo.do">마이페이지 정보 보기</a>
<a href="/userSearch.do">이메일/비밀번호 찾기</a>
<br />
<a href="/noticeForm.do">판매글 등록하기</a>
<a href="/noticeList.do">판매글 리스트</a>
<a href="/myPage.do">마이페이지</a>
<input type="hidden" id="ss_no" value="<%=SS_USER_NO%>">
<!-- 크롤링 -->
<script type="text/javascript" src="/resource/js/Weather.js?ver=1"></script>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>