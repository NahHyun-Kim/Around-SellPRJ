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

    String title = "";
    List<String> titleList = new ArrayList<>();

    for (NoticeDTO i : rList) {
        title = i.getGoods_title();
        titleList.add(title);
        System.out.println(title);
    }

    Map<String, String> rMap = new HashMap<>();
    for (NoticeDTO j : rList) {
        rMap.put(j.getGoods_title(), j.getHit());
    }

%>

<html>
<head>
    <title>판매글 목록</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <script type="text/javascript">
        function doDetail(seq) {
            location.href="${pageContext.request.contextPath}/noticeInfo.do?nSeq=" + seq;
        }
    </script>

    <!-- Resources -->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>


    <!-- Chart code -->
    <script>
        $(document).ready(function() {
            console.log("준비 됐나?");
            $.ajax({
                url : "/titleCount.do",
                type : "post",
                //서버에서 전송받을 데이터 형식 JSON 으로 받아야함
                dataType: "JSON",
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                success(res) {
                    console.log("받아오기 성공!");

                    console.log("받아온 데이터(배열형태 - json 해봄) : " + res);

                    // Themes begin
                    am4core.useTheme(am4themes_animated);


                    var chart = am4core.create("chartdiv", am4plugins_wordCloud.WordCloud);
                    chart.fontFamily = "Courier New";
                    var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());
                    series.randomness = 0.1;
                    series.rotationThreshold = 0.5;

                    // 단어를 클릭하면 이동할 url 지정(해당 키워드 검색 페이지로 이동)
                    series.labels.template.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword=" + "틴트";
                    series.labels.template.urlTarget = "_blank";

                    series.data = res;

                    //단어(word)는 collection 배열 값 안에 있는 "tag" 값
                    //빈도수(value)는 collection 배열 값 안에 있는 "count" 값
                    series.dataFields.word = "tag";
                    series.dataFields.value = "count";

                    series.heatRules.push({
                        "target": series.labels.template,
                        "property": "fill",
                        "min": am4core.color("#0000CC"),
                        "max": am4core.color("#CC00CC"),
                        "dataField": "value"
                    });

                    // 단어를 클릭 시, 해당 단어에 해당하는 단어로 검색 진행(get)
                    series.labels.template.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword={word}";
                    series.labels.template.urlTarget = "_blank";

                    // 단어에 마우스를 올릴 때, 단어:빈도수 형태로 표시해줌
                    series.labels.template.tooltipText = "{word}:\n[bold]{value}[/]";

                    var subtitle = chart.titles.create();
                    subtitle.text = "(click to open)";

                    var title = chart.titles.create();
                    title.text = "Our Products!";
                    title.fontSize = 20;
                    title.fontWeight = "100";

                }
            })
        })



        // end am4core.ready()
    </script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>


</head>
<body>
<div class="container">
    <!-- 다중 마커(예정) -->
    <div id="map" style="width: 150px; height:150px;">지도</div>
    <script>
        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
            mapOption = {
                center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
                level: 3 // 지도의 확대 레벨
            };

        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

       // map.setCenter(coords);

        //주소-좌표 변환 객체를 생성합니다
        var geocoder = new kakao.maps.services.Geocoder();

        var test = new Array();

    <% for(NoticeDTO adr : rList) { %>
    geocoder.addressSearch('<%=CmmUtil.nvl(adr.getGoods_addr2())%>', function(result, status) {

        // 정상적으로 검색이 완료됐으면
        if (status === kakao.maps.services.Status.OK) {

            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            console.log(result);

            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            console.log("coords : " + coords);
            test.push(coords);

            // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
            var iwContent = '<div style="padding:5px;"><%=CmmUtil.nvl(adr.getGoods_addr())%></div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
                iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다

            // 인포윈도우를 생성합니다
            var infowindow = new kakao.maps.InfoWindow({
                content : iwContent,
                removable : iwRemoveable
            });

            // 마커에 클릭이벤트를 등록합니다
            kakao.maps.event.addListener(marker, 'click', function() {
                // 마커 위에 인포윈도우를 표시합니다
                infowindow.open(map, marker);
            });
            map.setCenter(coords);


//지도의 중심을 결과값으로 받은 위치로 이동시킵니다

        }


    });

        <% } %>
    console.log("test: " + test);
    </script>
    <!-- 워드클라우드 HTML -->
    <div id="chartdiv"></div>
    <hr/>


    <hr/>

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