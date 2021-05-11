<%@ page import="poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String SS_USER_NO = CmmUtil.nvl((String)session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = CmmUtil.nvl((String)session.getAttribute("SS_USER_NAME"));
%>
<html>
<head>
    <title>판매글 등록</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
    function doOnload() {

    // 로그인여부를 체크하여, 세션이 존재하지 않으면 로그인으로 이동
    var user_no = "<%=SS_USER_NO%>";

    if (user_no == "") {
        alert("로그인 후 이용해 주세요.");
        top.location.href = "/logIn.do";
    }
    }
</script>
</head>
<!-- body가 실행될 때, 로그인 여부를 실행하기 위해 onLoad() 함수 호출 -->
<body onload="doOnload();">
    <div class="container">
    <!-- 판매글 등록 폼 -->
    <form action="/noticeInsert.do" method="post" onsubmit="return doSubmit();">

        <!-- 상품명 등록(추후 제목으로 표시된다) -->
        <div class="form-control">
            <label for="goods_title">상품명</label>
            <input type="text" name="goods_title" id="goods_title" />
        </div>

        <!-- 상품 설명(추후 게시글 내용으로 표시된다) -->
        <div class="form-control">
            <label for="goods_detail">상품 설명</label>
            <input type="textarea" name="goods_detail" id="goods_detail" />
        </div>

        <!-- 상품 가격 -->
        <div class="form-control">
            <label for="goods_price">상품 가격</label>
            <input type="text" name="goods_price" id="goods_price" />
        </div>

        <!-- 상품이 판매되는 상호명 또는 간략한 주소 입력(간략 ex) 아리따움 강서구청점) -->
        <div class="form-control">
            <label for="goods_addr">판매 상호명</label>
            <input type="text" name="goods_addr" id="goods_addr" placeholder="판매하는 상호명을 입력해 주세요." />
        </div>

        <!-- 상품이 판매되는 상세 주소 입력(도로명주소 api 사용, 실시간으로 위치 확인이 가능하다.) -->
        <div class="form-group">
            <label for="sample5_address">주소 입력</label>
            <input type="text" name="goods_addr2" id="sample5_address" placeholder="주소를 검색해 주세요" />
            <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>

        </div>
        <div id="map"></div>

        <!-- 등록되는 상품의 카테고리를 지정 -->
        <div class="form-group">
            <label for="category">카테고리</label>
            <input type="text" name="category" id="category" placeholder="카테고리를 지정해 주세요."/>
        </div>

        <input type="submit" value="등록하기" />
        <input type="reset" value="다시 작성하기" />
        <a href="javascript:history.back();">뒤로가기</a>

    </form>
    </div>
    <!-- 도로명주소 API js 파일-->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
    <script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

    <!-- bootstrap, css 파일 -->
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>
</body>
</html>
