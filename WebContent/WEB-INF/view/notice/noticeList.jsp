<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.*" %>
<%
    List<NoticeDTO> rList = (List<NoticeDTO>) request.getAttribute("rList");

    // 게시판 조회 결과 보여주기(null일 경우 객체 생성)
    if (rList == null) {
        rList = new ArrayList<NoticeDTO>();
    }

%>

<html>
<head>
    <title>판매글 목록</title>

    <!-- Resources(amchart 차트) Start-->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
    <!-- Resources(amchart 차트) End-->

    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <!-- charts.jsp -->
<%--    <%@ include file="/WEB-INF/view/include/charts.jsp"%>--%>

    <script type="text/javascript">
        function doDetail(seq) {
            location.href="${pageContext.request.contextPath}/noticeInfo.do?nSeq=" + seq;
        }
    </script>
</head>

<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

    <!-- index -->

    <main>

        <!-- 상품 목록 일부 보여주기(index) 시작 -->
        <div class="popular-items section-padding30">
            <!-- container 시작 -->
            <div class="container">

                <!-- Section tittle1 (지역정보, 날씨정보 표시) -->
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">

                        <div class="section-tittle mb-70 text-center" >
                            <!-- 다중 마커 -->
                            <div id="maps" style="width: 500px; height:300px; margin: 0 auto; border-radius: 10%; z-index: 2;">지도</div>
                        </div>

                        <div class="section-tittle mb-70 text-center" >

                            <hr/>
                            <!-- 로그인 안 한 상태로 인덱스페이지 접근 시, 로고 보여주기 -->
                            <% if (SS_USER_ADDR2 == null) { %>
                            <h2><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                     style="width:200px;height: 55px;"></h2>
                            <p class="font">우리 동네, 집 주변 판매하는 상품 찾기 웹 서비스 <br/>
                            <a class="font" href="/logIn.do">로그인</a> 후 설정한 지역구의 판매 상품 정보를 받아보세요!</p>
                            <hr/>
                            <!-- 로그인 했다면 지역구 날씨 보여주기 -->
                            <% } else { %>
                            <h2><%=SS_USER_ADDR2%> &nbsp;</h2>
                            <div id="weather" class="font"></div>

                            <button class="btn btn-info font" style="background-color: #d0a7e4; border-style: none; margin-right: 10px;" value="내일">내일 날씨</button>
                            <button class="btn btn-info font" style="background-color: #d0a7e4; border-style: none" value="모레">모레 날씨</button>
                            <hr/>
                            <% } %>

                        </div>
                    </div>
                </div>

                <!-- Section tittle2 (New 아이템 표시!) -->
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">
                        <div class="section-tittle mb-70 text-center" >

                            <h2 class="font"> NEW ITEM </h2>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <%
                        for(int i=0; i<rList.size(); i++) {
                            NoticeDTO rDTO = rList.get(i);

                            if (rDTO == null) {
                                rDTO = new NoticeDTO();
                            }

                            // 메인 페이지에는 9개의 게시글만 보여줌, (view more로 모든 게시물 확인 가능)
                            // for문을 9개로 돌리면 적은 갯수의 게시물이 있을경우 오류가 발생하여 전체로 돌리고 9개 이상이면 break 처리함
                            if (i>=9) {
                                break;
                            }
                    %>
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                        <div class="single-popular-items mb-50 text-center">
                            <!-- 상품 이미지 -->
                            <div class="popular-img">
                                <img src="/resource/images/<%=rDTO.getImgs()%>" alt=""
                                     style="width:240px; height:240px; object-fit: contain; cursor: pointer" onclick="doDetail(<%=rDTO.getGoods_no()%>)">

                                <!-- hover 적용, 마우스 올릴 시 click me! 문구 표시 -->
                                <div class="img-cap">
                                    <span class="font">Click Me!</span>
                                </div>

                                <!-- 하트 표시를 누르면 관심상품 유효성 체크 + 등록 진행 -->
                                <div class="favorit-items">
                                    <span class="flaticon-heart" onclick="addCart(<%=rDTO.getGoods_no()%>, <%=rDTO.getUser_no()%>)"></span>
                                </div>
                            </div>

                            <div class="popular-caption">
                                <!-- 상품명 -->
                                <h3><a class="font" href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                                    <%=CmmUtil.nvl(rDTO.getGoods_title())%>
                                </a></h3>

                                <!-- 가격 -->
                                <!--<span style="font-size: 15px;"><%=CmmUtil.nvl(rDTO.getGoods_addr())%></span>-->
                                <h3><a class="font" href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');"><%=CmmUtil.nvl(rDTO.getGoods_price())%></a></h3>

                                <!-- 상호명 -->
                                <h5><a class="font" style="color: #d0a7e4;" href="javascript:searchLocation('<%=CmmUtil.nvl(rDTO.getGoods_addr())%>', <%=rDTO.getGoods_no()%>)"><%=CmmUtil.nvl(rDTO.getGoods_addr())%></a></h5>
                            </div>
                        </div>
                    </div>
                    <% } %>

                </div>
                <!-- end row -->

                <!-- Button -->
                <div class="row justify-content-center">
                    <div class="room-btn pt-70" style="padding-top: 5px;">
                        <a href="/searchList.do" class="btn view-btn1">View More Products</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- 상품 목록 일부 보여주기(index) 끝 -->

    </main>

    <div class="section-tittle mb-70 text-center" >
        <h2 class="font">MY FAVORITE CATEGORY</h2>
    </div>
    <hr/>
    <!-- 동적 파이차트 HTML -->
    <div id="chartdiv2" style="height: 400px; margin: 0 auto;"></div>

    <input type="hidden" id="getAddr2" value="<%=SS_USER_ADDR2%>"/>
    <input type="hidden" id="ss_no" value="<%=SS_USER_NO%>">


        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
        <script>
            // 다중마커 예제, 지도 생성 및 리스트 형태로 지도를 검색하여 마커 찍기
            var mapContainer = document.getElementById('maps');
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

<%--    <!-- 워드클라우드 HTML -->--%>
<%--    <div id="chartdiv"></div>--%>



<%--    <!-- 일반 파이차트 HTML(고민중) -->--%>
<%--    <div id="chartdiv3"></div>--%>
<%--    <hr/>--%>

<%--    <!-- 이미지 넣은 차트(고민중) -->--%>
<%--    <div id="chartdiv4"></div>--%>
<%--    <hr/>--%>

</div>

    <!-- 카테고리별 pie Chart 제공 -->
    <script type="text/javascript">
        $(document).ready(function() {
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

            error: function (jqXHR, textStatus, errorThrown) {
                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                console.log(errorThrown);
            }
        })
        })
        //end piechart2
    </script>
    <!-- 로그인 한 유저의 지역구 날씨 크롤링 -->
    <script type="text/javascript" src="/resource/js/Weather.js?ver=2"></script>

    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>