<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Resources -->
<script src="https://cdn.amcharts.com/lib/4/core.js"></script>
<script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
<script src="https://cdn.amcharts.com/lib/4/plugins/wordCloud.js"></script>
<script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>

<!-- Chart code -->
<script>
    $(document).ready(function() {

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

                var chart = am4core.create("chartdivLogin", am4plugins_wordCloud.WordCloud);
                var series = chart.series.push(new am4plugins_wordCloud.WordCloudSeries());

                series.accuracy = 4;
                series.step = 15;
                series.rotationThreshold = 0.7;
                series.maxCount = 200;
                series.minWordLength = 2;
                series.labels.template.margin(4, 4, 4, 4);
                series.maxFontSize = am4core.percent(30);

                series.text = res;

                series.randomness = 0;
                series.colors = new am4core.ColorSet();
                series.colors.passOptions = {}; // makes it loop

//series.labelsContainer.rotation = 45;
                series.angles = [0, -90];
                series.fontWeight = "700"

                // setInterval(function () {
                //     series.dataItems.getIndex(Math.round(Math.random() * (series.dataItems.length - 1))).setValue("value", Math.round(Math.random() * 10));
                // }, 10000)

            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                console.log(errorThrown);
            }
        })
    }); // end Document.ready()

</script>
