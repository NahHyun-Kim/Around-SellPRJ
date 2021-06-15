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

    <link rel="stylesheet" href="/resources/boot/css/nice-select.css"/>
    <!-- Resources(amchart 차트, 워드클라우드) End-->

    <script type="text/javascript">
        $(document).ready(function() {

            // 카테고리별로 인기 차트를 요청하는 경우를 위해 cateChange() 함수 안에 차트 로직 실행
            cateChange();
            /**
             * 일반 원형태 파이차트(semi 원 파이차트로 디자인 수정)
             * */
            $.ajax({
                url: "/cateCount.do",
                async: false,
                type: "post",
                dataType: "JSON",
                success(res) {
                    console.log("파이차트에서 받아온 res(object) : " + res);

                    // amchart 담기 시작
                    // Themes begin
                    am4core.useTheme(am4themes_animated);
                    // Themes end

                    var chart = am4core.create("chartdiv3", am4charts.PieChart);
                    chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

                    // JSONArray 형태로 만든 데이터를 chart에 data로 넣음
                    chart.data = res;

                    // font 수정
                    chart.fontFamily = 'Poor Story';
                    chart.radius = am4core.percent(70);
                    chart.innerRadius = am4core.percent(40);
                    chart.startAngle = 180;
                    chart.endAngle = 360;

                    var series = chart.series.push(new am4charts.PieSeries());
                    series.dataFields.value = "cnt";
                    series.dataFields.category = "country";

                    series.slices.template.cornerRadius = 10;
                    series.slices.template.innerCornerRadius = 7;
                    series.slices.template.draggable = true;
                    series.slices.template.inert = true;

                    // 카테고리를 누르면 해당 카테고리 검색결과로 이동
                    series.slices.template.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=G&keyword={category}";
                    series.slices.template.urlTarget = "_blank";
                    series.alignLabels = false;

                    series.hiddenState.properties.startAngle = 90;
                    series.hiddenState.properties.endAngle = 90;

                    chart.legend = new am4charts.Legend();

                }
            })

        })

        function cateChange(cate) {

            // select 옵션값이 변경되면 카테고리를 가져옴
            // 첫 페이지 로딩 또는 전체 선택 시, undefined로 "none"값을 전달하여 전체 카운트 값을 가져온다.
            var category = cate;

            if (cate == undefined) {
                category = "none";
            }

            // 이미지+조회수 인기순으로 보여주기
            $.ajax({
                url : "hitProduct.do",
                type: "post",
                dataType: "JSON",
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                data : {
                    "category" : category
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

                    // 카테고리별 인기상품 그래프를 클릭했을 때, 해당 카테고리의 인기상품순으로 정렬한 검색결과를 제공한다.
                    // 전체 상품에 대한 정렬은 제공하지 않음(카테고리별 비교를 위한 정렬 제공)
                    if (category != "none") {
                        series.url = "${pageContext.request.contextPath}/searchList.do?nowPage=1&cntPerPage=9&searchType=G&keyword=" + category + "&odType=hit";
                        series.urlTarget = "_blank";
                    }
                    // 전체 카테고리 조회 시에는 일반 상품 검색창으로 이동
                    else {
                        series.url = "${pageContext.request.contextPath}/searchList.do";
                        series.urlTarget = "_blank";
                    }

                    // 카테고리의 게시물이 존재하지 않는 경우 빈 공간만 표시되므로, 텍스트로 없다는 멘트 표시
                    if (result.length == 0) {
                        var title = chart.titles.create();
                        title.text = "해당 카테고리의 인기 게시물이 아직 없습니다!";
                        title.fontSize = 30;
                        title.fontWeight = "bold";
                        title.fontFamily = 'Poor Story';
                        title.style = "text-align: center";
                    }

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

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                    console.log(errorThrown);
                }
            }) //end Chart
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
                        <br/>
                        <select name="category" id="category">
                            <option value="" selected>전체 카테고리</option>
                            <option value="화장품">화장품</option>
                            <option value="패션">패션</option>
                            <option value="잡화">잡화</option>
                            <option value="식품">식품</option>
                            <option value="가전">가전</option>
                            <option value="건강의료">건강/의료</option>
                        </select>

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

<script type="text/javascript">
    $("#category").on("change",function() {
        var cate = $("#category").val();

        cateChange(cate);
    })
</script>
<style>
    /* 파이차트 */
    #chartdiv3 {
        width: 600px;
        height: 600px;
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
