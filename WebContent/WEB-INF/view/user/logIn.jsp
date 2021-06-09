<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Around-Sell 로그인</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>
    <script type="text/javascript">
        $(document).ready(function() {
            var user_no = <%=SS_USER_NO%>;

            if (user_no != null) {
                Swal.fire({
                    title: '이미 로그인 상태입니다.',
                    icon: 'warning',
                    showConfirmButton: false,
                    timer: 2500
                }).then(val => {
                    if (val) {
                        location.href = "javascript:history.back();";
                    }
                });
            }
        })
    </script>

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

        <!-- 로그인 area -->
        <!--================login_part Area =================-->
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

                                <form action="/getLogin.do" class="row contact_form" method="POST" onsubmit="return loginChk()">

                                    <!-- 이메일 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input class="form-control font" type="email" name="user_email" id="user_email" placeholder="이메일을 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font font" id="email_check"></div>
                                    </div>


                                    <!-- 비밀번호 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <input type="password" class="form-control font" name="password" id="password" placeholder="비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font font" id="pwd_check"></div>
                                    </div>

                                    <div class="col-md-12 form-group">

                                        <!-- 로그인, 비밀번호 찾기 버튼 -->
                                        <button type="submit" value="submit" class="btn_3 font">
                                            log in
                                        </button>
                                        <a class="lost_pass font" href="/signup.do">Sign Up</a>
                                        <br/>
                                        <a class="lost_pass font" href='/userSearch.do'>Find ID/PW</a>

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

    <style>
        .check_font {
            font-family: "Noto Sans KR";
            margin-top:5px;
        }
    </style>
     <!-- 로그인 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/loginCheck.js"></script>

    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>

