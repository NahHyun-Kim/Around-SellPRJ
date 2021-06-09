<%@ page import="poly.util.CmmUtil"%>
<%@ include file="../include/session.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>AroundSell-비밀번호 변경</title>
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

    <!--================비밀번호 변경 Area =================-->
    <section class="login_part section_padding ">
        <div class="container">
            <div class="row align-items-center">

                <div class="col-lg-6 col-md-6"  style="border-right: 1px dotted #d0a7e4;">
                    <div class="login_part_text text-center">
                        <div class="login_part_text_iner" style="margin-top: 5px;">
                            <div id="chartdivLogin"></div>
                        </div>
                    </div>
                </div>


                <div class="col-lg-5 col-md-5">
                    <div class="login_part_form">
                        <div class="login_part_form_iner">
                            <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                            <form action="/updatePw.do" method="post" class="row contact_form" onsubmit="return pwChk()">

                                <!-- 변경할 비밀번호 입력 -->
                                <div class="col-md-12 form-group p_star">
                                    <input class="form-control font" type="password" id="password1" name="password1" placeholder="비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                    <div class="font" id="pwd1_check"></div>
                                </div>

                                <!-- 변경할 비밀번호 확인 입력 -->
                                <div class="col-md-12 form-group p_star">
                                    <input class="form-control font" type="password" id="password2" name="password2" placeholder="비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                    <div class="font" id="pwd2_check"></div>
                                </div>

                                <div class="col-md-12 form-group">
                                    <!-- 로그인, 비밀번호 찾기 버튼 -->
                                    <button type="submit" value="submit" class="btn_3 font">
                                        비밀번호 변경하기
                                    </button>
                                    <a class="lost_pass font" href="/findPwChk.do">뒤로가기</a>
                                    <br/>
                                    <a class="lost_pass font" href='/getIndex.do'>메인으로</a>

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
    <!--================인증번호 입력 Area =================-->
</main>

<!-- 이메일/비밀번호 찾기 js -->
<script type="text/javascript" src="/resource/valid/searchUser.js?ver=1"></script>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp"%>
</body>
</html>
