<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Around-Sell 로그인</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>
</head>

<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

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

    <main>

        <!-- 로그인 area -->
        <!--================login_part Area =================-->
        <section class="login_part section_padding ">
            <div class="container">
                <div class="row align-items-center">
                    <!--<div class="col-lg-6 col-md-6">
                        <div class="login_part_text text-center">
                            <div class="login_part_text_iner" style="margin-top: 10px;">
                                <h2>New to our Shop?</h2>
                                <p>Around-Sell은 가입한 지역구에 대한 판매글 정보를 받아볼 수 있는 웹 서비스입니다. 회원가입 시, 지역구 설정과 관심상품 등의 서비스 이용이 가능합니다.</p>
                                <a href="/signup.do" class="btn_3">Around-Sell 회원가입</a>
                            </div>
                        </div>
                    </div>-->
                    <div class="col-lg-1 col-md-1">
                    </div>

                    <!--<div class="col-lg-6 col-md-6"> -->
                    <div class="col-lg-5 col-md-5"  style="border-right: 1px dotted #d0a7e4;">
                        <div class="login_part_text text-center">
                            <div class="login_part_text_iner" style="margin-top: 5px;">
                                <div id="chartdivLogin" style="width: 420px; height: 380px;"></div>
                            </div>
                        </div>
                    </div>


                    <div class="col-lg-5 col-md-5">
                        <div class="login_part_form">
                            <div class="login_part_form_iner">
                                <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                                <form action="/getLogin.do" class="row contact_form" method="POST" onsubmit="return loginChk()">

                                    <!-- 이메일 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." style="margin-top: 10px;">
                                    </div>
                                    <div class="check_font" id="email_check"></div>

                                    <!-- 비밀번호 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input type="password" class="form-control" name="password" id="password" placeholder="비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                    </div>
                                    <div class="col-md-12 form-group">

                                        <!-- 로그인, 비밀번호 찾기 버튼 -->
                                        <button type="submit" value="submit" class="btn_3">
                                            log in
                                        </button>
                                        <a class="lost_pass" href="/signup.do">Sign Up</a>
                                        <br/>
                                        <a class="lost_pass" href='/userSearch.do'>Find ID/PW</a>

                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>

                    <div class="col-lg-1 col-md-1">
                    </div>
                </div>
            </div>

        </section>
        <!--================login_part end =================-->
    </main>

    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/user.css"/>

     <!-- 로그인 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/loginCheck.js"></script>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>

