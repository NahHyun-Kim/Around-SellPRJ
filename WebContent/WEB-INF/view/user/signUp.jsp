<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Around-Sell 회원가입</title>
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

    <!-- wordCloud 디자인용(로그인, 회원가입, 비밀번호 찾기 시 사용) -->
    <%@ include file="../include/wordcloudForDesign.jsp"%>

    <main>

        <!-- REG area -->
        <!--================REG_PART Area =================-->
        <section class="login_part section_padding ">
            <div class="container">
                <div class="row align-items-center">

                    <div class="col-lg-6 col-md-6"  style="border-right: 1px dotted #d0a7e4;">
                        <div class="login_part_text text-center">
                            <div class="login_part_text_iner" style="margin-top: 5px;">
                                <!-- 로그인/ 회원가입 디자인용 워드클라우드 -->
                                <div id="chartdivLogin"></div>

                                <!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
                                <div id="map" style="border-radius:10%; margin: 0 auto;"></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5 col-md-5">
                        <div class="login_part_form">
                            <div class="login_part_form_iner">
                                <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                                <form action="/insertUser.do" method="POST" onsubmit="return signupCheck()" class="row contact_form">

                                    <!-- 이메일 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." />
                                        <div class="check_font" id="email_check"></div>
                                    </div>


                                    <!-- 이름 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="text" name="user_name" id="user_name" placeholder="이름을 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font" id="name_check"></div>
                                    </div>

                                    <!-- 비밀번호 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="password" name="password" id="password_1" placeholder="비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font" id="pw_check1"></div>
                                    </div>

                                    <!-- 비밀번호 확인 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font" id="pw_check2"></div>
                                    </div>

                                    <!-- 핸드폰 번호 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="text" name="phone_no" id="phone_no" placeholder="-를 제외한 전화번호를 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font" id="phone_check"></div>
                                    </div>

                                    <!-- 주소 입력(도로명주소 이용) -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control" type="text" name="addr" id="sample5_address" placeholder="주소를 검색해 주세요" style="margin-top: 10px;">
                                        <input type="button" class="btn_3" onclick="sample5_execDaumPostcode()" value="주소 검색"/>
                                        <!--<div class="check_font" id="addr_check"></div>-->
                                    </div>

                                    <div class="col-md-12 form-group">

                                        <!-- 회원가입, 로그인 버튼 -->
                                        <button type="submit" value="submit" class="btn_3">
                                            Sign Up
                                        </button>
                                        <a class="lost_pass" href="/logIn.do">Log In</a>
                                        <br/>


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

<!-- 회원가입 유효성 체크 js -->

<script type="text/javascript" src="/resource/valid/userCheck.js?ver=1"></script>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js?ver=1"></script>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp"%>
</body>
</html>
