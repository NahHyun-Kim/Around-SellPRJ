<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
%>

<html>
<head>
    <title>판매글 목록</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        function doDetail(seq) {
            location.href="/noticeInfo.do?nSeq=" + seq;
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
            $.ajax({
                url : "/titleCount.do",
                type : "post",
                success(data) {
                    alert("받아오기 성공!");
                    console.log(data);
                }
            })
        })
        am4core.ready(function() {

            var titleArr = new Array();

            <% for (int i=0; i<titleList.size(); i++) { %>
            var title = "<%=titleList.get(i)%>";
            titleArr.push(title);
            console.log("push된 배열값 : " + "<%=titleList.get(i).trim()%>");
            <%}%>

            var data = "";
            //총합 구현 예정
            var cnt = 1;

            for (var i=0; i<titleArr.length; i++) {
                console.log("push된 값 : " + titleArr[i]);
                data = data + " " + titleArr[i];
                console.log("추가된 data 값 : " + data);
            }

            // Themes begin
            am4core.useTheme(am4themes_material);
            am4core.useTheme(am4themes_animated);
            // Themes end

            var chart = am4core.create("chartdiv", am4plugins_wordCloud.WordCloud);
            var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());

            series.accuracy = 4;
            series.step = 15;
            series.rotationThreshold = 0.7;
            series.maxCount = 200;
            series.minWordLength = 2;
            series.labels.template.margin(4,4,4,4);
            series.maxFontSize = am4core.percent(30);

            // 단어를 클릭하면 이동할 url 지정(검색 페이지로 이동)
            series.labels.template.url = "http://localhost:8081/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword=" + "틴트";
            series.labels.template.urlTarget = "_blank";

            series.text = data;
            console.log("데이터(워드클라우드 예정 : " + data);

            series.colors = new am4core.ColorSet();
            series.colors.passOptions = {}; // makes it loop

            //series.labelsContainer.rotation = 45;
            series.angles = [0,-90];
            series.fontWeight = "700"

            //워드 클라우드 제목 지정
            var title = chart.titles.create();
            title.text = "Our Product!";
            title.fontSize = 20;
            title.fontWeight = "800";

            setInterval(function () {
                series.dataItems.getIndex(Math.round(Math.random() * (series.dataItems.length - 1))).setValue("value", Math.round(Math.random() * 10));
            }, 10000)

        }); // end am4core.ready()
    </script>

</head>
<body>
<div class="container">
    <!-- 워드클라우드 HTML -->
    <div id="chartdiv"></div>
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
                    <img src="/resource/images/<%=rDTO.getImgs()%>" style="width:150px; height:200px; object-fit:contain" alt="이미지 불러오기 실패"></a>
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
        <button class="btn btn-info" type="button" onclick="location.href='/noticeForm.do'">글쓰기</button>
        <a href="/index.do">홈으로</a>
        <a href="javascript:history.back()">뒤로가기</a>
        <hr/>
</div>
</div>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

<!-- 판매글 등록 시, 유효성 체크 js -->
<script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>

</body>
</html>
