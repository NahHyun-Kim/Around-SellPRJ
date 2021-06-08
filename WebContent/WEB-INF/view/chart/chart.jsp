<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<html>
<head>
    <title>인기 차트</title>

    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poor+Story&family=Roboto+Mono:ital,wght@0,600;1,500&display=swap" rel="stylesheet">

    <!-- Resources(amchart 차트, 워드클라우드) Start-->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
    <!-- Resources(amchart 차트, 워드클라우드) End-->

    <script type="text/javascript">
        $(document).ready(function() {
            /**
             * 일반 원형태 파이차트
             * */
            //Themes begin(piechart)
            $.ajax({
                url : "/cateCount.do",
                async : false,
                type : "post",
                //서버에서 전송받을 데이터 형식 JSON 으로 받아야함
                dataType: "JSON",
                success(res) {
                    console.log("파이차트 res : " + res);
                    console.log("파이차트 res 받아온 타입 : " + typeof res);

                    am4core.useTheme(am4themes_animated);

                    // Create chart instance
                    var chart = am4core.create("chartdiv3", am4charts.PieChart);

                    chart.fontFamily = 'Poor Story';
                    // Add data
                    chart.data = res;

                    // Add and configure Series
                    var pieSeries = chart.series.push(new am4charts.PieSeries());
                    pieSeries.dataFields.value = "cnt";
                    pieSeries.dataFields.category = "category";
                    pieSeries.slices.template.stroke = am4core.color("#fff");
                    pieSeries.slices.template.strokeOpacity = 1;

                    /**
                     *카테고리를 클릭 시, 해당 카테고리에 해당하는 판매글 목록을 가져온다.
                     */
                    pieSeries.slices.template.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=G&keyword={category}";
                    // _blank 옵션을 통해 새 탭으로 결과 검색창을 보여줌(추후 활성화 시키려면 활성화 풀자!)
                    // pieSeries.slices.template.urlTarget = "_blank";

                    // This creates initial animation
                    pieSeries.hiddenState.properties.opacity = 1;
                    pieSeries.hiddenState.properties.endAngle = -90;
                    pieSeries.hiddenState.properties.startAngle = -90;

                    chart.hiddenState.properties.radius = am4core.percent(0);


                }
            })


            // 이미지+조회수 인기순으로 보여주기
            $.ajax({
                url : "hitProduct.do",
                type: "post",
                dataType: "JSON",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                data : {
                    "category" : "none"
                },
                success: function(result) {
                    console.log("받아온 rList : " + result);

                    //var jsdata = JSON.parse(result);
                    var dataList = [];

                    // rList에서 받아온 데이터를 json 형태로 만들어줌
                    for (var i=0; i<result.length; i++) {
                        var data = {};
                        data.name = result[i].goods_title;
                        data.steps = result[i].hit;
                        data.href = "${pageContext.request.contextPath}/resource/images/" + result[i].imgs;
                        data.goods_no = result[i].goods_no;
                        dataList.push(data);

                        console.log("{} 형태의 data : " + data);
                        console.log("data중에 이미지주소 : " + data.href);
                    }

                    console.log("push 한 dataList[] 형태 : " + dataList);

                    // Themes begin
                    am4core.useTheme(am4themes_animated);
                    // Themes end

                    /**
                     * Chart design taken from Samsung health app
                     */

                    var chart = am4core.create("chartdiv4", am4charts.XYChart);
                    chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

                    chart.paddingBottom = 30;

                    chart.fontFamily = 'Poor Story';
                    chart.data = dataList;

                    var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
                    categoryAxis.dataFields.category = "name";
                    categoryAxis.renderer.grid.template.strokeOpacity = 0;
                    categoryAxis.renderer.minGridDistance = 10;
                    categoryAxis.renderer.labels.template.dy = 35;
                    categoryAxis.renderer.tooltip.dy = 35;

                    var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
                    valueAxis.renderer.inside = true;
                    valueAxis.renderer.labels.template.fillOpacity = 0.3;
                    valueAxis.renderer.grid.template.strokeOpacity = 0;
                    valueAxis.min = 0;
                    valueAxis.cursorTooltipEnabled = false;
                    valueAxis.renderer.baseGrid.strokeOpacity = 0;

                    var series = chart.series.push(new am4charts.ColumnSeries);
                    series.dataFields.valueY = "steps";
                    series.dataFields.categoryX = "name";
                    series.tooltipText = "{valueY.value}";
                    series.tooltip.pointerOrientation = "vertical";
                    series.tooltip.dy = - 6;
                    series.columnsContainer.zIndex = 100;

                    // 단어를 클릭 시, 해당 단어에 해당하는 단어로 검색 진행(get)
                    series.tooltipText.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword={name}";
                    series.tooltipText.urlTarget = "_blank";

                    var columnTemplate = series.columns.template;
                    columnTemplate.width = am4core.percent(50);
                    columnTemplate.maxWidth = 66;
                    columnTemplate.column.cornerRadius(60, 60, 10, 10);
                    columnTemplate.strokeOpacity = 0;

                    series.heatRules.push({ target: columnTemplate, property: "fill", dataField: "valueY", min: am4core.color("#e5dc36"), max: am4core.color("#5faa46") });
                    series.mainContainer.mask = undefined;

                    var cursor = new am4charts.XYCursor();
                    chart.cursor = cursor;
                    cursor.lineX.disabled = true;
                    cursor.lineY.disabled = true;
                    cursor.behavior = "none";

                    var bullet = columnTemplate.createChild(am4charts.CircleBullet);
                    bullet.circle.radius = 30;
                    bullet.valign = "bottom";
                    bullet.align = "center";
                    bullet.isMeasured = true;
                    bullet.mouseEnabled = false;
                    bullet.verticalCenter = "bottom";
                    bullet.interactionsEnabled = false;

                    var hoverState = bullet.states.create("hover");
                    var outlineCircle = bullet.createChild(am4core.Circle);
                    outlineCircle.adapter.add("radius", function (radius, target) {
                        var circleBullet = target.parent;
                        return circleBullet.circle.pixelRadius + 10;
                    })

                    var image = bullet.createChild(am4core.Image);
                    image.width = 60;
                    image.height = 60;
                    image.horizontalCenter = "middle";
                    image.verticalCenter = "middle";
                    image.propertyFields.href = "href";

                    image.adapter.add("mask", function (mask, target) {
                        var circleBullet = target.parent;
                        return circleBullet.circle;
                    })

                    var previousBullet;
                    chart.cursor.events.on("cursorpositionchanged", function (event) {
                        var dataItem = series.tooltipDataItem;

                        if (dataItem.column) {
                            var bullet = dataItem.column.children.getIndex(1);

                            if (previousBullet && previousBullet != bullet) {
                                previousBullet.isHover = false;
                            }

                            if (previousBullet != bullet) {

                                var hs = bullet.states.getKey("hover");
                                hs.properties.dy = -bullet.parent.pixelHeight + 30;
                                bullet.isHover = true;

                                previousBullet = bullet;
                            }
                        }
                    })

                    chart.events.on("click", function () {
                        console.log("clicked!");
                        location.href = "/searchList.do";
                    })
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

<!-- include chart -->

<!-- index -->

<main>

    <!-- 상품 목록 일부 보여주기(index) 시작 -->
    <div class="popular-items section-padding30">
        <!-- container 시작 -->
        <div class="container">

            <!-- Button -->
            <div class="row justify-content-center">
                <div class="room-btn pt-70" style="padding-top: 5px;">
                    <h2>HITS</h2>
                </div>
            </div>

            <!-- Section tittle2 (New 아이템 표시!) -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">
                    <div class="section-tittle mb-70 text-center" >

                        <!-- 이미지+막대바 -->
                        <div id="chartdiv4"></div>

                    </div>
                </div>
            </div>

            <!-- Button -->
            <div class="row justify-content-center">
                <div class="room-btn pt-70" style="padding-top: 5px;">
                    <hr />
                    <h2>CATEGORY</h2>
                </div>
            </div>

            <!-- Section tittle2 (New 아이템 표시!) -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">
                    <div class="section-tittle mb-70 text-center" >


                        <!-- 파이차트 -->
                        <div id="chartdiv3"></div>
                    </div>
                </div>
            </div>

            <!-- Button -->
            <div class="row justify-content-center">
                <div class="room-btn pt-70" style="padding-top: 5px;">

                </div>
            </div>
        </div>
    </div>
    <!-- 상품 목록 일부 보여주기(index) 끝 -->

</main>

<style>
    /* 파이차트 */
    #chartdiv3 {
        width: 500px;
        height: 500px;
        margin: 0 auto;
    }

    /* 이미지 들어간 차트 */
    #chartdiv4 {
        width: 600px;
        height: 500px;
        margin: 0 auto;
    }

    h2 {
        font-family: 'Poor Story';
        font-weight: 600;
    }
</style>
<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>

</body>
</html>
