<%@ page import="poly.dto.NoticeDTO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    NoticeDTO rDTO = (NoticeDTO) request.getAttribute("rDTO");
    String SS_USER_NO = (String) session.getAttribute("SS_USER_NO");

    if (rDTO == null) {
        rDTO = new NoticeDTO();
    }

    int access = 1; // 본인 : 2, 타 사용자 : 1

    if (SS_USER_NO.equals(rDTO.getUser_no())) {
        access = 2; // 본인이면, 수정이 가능하도록 설정
    }
%>
<html>
<head>
    <title>판매글 수정</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        // 작성자 본인 여부 체크
        function doOnload() {
            // 본인이 아닌, 타 사용자가 접근했다면
            if ("<%=access%>" == "1") {
                alert("작성자만 수정할 수 있습니다.");
                location.href="/noticeList.do";
            }
        }
    </script>
</head>
<body onload="doOnload()">

<div class="container">
    <!-- 판매글 수정 폼 -->
    <form action="/noticeUpdate.do" method="post" onsubmit="return doSubmit();" enctype="multipart/form-data">

        <!-- 업데이트할 판매글 번호 받아오기 -->
        <input type="hidden" name="nSeq" value="<%=rDTO.getGoods_no()%>"/>

        <!-- 이미지 -->
        <!-- 상품명 등록(추후 제목으로 표시된다) -->
        <div class="form-control" style="height: 200px;">
            <label for="img">상품 사진 등록</label>
            <input type="file" id="img" name="fileUpload" value="/resource/images/<%=rDTO.getImgs()%>"/>
            <div class="select_img"><img src="/resource/images/<%=rDTO.getImgs()%>" width="100"/></div>
        </div>

        <!-- 수정할 파일을 첨부하면, 판매글 작성 화면에서 이미지인지 보여줌 -->
        <script>
            $("#img").change(function() {
                if(this.files && this.files[0]) {
                    var reader = new FileReader;
                    reader.onload = function(data) {
                        $(".select_img img").attr("src",data.target.result).width(100);
                    }
                    reader.readAsDataURL(this.files[0]);
                }
            });
        </script>
        <%=request.getRealPath("/")%>

        <!-- 상품명 등록(추후 제목으로 표시된다) -->
        <div class="form-control">
            <label for="goods_title">상품명</label>
            <input type="text" name="goods_title" id="goods_title" value="<%=rDTO.getGoods_title()%>"/>
        </div>

        <!-- 상품 설명(추후 게시글 내용으로 표시된다) -->
        <div class="form-control">
            <label for="goods_detail">상품 설명</label>
            <input type="textarea" name="goods_detail" id="goods_detail" value="<%=rDTO.getGoods_detail()%>"/>
        </div>

        <!-- 상품 가격 -->
        <div class="form-control">
            <label for="goods_price">상품 가격</label>
            <input type="text" name="goods_price" id="goods_price" value="<%=rDTO.getGoods_price()%>"/>
        </div>

        <!-- 상품이 판매되는 상호명 또는 간략한 주소 입력(간략 ex) 아리따움 강서구청점) -->
        <div class="form-control">
            <label for="goods_addr">판매 상호명</label>
            <input type="text" name="goods_addr" id="goods_addr" placeholder="판매하는 상호명을 입력해 주세요." value="<%=rDTO.getGoods_addr()%>"/>
        </div>

        <!-- 상품이 판매되는 상세 주소 입력(도로명주소 api 사용, 실시간으로 위치 확인이 가능하다.) -->
        <div class="form-group">
            <label for="sample5_address">주소 입력</label>
            <input type="text" name="goods_addr2" id="sample5_address" placeholder="주소를 검색해 주세요" value="<%=rDTO.getGoods_addr2()%>"/>
            <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>

        </div>
        <div id="map"></div>

        <!-- 등록되는 상품의 카테고리를 지정 -->
        <div class="form-group">
            <label for="category">카테고리</label>
            <input type="text" name="category" id="category" placeholder="카테고리를 지정해 주세요." value="<%=rDTO.getCategory()%>"/>
        </div>

        <input type="submit" value="수정하기" />
        <input type="reset" value="다시 작성하기" />
        <a href="javascript:history.back();">뒤로가기</a>

    </form>
</div>

    <!-- 위도, 경도값 표시 -->
    <input type="hidden" name="longY" id="longY" value=""/>
    <input type="hidden" name="latX" id="latX" value=""/>

    <!-- 도로명주소 API js 파일-->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
    <script type="text/javascript" src="/resource/js/addrAPI2.js?ver=1"></script>

    <!-- bootstrap, css 파일 -->
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>
</body>
</html>
