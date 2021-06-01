<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.*" %>
<%
    String SS_USER_NO = (String) session.getAttribute("SS_USER_NO");
    String SS_USER_ADDR2 = (String) session.getAttribute("SS_USER_ADDR2"); // 추후 사용, 지역구별 판매글
    List<NoticeDTO> rList = (List<NoticeDTO>) request.getAttribute("rList");

    // 게시판 조회 결과 보여주기(null일 경우 객체 생성)
    if (rList == null) {
        rList = new ArrayList<NoticeDTO>();
    }

%>

<html>
<head>
    <title>판매글 목록</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <%@ include file="/WEB-INF/view/include/charts.jsp"%>
    <script type="text/javascript">
        function doDetail(seq) {
            location.href="${pageContext.request.contextPath}/noticeInfo.do?nSeq=" + seq;
        }
    </script>

    <!-- Resources(amchart 차트, 워드클라우드) -->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>

</head>
<body>
<div class="container">
    <!-- 다중 마커 -->
    <div id="map" style="width: 300px; height:300px;">지도</div>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
    <script>
        // 다중마커 예제, 지도 생성 및 리스트 형태로 지도를 검색하여 마커 찍기
        var mapContainer = document.getElementById('map');
        var mapOption = {
            center: new kakao.maps.LatLng(33.450701, 126.570667),
            level: 7
        };

        var map = new kakao.maps.Map(mapContainer, mapOption);

        var geocoder = new kakao.maps.services.Geocoder();

        // 지역구에 해당하는 판매 주소지의 다중 검색을 위해 listData에 담음
        var listData = [
            <% for(NoticeDTO adr : rList) { %>
            '<%=CmmUtil.nvl(adr.getGoods_addr2())%>',
        <% } %>];

        listData.forEach(function(addr, index) {
            geocoder.addressSearch(addr, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                    // 마커 이미지의 이미지 주소입니다
                    var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

                    // 마커 이미지의 이미지 크기 입니다
                    var imageSize = new kakao.maps.Size(24, 35);

                    // 마커 이미지를 생성합니다
                    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

                    var marker = new kakao.maps.Marker({
                        map: map,
                        position: coords,
                        image : markerImage //마커 이미지
                    });

                    var iwRemoveable = true;

                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="width:150px;text-align:center;padding:6px 0;">' + listData[index] + '<button class="btn btn-info" id="btn">검색</button></div>',
                        disableAutoPan: true,
                        removable : iwRemoveable
                    });

                    /*infowindow.open(map, marker);*/

                    // 마커에 클릭이벤트를 등록합니다
                    kakao.maps.event.addListener(marker, 'click', function() {
                        // 마커 위에 인포윈도우를 표시합니다
                        infowindow.open(map, marker);
                        $("#btn").on("click", function() {
                            location.href="/searchList.do?nowPage=1&cntPerPage=9&searchType=J&keyword=" + listData[index];
                        })
                    });

                    /*kakao.maps.event.addListener(infowindow, 'click', function() {
                        // 클릭한 주소로 판매글 검색을 진행
                        location.href = "/searchList.do?nowPage=1&cntPerPage=9&searchType=J&keyword=" + listData[index];
                    }) */

                    map.setCenter(coords);
                }
            });
        });
    </script>

    <!-- 워드클라우드 HTML -->
    <div id="chartdiv"></div>

    <!-- 동적 파이차트 HTML -->
    <div id="chartdiv2"></div>
    <hr/>

    <!-- 일반 파이차트 HTML(고민중) -->
    <div id="chartdiv3"></div>
    <hr/>

    <!-- 이미지 넣은 차트(고민중) -->
    <div id="chartdiv4"></div>
    <hr/>

    <!-- 판매글 리스트 불러오기(로그인/비 로그인 여부 나뉨) -->
    <div class="row">
    <%
        for(int i=0; i<rList.size(); i++) {
            NoticeDTO rDTO = rList.get(i);

            if (rDTO == null) {
                rDTO = new NoticeDTO();
            }
    %>
            <div class="col">
                <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                    <img src="${pageContext.request.contextPath}/resource/images/<%=rDTO.getImgs()%>" style="width:150px; height:200px; object-fit:contain" alt="이미지 불러오기 실패"></a>
            </div>

            <div class="col">
                <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                <%=CmmUtil.nvl(rDTO.getGoods_title())%></a>
            </div>
            <div class="col">
                <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                    <%=CmmUtil.nvl(rDTO.getGoods_addr())%></a>
            </div>
            <div class="col">
                <%=CmmUtil.nvl(rDTO.getGoods_price())%>
            </div>
    <% } %>
    </div>
        <button class="btn btn-info" type="button" onclick="location.href='${pageContext.request.contextPath}/noticeForm.do'">글쓰기</button>
        <a href="/index.do">홈으로</a>
        <a href="javascript:history.back()">뒤로가기</a>
        <hr/>
</div>
</div>

<!--<style>
    #map {
        width: 350px;
        height: 200px;
        margin-top: 10px;
        /*display: none */
    }
</style> -->
<!-- bootstrap, css 파일 -->
<!--<link rel="stylesheet" href="/resource/css/notice.css?ver=1"/>-->

<!-- 판매글 등록 시, 유효성 체크 js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resource/valid/noticeCheck.js"></script>
</body>
</html>