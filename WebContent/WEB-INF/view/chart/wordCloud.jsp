<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<html>
<head>
    <title>워드 클라우드</title>

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
            tagWordCloud();
        })

        function tagWordCloud() {
            $("#chartdivColor").hide();
            $("#getNext").show();
            $("#getOrigin").hide();

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
                    series.rotationThreshold = 1.0;

                    series.data = res;

//단어(word)는 collection 배열 값 안에 있는 "tag" 값
//빈도수(value)는 collection 배열 값 안에 있는 "count" 값
                    series.dataFields.word = "tag";
                    series.dataFields.value = "count";

                    series.heatRules.push({
                        "target": series.labels.template,
                        "property": "fill",
                        // "min" : am4core.color("skyblue"),
                        "min" : am4core.color("#E4A0E9"),
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

            $("#chartdiv").show();
        }

        function nextWordCloud() {
            $("#chartdiv").hide();
            $("#getNext").hide();
            $("#getOrigin").show();

            $.ajax({
                url: "/titleAll.do",
                type: "post",
//서버에서 전송받을 데이터 형식 JSON 으로 받아야함
                dataType: "text",
                success(res) {
                    console.log("타이틀 : " + res);
// Themes begin
                    am4core.useTheme(am4themes_animated);
// Themes end

                    var chart = am4core.create("chartdivColor", am4plugins_wordCloud.WordCloud);
                    var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());

                    series.accuracy = 4;
                    series.step = 15;
                    series.rotationThreshold = 0.7;
                    series.maxCount = 200;
                    series.minWordLength = 2;
                    series.labels.template.margin(4, 4, 4, 4);
                    series.maxFontSize = am4core.percent(30);

                    series.text = res;

                    series.fontFamily = 'Poor Story';
                    series.randomness = 0;
                    series.colors = new am4core.ColorSet();
                    series.colors.passOptions = {}; // makes it loop

//series.labelsContainer.rotation = 45;
                    series.angles = [0, -90];
                    series.fontWeight = "700"

                    var subtitle = chart.titles.create();
                    subtitle.text = "(빈도수가 포함되지 않은 워드클라우드)";

                    var title = chart.titles.create();

                    chart.fontFamily = 'Poor Story';
                    chart.fontWeight = 600;

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

            $("#chartdivColor").show();
        }
    </script>
</head>
<body>
<!-- preloader -->
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->
<a id="getNext" class="btn view-btn3 font wordCenter" href="javascript:nextWordCloud()" >디자인 변경!</a>
<a id="getOrigin" class="btn view-btn3 font wordCenter" href="javascript:tagWordCloud()">디자인 변경!</a>

<main>

<!-- 워드 클라우드 -->
<div id="chartdiv"></div>
<div id="chartdivColor"></div>

<style>
    /* 워드 클라우드 */
    #chartdiv {
        margin: 80px auto 0px auto;
    }

    #chartdivColor {
        margin: 80px auto 0px auto;
    }

    .wordCenter {
        display: block;
        width: 10%;
        margin: 50px auto 0 auto;
        background-image: url('../../../resources/boot/img/hero/background-purple.jpeg');
    }

    .wordCenter:hover {
        color: #FAF8FA;
    }

</style>

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>

</body>
</html>
