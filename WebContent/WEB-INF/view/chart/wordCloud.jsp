<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<html>
<head>
    <title>워드 클라우드</title>

    <!-- 영어용 폰트
    font-family: 'Roboto Mono', monospace; -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poor+Story&family=Roboto+Mono:ital,wght@0,600;1,500&display=swap" rel="stylesheet">

    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>

    <!-- Resources(amchart 차트, 워드클라우드) Start-->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
    <!-- Resources(amchart 차트, 워드클라우드) End-->

    <script type="text/javascript">
        // 워드 클라우드 로직 시작(ajax)
        $(document).ready(function () {
            console.log("준비 됐나?");
            $.ajax({
                url: "/titleCount.do",
                async: false,
                type: "post",
//서버에서 전송받을 데이터 형식 JSON 으로 받아야함
                dataType: "JSON",
                success(res) {
                    console.log("받아오기 성공!" + res);
// Themes begin
                    am4core.useTheme(am4themes_animated);


                    var chart = am4core.create("chartdiv", am4plugins_wordCloud.WordCloud);

                    // 폰트, 글자 굵기 변경경
                   chart.fontFamily = 'Poor Story';
                    chart.fontWeight = 600;
                    var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());
                    series.randomness = 0.1;
                    series.rotationThreshold = 0.5;

                    series.data = res;

//단어(word)는 collection 배열 값 안에 있는 "tag" 값
//빈도수(value)는 collection 배열 값 안에 있는 "count" 값
                    series.dataFields.word = "tag";
                    series.dataFields.value = "count";

                    series.heatRules.push({
                        "target": series.labels.template,
                        "property": "fill",
                        "min" : am4core.color("#d0a7e4"),
                        "max": am4core.color("purple"),
                        // "min": am4core.color("#0000CC"),
                        // "max": am4core.color("#CC00CC"),
                        "dataField": "value"
                    });

// 단어를 클릭 시, 해당 단어에 해당하는 단어로 검색 진행(get)
                    series.labels.template.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword={word}";
                    series.labels.template.urlTarget = "_blank";

// 단어에 마우스를 올릴 때, 단어:빈도수 형태로 표시해줌
                    series.labels.template.tooltipText = "{word}:\n[bold]{value}[/]";

                    var subtitle = chart.titles.create();
                    subtitle.text = "(click to search your product!)";

                    var title = chart.titles.create();
                    title.text = "WordCloud";
                    title.fontSize = 80;
                    title.fontWeight = "500";
                    title.style = "text-align: center";

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                    console.log(errorThrown);
                }
            })
        })
    </script>
</head>
<body>
<!-- preloader -->
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->
<main>

<%--    <!-- 상품 목록 일부 보여주기(index) 시작 -->--%>
<%--    <div class="popular-items section-padding30">--%>
<%--        <!-- container 시작 -->--%>
<%--        <div class="container">--%>

<%--            <!-- 워드 클라우드, 로고 표시 -->--%>
<%--            <div class="row justify-content-center">--%>
<%--                <div class="room-btn pt-70" style="padding-top: 5px;">--%>
<%--                    <h2 style="font-family: 'Poor Story'">CATEGORY</h2>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Section tittle2 (New 아이템 표시!) -->--%>
<%--            <div class="row justify-content-center">--%>
<%--                <div class="col-xl-7 col-lg-8 col-md-10">--%>
<%--                    <div class="section-tittle mb-70 text-center" >--%>

<%--                        <hr />--%>
<%--&lt;%&ndash;                        <img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""&ndash;%&gt;--%>
<%--&lt;%&ndash;                                 style="width:300px;height: 75px;">&ndash;%&gt;--%>



<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <!-- Button -->--%>
<%--            <div class="row justify-content-center">--%>
<%--                <div class="room-btn pt-70" style="padding-top: 5px;">--%>

<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- 상품 목록 일부 보여주기(index) 끝 -->--%>

<%--</main>--%>

<!-- 워드 클라우드 -->
<div id="chartdiv"></div>

<style>
    /* 워드 클라우드 */
    #chartdiv {
        margin: 80px auto 0px auto;
    }


</style>

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>

</body>
</html>
