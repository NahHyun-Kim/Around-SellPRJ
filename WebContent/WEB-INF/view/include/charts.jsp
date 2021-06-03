<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Resources(amchart 차트, 워드클라우드) Start-->
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
<!-- Resources(amchart 차트, 워드클라우드) End-->

<script type="text/javascript">
    $(document).ready(function () {
        console.log("준비 됐나?");
        $.ajax({
            url: "/titleCount.do",
            async: false,
            type: "post",
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

            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                console.log(errorThrown);
            }
        })

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


        //slice, draggable 차트(url 추가해야 함..추후) ---------------------------------------------------
        $.ajax({
            url: "/cateCount2.do",
            async: false,
            type: "post",
            //서버에서 전송받을 데이터 형식 JSON 으로 받아야함
            dataType: "JSON",
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            success(res) {

                console.log("res 받아옴!" + res);

                var dataList = [];

                //rList 데이터를 json 형태로 만들어주기
                var config = {
                    "category": "all favorite!",
                    "disabled": true,
                    "cnt": 1000,
                    "color": am4core.color("#dadada"),
                    "opacity": 0.3,
                    "strokeDasharray": "4,4"
                };

                dataList.push(config);
                console.log("설정 push 완료(dataList[])");

                for (var i=0; i<res.length; i++) {
                    var data = {};
                    data.category = res[i].category;
                    data.cnt = res[i].cnt;

                    dataList.push(data);
                    console.log("{} 형태의 data push : " + data);
                    console.log("data(category, cnt) : " + data.category + data.cnt);
                }

                console.log("push한 dataList :" + dataList);

                // Themes begin
                am4core.useTheme(am4themes_material);
                am4core.useTheme(am4themes_animated);
                // Themes end

                // 데이터를 시각화하여 보여주기 위한 설정, category, cnt값 전달
                var data = dataList;
                //console.log("data : "  + data);

                // cointainer to hold both charts
                var container = am4core.create("chartdiv2", am4core.Container);
                container.width = am4core.percent(100);
                container.height = am4core.percent(100);
                container.layout = "horizontal";

                container.events.on("maxsizechanged", function () {
                    chart1.zIndex = 0;
                    separatorLine.zIndex = 1;
                    dragText.zIndex = 2;
                    chart2.zIndex = 3;
                })

                var chart1 = container.createChild(am4charts.PieChart);
                chart1.fontSize = 11;
                chart1.hiddenState.properties.opacity = 0; // this makes initial fade in effect
                chart1.data = data;
                chart1.radius = am4core.percent(70);
                chart1.innerRadius = am4core.percent(40);
                chart1.zIndex = 1;

                var series1 = chart1.series.push(new am4charts.PieSeries());
                series1.dataFields.value = "cnt";
                series1.dataFields.category = "category";
                series1.colors.step = 2;
                series1.alignLabels = false;
                series1.labels.template.bent = true;
                series1.labels.template.radius = 3;
                series1.labels.template.padding(0, 0, 0, 0);

                /** 파이차트에 있는 text값(카테고리명)을 클릭 시, 해당 카테고리에 해당되는 상품을 검색한다.
                 카테고리 G(카테고리명 분류), 검색어 = {category}를 통해 GET 방식으로 url에 검색을 요청 */
                series1.labels.template.url = "/searchList.do?nowPage=1&cntPerPage=9&searchType=G&keyword={category}";
                series1.labels.template.urlTarget = "_blank";

                var sliceTemplate1 = series1.slices.template;
                sliceTemplate1.cornerRadius = 5;
                sliceTemplate1.draggable = true;
                sliceTemplate1.inert = true;
                sliceTemplate1.propertyFields.fill = "color";
                sliceTemplate1.propertyFields.fillOpacity = "opacity";
                sliceTemplate1.propertyFields.stroke = "color";
                sliceTemplate1.propertyFields.strokeDasharray = "strokeDasharray";
                sliceTemplate1.strokeWidth = 1;
                sliceTemplate1.strokeOpacity = 1;

                var zIndex = 5;

                sliceTemplate1.events.on("down", function (event) {
                    event.target.toFront();
// also put chart to front
                    var series = event.target.dataItem.component;
                    series.chart.zIndex = zIndex++;
                })

                series1.ticks.template.disabled = true;

                sliceTemplate1.states.getKey("active").properties.shiftRadius = 0;

                sliceTemplate1.events.on("dragstop", function (event) {
                    handleDragStop(event);
                })

// separator line and text
                var separatorLine = container.createChild(am4core.Line);
                separatorLine.x1 = 0;
                separatorLine.y2 = 300;
                separatorLine.strokeWidth = 3;
                separatorLine.stroke = am4core.color("#dadada");
                separatorLine.valign = "middle";
                separatorLine.strokeDasharray = "5,5";


                var dragText = container.createChild(am4core.Label);
                dragText.text = "관심있는 카테고리별로 확인하세요!";
                dragText.rotation = 90;
                dragText.valign = "middle";
                dragText.align = "center";
                dragText.paddingBottom = 5;

// second chart
                var chart2 = container.createChild(am4charts.PieChart);
                chart2.hiddenState.properties.opacity = 0; // this makes initial fade in effect
                chart2.fontSize = 11;
                chart2.radius = am4core.percent(70);
                chart2.data = data;
                chart2.innerRadius = am4core.percent(40);
                chart2.zIndex = 1;

                var series2 = chart2.series.push(new am4charts.PieSeries());
                series2.dataFields.value = "cnt";
                series2.dataFields.category = "category";
                series2.colors.step = 2;

                series2.alignLabels = false;
                series2.labels.template.bent = true;
                series2.labels.template.radius = 3;
                series2.labels.template.padding(0, 0, 0, 0);
                series2.labels.template.propertyFields.disabled = "disabled";
                /** 파이차트에 있는 text값(카테고리명)을 클릭 시, 해당 카테고리에 해당되는 상품을 검색한다.
                 카테고리 G(카테고리명 분류), 검색어 = {category}를 통해 GET 방식으로 url에 검색을 요청 */
                series2.labels.template.url = "/searchList.do?nowPage=1&cntPerPage=9&searchType=G&keyword={category}";
                series2.labels.template.urlTarget = "_blank";

                var sliceTemplate2 = series2.slices.template;
                sliceTemplate2.copyFrom(sliceTemplate1);

                series2.ticks.template.disabled = true;

                function handleDragStop(event) {
                    var targetSlice = event.target;
                    var dataItem1;
                    var dataItem2;
                    var slice1;
                    var slice2;

                    if (series1.slices.indexOf(targetSlice) != -1) {
                        slice1 = targetSlice;
                        slice2 = series2.dataItems.getIndex(targetSlice.dataItem.index).slice;
                    } else if (series2.slices.indexOf(targetSlice) != -1) {
                        slice1 = series1.dataItems.getIndex(targetSlice.dataItem.index).slice;
                        slice2 = targetSlice;
                    }


                    dataItem1 = slice1.dataItem;
                    dataItem2 = slice2.dataItem;

                    var series1Center = am4core.utils.spritePointToSvg({x: 0, y: 0}, series1.slicesContainer);
                    var series2Center = am4core.utils.spritePointToSvg({x: 0, y: 0}, series2.slicesContainer);

                    var series1CenterConverted = am4core.utils.svgPointToSprite(series1Center, series2.slicesContainer);
                    var series2CenterConverted = am4core.utils.svgPointToSprite(series2Center, series1.slicesContainer);

// tooltipY and tooltipY are in the middle of the slice, so we use them to avoid extra calculations
                    var targetSlicePoint = am4core.utils.spritePointToSvg({
                        x: targetSlice.tooltipX,
                        y: targetSlice.tooltipY
                    }, targetSlice);

                    if (targetSlice == slice1) {
                        if (targetSlicePoint.x > container.pixelWidth / 2) {
                            var value = dataItem1.value;

                            dataItem1.hide();

                            var animation = slice1.animate([{
                                property: "x",
                                to: series2CenterConverted.x
                            }, {property: "y", to: series2CenterConverted.y}], 400);
                            animation.events.on("animationprogress", function (event) {
                                slice1.hideTooltip();
                            })

                            slice2.x = 0;
                            slice2.y = 0;

                            dataItem2.show();
                        } else {
                            slice1.animate([{property: "x", to: 0}, {property: "y", to: 0}], 400);
                        }
                    }
                    if (targetSlice == slice2) {
                        if (targetSlicePoint.x < container.pixelWidth / 2) {

                            var value = dataItem2.value;

                            dataItem2.hide();

                            var animation = slice2.animate([{
                                property: "x",
                                to: series1CenterConverted.x
                            }, {property: "y", to: series1CenterConverted.y}], 400);
                            animation.events.on("animationprogress", function (event) {
                                slice2.hideTooltip();
                            })

                            slice1.x = 0;
                            slice1.y = 0;
                            dataItem1.show();
                        } else {
                            slice2.animate([{property: "x", to: 0}, {property: "y", to: 0}], 400);
                        }
                    }

                    toggleDummySlice(series1);
                    toggleDummySlice(series2);

                    series1.hideTooltip();
                    series2.hideTooltip();
                }

                function toggleDummySlice(series) {
                    var show = true;
                    for (var i = 1; i < series.dataItems.length; i++) {
                        var dataItem = series.dataItems.getIndex(i);
                        if (dataItem.slice.visible && !dataItem.slice.isHiding) {
                            show = false;
                        }
                    }

                    var dummySlice = series.dataItems.getIndex(0);
                    if (show) {
                        dummySlice.show();
                    } else {
                        dummySlice.hide();
                    }
                }

                series2.events.on("datavalidated", function () {

                    var dummyDataItem = series2.dataItems.getIndex(0);
                    dummyDataItem.show(0);
                    dummyDataItem.slice.draggable = false;
                    dummyDataItem.slice.tooltipText = undefined;

                    for (var i = 1; i < series2.dataItems.length; i++) {
                        series2.dataItems.getIndex(i).hide(0);
                    }
                })

                series1.events.on("datavalidated", function () {
                    var dummyDataItem = series1.dataItems.getIndex(0);
                    dummyDataItem.hide(0);
                    dummyDataItem.slice.draggable = false;
                    dummyDataItem.slice.tooltipText = undefined;
                })

            },
// json parse 오류 잡기위한 알림창
            /*
            * 처음 차트를 위한 데이터 설정 부분에서, json 형태에 어긋난 구조가 있어서 오류가 발생함
            * controller에서 json구조로 바꾸어 데이터를 보내서 해결(좀더 바람직한 방법 찾아보기)
            * */
            error: function (jqXHR, textStatus, errorThrown) {
                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                console.log(errorThrown);
            }
        })
//end piechart2


        // 북마크! 여기서 차트 1개 더 테스트
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

                /* image.addEventListener('click', function() {
                    console.log("clicked!");
                    location.href = "/noticeList.do";
                }) */

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
                    location.href = "/noticeList.do";
                })
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                console.log(errorThrown);
            }
        })

        // document.ready 끝
    })



</script>
