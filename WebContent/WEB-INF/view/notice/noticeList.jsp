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
    <title>Around-Sell</title>

    <!-- Resources(amchart 차트) Start-->
    <script src="https://cdn.amcharts.com/lib/4/core.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/charts.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/material.js"></script>
    <script src="https://cdn.amcharts.com/lib/4/themes/animated.js"></script>
    <!-- Resources(amchart 차트) End-->

    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <script type="text/javascript">
        function doDetail(seq) {
            location.href="${pageContext.request.contextPath}/noticeInfo.do?nSeq=" + seq;
        }
    </script>
    <style>
        #weather {
            font-family: "Poor Story";
            font-weight: 600;
        }

        #maps {
            width: 500px; height:300px;
        }

        /*@media only screen and (min-width: 768px) and (max-width: 991px) */
        @media (max-width: 575px) {
            #maps {
                width: 300px; height: 200px;
            }
        }
    </style>
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
                            <div id="maps" style="margin: 0 auto; border-radius: 10%; z-index: 2;
box-shadow: 2px 2px 5px 2px rgba(0, 0, 0, 0.2);">지도</div>
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
                            <h2 class="fontPoor"><%=SS_USER_ADDR2%> &nbsp;</h2>
                            <div id="weather" class="font"></div>

                            <button class="btn btn-info fontPoor toBold" style="background-color: #d0a7e4; border-style: none; margin-right: 10px;" value="내일">내일 날씨</button>
                            <button class="btn btn-info fontPoor toBold" style="background-color: #d0a7e4; border-style: none" value="모레">모레 날씨</button>
                            <br/>
                            <div id="apiRes"></div>

                            <hr/>
                            <!-- Section tittle2 (New 아이템 표시!) -->
                            <div class="row justify-content-center">
                                <div class="col-xl-7 col-lg-8 col-md-10">
                                    <div class="section-tittle mb-10 text-center" >


                                        <!-- 대기환경 수치 게이지 차트 -->
                                        <div id="chartdiv10"></div>
                                    </div>
                                </div>
                            </div>
                            <hr/>
                            <% } %>

                        </div>
                    </div>
                </div>

                <!-- Section tittle2 (New 아이템 표시!) -->
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">
                        <div class="section-tittle mb-70 text-center" >

                            <h2 class="fontPoor"> NEW ITEM </h2>
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
                                    <span class="font" onclick="doDetail(<%=rDTO.getGoods_no()%>)">Click Me!</span>
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
                                <h3><span class="font" id="<%=i%>" onclick="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');" style="cursor: pointer;"></span></h3>
                                <script type="text/javascript">
                                    $("#<%=i%>").text(numberWithCommas(<%=rDTO.getGoods_price()%>) + '원');

                                    <!-- 가격 콤마로 표시하는 함수-->
                                    function numberWithCommas(x) {
                                        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                    }
                                </script>

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
        <h2 class="fontPoor">MY FAVORITE CATEGORY</h2>
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
                            content: '<div style="width:150px;text-align:center;padding:6px 0; font-family: \'Poor Story\'">' + listData[index] + '<button class="btn view-btn3 fontPoor ml-1" id="btn"> 검색</button></div>',
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

                        map.setCenter(coords);
                    }
                });
            });
        </script>


</div>

    <!-- 카테고리별 pie Chart 제공 -->
    <script type="text/javascript">
        $(document).ready(function() {

            // 날씨 정보 호출
            getAir();
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

        // 실시간 대기환경정보 가져오기
        function getAir() {


            // session이 존재할 때만 실행(가입한 지역구 기반으로 대기정보 가져옴)
            if ('<%=SS_USER_NO%>' != null) {
                // 문자열 형태로 받아서 넘겨야 변수를 인식함
                var user_addr = '<%=SS_USER_ADDR2%>';
                console.log("회원 세션 지역구 : " + user_addr);

                $.ajax({
                    url: "/getAir.do",
                    type: "get",
                    dataType: "json",
                    success: function (json) {
                        console.log("json 받아오기 성공!" + json);

                        var resHTML = "";
                        var cnt = 0;
                        // 미세먼지, 초미세먼지 농도에 대한 등급 표시
                        var grade10 = "";
                        var grade25 = "";

                        function grade10Chk(mis) {
                            if (mis <= 30) {
                                grade10 = "좋음";
                            } else if (31 <= mis <= 80) {
                                grade10 = "보통";
                            } else if (81 <= mis <= 151) {
                                grade10 = "나쁨";
                            } else if (mis >= 151) {
                                grade10 = "매우 나쁨";
                            }

                            return grade10;
                        }

                        function grade25Chk(cho) {
                            if (cho <= 15) {
                                grade25 = "좋음";
                            } else if (16 <= cho <= 35) {
                                grade25 = "보통";
                            } else if (36 <= cho <= 75) {
                                grade25 = "나쁨";
                            } else if (cho >= 76) {
                                grade25 = "매우 나쁨";
                            }

                            return grade25;
                        }

                        for (var i = 0; i < json.length; i++) {

                            // 미세먼지(pm10), 초미세먼지(pm25) 상태 체크하는 함수

                            if (json[i].msrstename == user_addr) {

                                resHTML += '<br/><div class="fontPoor">전반적인 대기환경 상태 : <a class="fontPoor" href="https://cleanair.seoul.go.kr/" target="_blank">' + json[i].grade + '(click! 더 알아보기)</a>';
                                resHTML += '<br/> 미세먼지 농도 : ' + json[i].pm10 + '㎍/㎥ (' + grade10Chk(json[i].pm10) + ') 이며,';
                                resHTML += '<br/> 초미세먼지 농도 : ' + json[i].pm25 + '㎍/㎥ (' + grade25Chk(json[i].pm25) + ')입니다.</div>';
                                cnt++;

                                var tmp = json[i].pm10;
                                var pm10 = tmp * 1;

                                /**
                                 * 미세먼지 상태 표시를 위한 게이지 차트 활용
                                 * */
                                // Themes begin
                                am4core.useTheme(am4themes_animated);
                                // Themes end

                                // 미세먼지 농도는 0부터 시작
                                var chartMin = 0;
                                var chartMax = 200;

                                var data = {
                                    // 미세먼지 측정한 농도를 게이지로 나타냄
                                    // 서울시 대기환경정보 미세먼지 농도를 기준으로 그래프 작성
                                    // 좋음, 보통, 나쁨, 매우 나쁨 수치와 등급에 따른 색상 사이트를 참고함
                                    gradingData: [
                                        {
                                            title: "좋음",
                                            color: "#3A59FF",
                                            lowScore: 0,
                                            highScore: 30
                                        },
                                        {
                                            title: "보통",
                                            color: "green",
                                            lowScore: 31,
                                            highScore: 80
                                        },
                                        {
                                            title: "나쁨",
                                            color: "yellow",
                                            lowScore: 81,
                                            highScore: 150
                                        },
                                        {
                                            title: "매우 나쁨",
                                            color: "red",
                                            lowScore: 151,
                                            highScore: 200
                                        }
                                    ]
                                };

                                // 공공데이터로부터 얻어낸 지역구 pm10(미세먼지) 농도를 score 값에 담음
                                data.score = pm10;

                                /**
                                 Grading Lookup
                                 */
                                function lookUpGrade(lookupScore, grades) {
                                    // Only change code below this line
                                    for (var i = 0; i < grades.length; i++) {
                                        if (
                                            grades[i].lowScore < lookupScore &&
                                            grades[i].highScore >= lookupScore
                                        ) {
                                            return grades[i];
                                        }
                                    }
                                    return null;
                                }

// create chart
                                var chart = am4core.create("chartdiv10", am4charts.GaugeChart);
                                chart.hiddenState.properties.opacity = 0;
                                chart.fontSize = 11;
                                chart.innerRadius = am4core.percent(80);
                                chart.resizable = true;

                                var title = chart.titles.create();
                                title.text = "Air Check";
                                title.fontSize = 40;
                                title.fontWeight = "bold";
                                title.fontFamily = 'Poor Story';
                                title.style = "text-align: center";

                                /**
                                 * Normal axis
                                 */

                                var axis = chart.xAxes.push(new am4charts.ValueAxis());
                                axis.min = chartMin;
                                axis.max = chartMax;
                                axis.strictMinMax = true;
                                axis.renderer.radius = am4core.percent(80);
                                axis.renderer.inside = true;
                                axis.renderer.line.strokeOpacity = 0.1;
                                axis.renderer.ticks.template.disabled = false;
                                axis.renderer.ticks.template.strokeOpacity = 1;
                                axis.renderer.ticks.template.strokeWidth = 0.5;
                                axis.renderer.ticks.template.length = 5;
                                axis.renderer.grid.template.disabled = true;
                                axis.renderer.labels.template.radius = am4core.percent(15);
                                axis.renderer.labels.template.fontSize = "0.8em";
                                axis.renderer.labels.template.fontFamily = 'Poor Story';

                                /**
                                 * Axis for ranges
                                 */

                                var axis2 = chart.xAxes.push(new am4charts.ValueAxis());
                                axis2.min = chartMin;
                                axis2.max = chartMax;
                                axis2.strictMinMax = true;
                                axis2.renderer.labels.template.disabled = true;
                                axis2.renderer.ticks.template.disabled = true;
                                axis2.renderer.grid.template.disabled = false;
                                axis2.renderer.grid.template.opacity = 0.5;
                                axis2.renderer.labels.template.bent = true;
                                axis2.renderer.labels.template.fill = am4core.color("#000");
                                axis2.renderer.labels.template.fontWeight = "bold";
                                axis2.renderer.labels.template.fillOpacity = 0.3;



                                /**
                                 Ranges
                                 */

                                for (let grading of data.gradingData) {
                                    var range = axis2.axisRanges.create();
                                    range.axisFill.fill = am4core.color(grading.color);
                                    range.axisFill.fillOpacity = 0.8;
                                    range.axisFill.zIndex = -1;
                                    range.value = grading.lowScore > chartMin ? grading.lowScore : chartMin;
                                    range.endValue = grading.highScore < chartMax ? grading.highScore : chartMax;
                                    range.grid.strokeOpacity = 0;
                                    range.stroke = am4core.color(grading.color).lighten(-0.1);
                                    range.label.inside = true;
                                    range.label.text = grading.title.toUpperCase();
                                    range.label.inside = true;
                                    range.label.location = 0.5;
                                    range.label.inside = true;
                                    range.label.radius = am4core.percent(10);
                                    range.label.paddingBottom = -5; // ~half font size
                                    range.label.fontSize = "0.9em";
                                }

                                var matchingGrade = lookUpGrade(data.score, data.gradingData);

                                /**
                                 * Label 1
                                 */

                                var label = chart.radarContainer.createChild(am4core.Label);
                                label.isMeasured = false;
                                label.fontSize = "5em";
                                label.x = am4core.percent(50);
                                label.paddingBottom = 15;
                                label.horizontalCenter = "middle";
                                label.verticalCenter = "bottom";
                                //label.dataItem = data;
                                label.text = data.score.toFixed(1);
                                label.fontFamily = 'Poor Story';

                                //label.text = "{score}";
                                label.fill = am4core.color(matchingGrade.color);

                                /**
                                 * Label 2
                                 */

                                var label2 = chart.radarContainer.createChild(am4core.Label);
                                label2.isMeasured = false;
                                label2.fontSize = "2em";
                                label2.horizontalCenter = "middle";
                                label2.verticalCenter = "bottom";
                                label2.text = matchingGrade.title.toUpperCase();
                                label2.fill = am4core.color(matchingGrade.color);


                                /**
                                 * Hand
                                 */

                                var hand = chart.hands.push(new am4charts.ClockHand());
                                hand.axis = axis2;
                                hand.innerRadius = am4core.percent(55);
                                hand.startWidth = 8;
                                hand.pin.disabled = true;
                                hand.value = data.score;
                                hand.fill = am4core.color("#444");
                                hand.stroke = am4core.color("#000");

                                hand.events.on("positionchanged", function(){
                                    label.text = axis2.positionToValue(hand.currentPosition).toFixed(1);
                                    var value2 = axis.positionToValue(hand.currentPosition);
                                    var matchingGrade = lookUpGrade(axis.positionToValue(hand.currentPosition), data.gradingData);
                                    label2.text = matchingGrade.title.toUpperCase();
                                    label2.fill = am4core.color(matchingGrade.color);
                                    label2.stroke = am4core.color(matchingGrade.color);
                                    label.fill = am4core.color(matchingGrade.color);
                                })

                            }

                        }

                        console.log("총 결과 수 : " + cnt);

                        // 지역구에 해당하는 대기정보를 가져왔다면, 결과를 보여줌
                        if (cnt > 0) {
                            $("#apiRes").html(resHTML);
                        } else if (cnt == 0) {
                            // 서울시에 해당하지 않는 지역의 경우에는 불러오지 못했다는 문구를 대신 띄움
                            $("#apiRes").html("대기 정보를 불러오지 못했습니다 :(");
                        }


                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }
                })
            }
        }
    </script>

    <style>
        .toBold {
            font-weight: bold;
        }

        #chartdiv10 {
            width: 350px;
            height: 350px;
            margin: 0 auto;
        }
    </style>
    <!-- 로그인 한 유저의 지역구 날씨 크롤링 -->
    <script type="text/javascript" src="/resource/js/Weather.js?ver=2"></script>

    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>