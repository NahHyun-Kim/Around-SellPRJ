<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>아이디 & 비밀번호 찾기</title>
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

                    <%--                    <div class="col-lg-1 col-md-1">--%>
                    <%--                    </div>--%>

                    <!--<div class="col-lg-6 col-md-6"> -->
                    <div class="col-lg-6 col-md-6"  style="border-right: 1px dotted #d0a7e4;">
                        <div class="login_part_text text-center">
                            <div class="login_part_text_iner" style="margin-top: 5px;">
                                <div class="col-md-12 form-group p_star">
                                    <div id="chartdivLogin" style="margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="col-lg-6 col-md-6">
                        <div class="login_part_form" style="margin: 0 auto;">
                            <div class="login_part_form_iner" style="width:350px;">
                                <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                                <div class="col-md-12 form-group p_star">
                                    <label for="search_1" class="font">이메일 찾기</label>
                                    <input type="radio" id="search_1" name="search_total" onclick="search_check(1)" checked="checked" />

                                    <label for="search_2" class="font">비밀번호 찾기</label>
                                    <input type="radio" id="search_2" name="search_total" onclick="search_check(2)" />
                                </div>

                                <hr/>
                                <!-- 이메일 찾기 -->
                                    <form action="/findEmailUser.do", method="post", onsubmit="return emailSearch()">
                                        <div id="searchE">

                                                <div class="col-md-12 form-group p_star">
                                                    <label for="inputPhone" class="font">핸드폰 번호</label>
                                                    <input class="form-control font" type="text" id="inputPhone" name="inputPhone" placeholder="ex)01012345678"/>
                                                </div>

                                            <div class="col-md-12 form-group">
                                                <!-- 이메일 찾기 버튼 -->
                                                <button type="submit" value="submit" class="btn_3 font">
                                                    이메일 찾기
                                                </button>
                                            </div>
                                        </div>
                                    </form>


                                    <!-- 비밀번호 찾기 -->
                                    <form action="/findPassword.do", method="post", onsubmit="return pwSearch()">

                                        <div id="searchP" style="display: none;">

                                                <div class="col-md-12 form-group p_star">
                                                    <label for="inputEmail" class="font">이메일</label>
                                                    <input class="form-control font" type="email" id="inputEmail" name="inputEmail" placeholder="가입 시 이메일을 입력해 주세요."/>
                                                </div>

                                            <div class="col-md-12 form-group">
                                                <!-- 비밀번호 찾기 버튼 -->
                                                <button type="submit" value="submit" class="btn_3 font">
                                                    비밀번호 찾기
                                                </button>

                                            </div>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
            </div>

        </section>
        <!--================ 비밀번호/ 아이디 찾기 완료 =================-->
    </main>

    <!-- include JS File -->
    <%@ include file="../include/jsFile.jsp"%>

    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- 이메일/비밀번호 찾기 js -->
    <script type="text/javascript" src="/resource/valid/searchUser.js"></script>
</body>
</html>
