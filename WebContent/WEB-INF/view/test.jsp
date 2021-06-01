<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // nav(top)에 공통으로 사용되는 session값
    String SS_USER_NO = ((String) session.getAttribute("SS_USER_NO"));
    String SS_USER_NAME = ((String) session.getAttribute("SS_USER_NAME"));
    String SS_USER_ADDR = ((String) session.getAttribute("SS_USER_ADDR"));
    String SS_USER_ADDR2 = ((String) session.getAttribute("SS_USER_ADDR2"));

%>
<!doctype html>
<html class="no-js" lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Around Sell</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="/resources/boot/img/logo/aroundsell_find.png">

    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>

    <!-- 부트스트랩 템플릿 CSS -->
    <link rel="stylesheet" href="/resources/boot/css/mystyle.css?ver=1">
    <!-- top 네비게이션 바 CSS -->
    <link rel="stylesheet" href="/resources/boot/css/slicknav.css?ver=1">
    <link rel="stylesheet" href="/resources/boot/css/style.css?ver=1">

    <link rel="stylesheet" href="/resources/boot/css/bootstrap.min.css">
    <link rel="stylesheet" href="/resources/boot/css/owl.carousel.min.css">
    <link rel="stylesheet" href="/resources/boot/css/flaticon.css">
    <link rel="stylesheet" href="/resources/boot/css/animate.min.css">
    <link rel="stylesheet" href="/resources/boot/css/magnific-popup.css">
    <link rel="stylesheet" href="/resources/boot/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="/resources/boot/css/themify-icons.css">
    <link rel="stylesheet" href="/resources/boot/css/slick.css">
    <link rel="stylesheet" href="/resources/boot/css/nice-select.css">

</head>

<body>

<!-- Preloader(로딩 중 js) Start -->
<div id="preloader-active">
    <div class="preloader d-flex align-items-center justify-content-center">
        <div class="preloader-inner position-relative">
            <div class="preloader-circle"></div>
            <div class="preloader-img pere-text">
                <img src="/resources/boot/img/logo/aroundsell_find.png" alt="">
            </div>
        </div>
    </div>
</div>
<!-- Preloader(로딩 중 js) End -->

<!------------------------------------------------------------------------------------------------------------>
<!-- Header(상단 메뉴바 시작!) Start -->
<header>
    <div class="header-area">
        <div class="main-header header-sticky">
            <div class="container-fluid">
                <div class="menu-wrapper">
                    <!-- aroundSell mainPage Top(로고+돋보기(=검색창 이동) -->
                    <div class="logo">
                        <a href="/index.do"><img id="aroundsell" src="/resources/boot/img/logo/aroundsell_main.png" alt=""></a>
                        <a href="/searchList.do"><img id="findlogo" src="/resources/boot/img/logo/aroundsell_find.png"/></a>
                    </div>

                    <!-- aroundSell 메인 메뉴바-->
                    <div class="main-menu d-none d-lg-block">
                        <nav>
                            <ul id="navigation">
                                <!-- 홈페이지(index), 워드클라우드와 전체 판매글을 표시한다.-->
                                <li><a href="/index.do">Home</a></li>

                                <!-- 상품 등록 검색 결과를 제공하는 shop&Search -->
                                <li><a href="/searchList.do">Shop & Search</a>
                                    <ul class="submenu">
                                        <li><a href="/noticeList.do"> 상품 리스트</a></li>
                                        <li><a href="/searchList.do"> 상품 검색</a></li>
                                        <li><a href="/noticeForm.do"> 판매글 등록하기</a></li>
                                    </ul>
                                </li>

                                <!-- 인기 상품 시각화 차트정보를 제공하는 Chart -->
                                <li class="hot"><a href="#">Chart</a>
                                    <ul class="submenu">
                                        <li><a href="/noticeList.do"> 인기 차트</a></li>
                                        <li><a href="/noticeList.do"> 인기 차트2</a></li>
                                    </ul>
                                </li>

                                <!-- 관심상품과 최근 본 상품 메뉴 -->
                                <li><a href="#">Cart</a>
                                    <ul class="submenu">
                                        <li><a href="/myCart.do">관심상품</a></li>
                                        <li><a href="/mySee.do">최근 본 상품</a></li>
                                    </ul>
                                </li>

                                <!-- 로그아웃(혹은 로그인&회원가입), 회원 정보를 제공하는 메뉴 -->
                                <li><a href="#">MyPage</a>
                                    <ul class="submenu">
                                        <li><a href="/logIn.do">로그인</a></li>
                                        <li><a href="/getUserInfo.do">나의 개인정보</a></li>
                                        <li><a href="/myList.do">나의 판매글</a></li>
                                        <li><a href="/noticeForm.do">판매글 등록하기</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </nav>
                    </div>
                    <!-- 메뉴바 끝 -->

                    <!-- Header Right -->
                    <div class="header-right">
                        <ul>
                            <li>
                                <div class="nav-search search-switch">
                                    <span class="flaticon-search"></span>
                                </div>
                            </li>
                            <li> <a href="login.html"><span class="flaticon-user"></span></a></li>
                            <li><a href="/myCart.do"><span class="flaticon-shopping-cart"></span></a> </li>
                        </ul>
                    </div>
                </div>
                <!-- Mobile Menu -->
                <div class="col-12">
                    <div class="mobile_menu d-block d-lg-none"></div>
                </div>
            </div>
        </div>
    </div>

</header>
<!-- Header End(상단 메뉴바 끝!) -->
<!------------------------------------------------------------------------------------------------------------>

<main>
    <!--? slider Area Start -->
    <div class="slider-area ">
        <div class="slider-active">
            <!-- Single Slider -->
            <div class="single-slider slider-height d-flex align-items-center slide-bg">
                <div class="container">
                    <div class="row justify-content-between align-items-center">
                        <div class="col-xl-8 col-lg-8 col-md-8 col-sm-8">
                            <div class="hero__caption">
                                <h1 data-animation="fadeInLeft" data-delay=".4s" data-duration="2000ms">Select Your New Perfect Style</h1>
                                <p data-animation="fadeInLeft" data-delay=".7s" data-duration="2000ms">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat is aute irure.</p>
                                <!-- Hero-btn -->
                                <div class="hero__btn" data-animation="fadeInLeft" data-delay=".8s" data-duration="2000ms">
                                    <a href="industries.html" class="btn hero-btn">Shop Now</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-4 col-sm-4 d-none d-sm-block">
                            <div class="hero__img" data-animation="bounceIn" data-delay=".4s">
                                <img src="/resources/boot/img/hero/watch.png" alt="" class=" heartbeat">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Single Slider -->
            <div class="single-slider slider-height d-flex align-items-center slide-bg">
                <div class="container">
                    <div class="row justify-content-between align-items-center">
                        <div class="col-xl-8 col-lg-8 col-md-8 col-sm-8">
                            <div class="hero__caption">
                                <h1 data-animation="fadeInLeft" data-delay=".4s" data-duration="2000ms">Select Your New Perfect Style</h1>
                                <p data-animation="fadeInLeft" data-delay=".7s" data-duration="2000ms">Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat is aute irure.</p>
                                <!-- Hero-btn -->
                                <div class="hero__btn" data-animation="fadeInLeft" data-delay=".8s" data-duration="2000ms">
                                    <a href="industries.html" class="btn hero-btn">Shop Now</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-4 col-sm-4 d-none d-sm-block">
                            <div class="hero__img" data-animation="bounceIn" data-delay=".4s">
                                <img src="/resources/boot/img/hero/watch.png" alt="" class=" heartbeat">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- slider Area End-->
    <!-- ? New Product Start -->
    <section class="new-product-area section-padding30">
        <div class="container">
            <!-- Section tittle -->
            <div class="row">
                <div class="col-xl-12">
                    <div class="section-tittle mb-70">
                        <h2>New Arrivals</h2>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-new-pro mb-30 text-center">
                        <div class="product-img">
                            <img src="/resources/boot/img/gallery/new_product1.png" alt="">
                        </div>
                        <div class="product-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-new-pro mb-30 text-center">
                        <div class="product-img">
                            <img src="/resources/boot/img/gallery/new_product2.png" alt="">
                        </div>
                        <div class="product-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-new-pro mb-30 text-center">
                        <div class="product-img">
                            <img src="/resources/boot/img/gallery/new_product3.png" alt="">
                        </div>
                        <div class="product-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!--  New Product End -->
    <!--? Gallery Area Start -->
    <div class="gallery-area">
        <div class="container-fluid p-0 fix">
            <div class="row">
                <div class="col-xl-6 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-gallery mb-30">
                        <div class="gallery-img big-img" style="background-image: url(/resources/boot/img/gallery/gallery1.png);"></div>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-gallery mb-30">
                        <div class="gallery-img big-img" style="background-image: url(/resources/boot/img/gallery/gallery2.png);"></div>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-4 col-md-12">
                    <div class="row">
                        <div class="col-xl-12 col-lg-12 col-md-6 col-sm-6">
                            <div class="single-gallery mb-30">
                                <div class="gallery-img small-img" style="background-image: url(/resources/boot/img/gallery/gallery3.png);"></div>
                            </div>
                        </div>
                        <div class="col-xl-12 col-lg-12  col-md-6 col-sm-6">
                            <div class="single-gallery mb-30">
                                <div class="gallery-img small-img" style="background-image: url(/resources/boot/img/gallery/gallery4.png);"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <!-- Gallery Area End -->
    <!--? Popular Items Start -->
    <div class="popular-items section-padding30">
        <div class="container">
            <!-- Section tittle -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">
                    <div class="section-tittle mb-70 text-center">
                        <h2>Popular Items</h2>
                        <p>Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis ipsum suspendisse ultrices gravida.</p>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular1.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular2.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular3.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular4.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular5.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <div class="popular-img">
                            <img src="/resources/boot/img/gallery/popular6.png" alt="">
                            <div class="img-cap">
                                <span>Add to cart</span>
                            </div>
                            <div class="favorit-items">
                                <span class="flaticon-heart"></span>
                            </div>
                        </div>
                        <div class="popular-caption">
                            <h3><a href="product_details.html">Thermo Ball Etip Gloves</a></h3>
                            <span>$ 45,743</span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Button -->
            <div class="row justify-content-center">
                <div class="room-btn pt-70">
                    <a href="catagori.html" class="btn view-btn1">View More Products</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Popular Items End -->
    <!--? Video Area Start -->
    <div class="video-area">
        <div class="container-fluid">
            <div class="row align-items-center">
                <div class="col-lg-12">
                    <div class="video-wrap">
                        <div class="play-btn "><a class="popup-video" href="https://www.youtube.com/watch?v=KMc6DyEJp04"><i class="fas fa-play"></i></a></div>
                    </div>
                </div>
            </div>
            <!-- Arrow -->
            <div class="thumb-content-box">
                <div class="thumb-content">
                    <h3>Next Video</h3>
                    <a href="#"> <i class="flaticon-arrow"></i></a>
                </div>
            </div>
        </div>
    </div>
    <!-- Video Area End -->
    <!--? Watch Choice  Start-->
    <div class="watch-area section-padding30">
        <div class="container">
            <div class="row align-items-center justify-content-between padding-130">
                <div class="col-lg-5 col-md-6">
                    <div class="watch-details mb-40">
                        <h2>Watch of Choice</h2>
                        <p>Enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse.</p>
                        <a href="shop.html" class="btn">Show Watches</a>
                    </div>
                </div>
                <div class="col-lg-6 col-md-6 col-sm-10">
                    <div class="choice-watch-img mb-40">
                        <img src="/resources/boot/img/gallery/choce_watch1.png" alt="">
                    </div>
                </div>
            </div>
            <div class="row align-items-center justify-content-between">
                <div class="col-lg-6 col-md-6 col-sm-10">
                    <div class="choice-watch-img mb-40">
                        <img src="/resources/boot/img/gallery/choce_watch2.png" alt="">
                    </div>
                </div>
                <div class="col-lg-5 col-md-6">
                    <div class="watch-details mb-40">
                        <h2>Watch of Choice</h2>
                        <p>Enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse.</p>
                        <a href="shop.html" class="btn">Show Watches</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Watch Choice  End-->
    <!--? Shop Method Start-->
    <div class="shop-method-area">
        <div class="container">
            <div class="method-wrapper">
                <div class="row d-flex justify-content-between">
                    <div class="col-xl-4 col-lg-4 col-md-6">
                        <div class="single-method mb-40">
                            <i class="ti-package"></i>
                            <h6>Free Shipping Method</h6>
                            <p>aorem ixpsacdolor sit ameasecur adipisicing elitsf edasd.</p>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-6">
                        <div class="single-method mb-40">
                            <i class="ti-unlock"></i>
                            <h6>Secure Payment System</h6>
                            <p>aorem ixpsacdolor sit ameasecur adipisicing elitsf edasd.</p>
                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-6">
                        <div class="single-method mb-40">
                            <i class="ti-reload"></i>
                            <h6>Secure Payment System</h6>
                            <p>aorem ixpsacdolor sit ameasecur adipisicing elitsf edasd.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Shop Method End-->
</main>
<footer>
    <!-- Footer Start-->
    <div class="footer-area footer-padding">
        <div class="container">
            <div class="row d-flex justify-content-between">
                <div class="col-xl-3 col-lg-3 col-md-5 col-sm-6">
                    <div class="single-footer-caption mb-50">
                        <div class="single-footer-caption mb-30">
                            <!-- logo -->
                            <div class="footer-logo">
                                <a href="index.html"><img src="/resources/boot/img/logo/logo2_footer.png" alt=""></a>
                            </div>
                            <div class="footer-tittle">
                                <div class="footer-pera">
                                    <p>Asorem ipsum adipolor sdit amet, consectetur adipisicing elitcf sed do eiusmod tem.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-3 col-sm-5">
                    <div class="single-footer-caption mb-50">
                        <div class="footer-tittle">
                            <h4>Quick Links</h4>
                            <ul>
                                <li><a href="#">About</a></li>
                                <li><a href="#"> Offers & Discounts</a></li>
                                <li><a href="#"> Get Coupon</a></li>
                                <li><a href="#">  Contact Us</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-3 col-md-4 col-sm-7">
                    <div class="single-footer-caption mb-50">
                        <div class="footer-tittle">
                            <h4>New Products</h4>
                            <ul>
                                <li><a href="#">Woman Cloth</a></li>
                                <li><a href="#">Fashion Accessories</a></li>
                                <li><a href="#"> Man Accessories</a></li>
                                <li><a href="#"> Rubber made Toys</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-3 col-md-5 col-sm-7">
                    <div class="single-footer-caption mb-50">
                        <div class="footer-tittle">
                            <h4>Support</h4>
                            <ul>
                                <li><a href="#">Frequently Asked Questions</a></li>
                                <li><a href="#">Terms & Conditions</a></li>
                                <li><a href="#">Privacy Policy</a></li>
                                <li><a href="#">Report a Payment Issue</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Footer bottom -->
            <div class="row align-items-center">
                <div class="col-xl-7 col-lg-8 col-md-7">
                    <div class="footer-copy-right">
                        <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                            Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                            <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                    </div>
                </div>
                <div class="col-xl-5 col-lg-4 col-md-5">
                    <div class="footer-copy-right f-right">
                        <!-- social -->
                        <div class="footer-social">
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="https://www.facebook.com/sai4ull"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-behance"></i></a>
                            <a href="#"><i class="fas fa-globe"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Footer End-->
</footer>
<!--? Search model Begin -->
<div class="search-model-box">
    <div class="h-100 d-flex align-items-center justify-content-center">
        <div class="search-close-btn">+</div>
        <form class="search-model-form">
            <input type="text" id="search-input" placeholder="Searching key.....">
        </form>
    </div>
</div>
<!-- Search model end -->

<!-- JS here -->

<script src="/resources/boot/vendor/modernizr-3.5.0.min.js"></script>
<!-- Jquery, Popper, Bootstrap -->
<script src="/resources/boot/vendor/jquery-1.12.4.min.js"></script>
<script src="/resources/boot/js/popper.min.js"></script>
<script src="/resources/boot/js/bootstrap.min.js"></script>
<!-- Jquery Mobile Menu -->
<script src="/resources/boot/js/jquery.slicknav.min.js"></script>

<!-- Jquery Slick , Owl-Carousel Plugins -->
<script src="/resources/boot/js/owl.carousel.min.js"></script>
<script src="/resources/boot/js/slick.min.js"></script>

<!-- One Page, Animated-HeadLin -->
<script src="/resources/boot/js/wow.min.js"></script>
<script src="/resources/boot/js/animated.headline.js"></script>
<script src="/resources/boot/js/jquery.magnific-popup.js"></script>

<!-- Scrollup, nice-select, sticky -->
<script src="/resources/boot/js/jquery.scrollUp.min.js"></script>
<script src="/resources/boot/js/jquery.nice-select.min.js"></script>
<script src="/resources/boot/js/jquery.sticky.js"></script>

<!-- contact js -->
<script src="/resources/boot/js/contact.js"></script>
<script src="/resources/boot/js/jquery.form.js"></script>
<script src="/resources/boot/js/jquery.validate.min.js"></script>
<script src="/resources/boot/js/mail-script.js"></script>
<script src="/resources/boot/js/jquery.ajaxchimp.min.js"></script>

<!-- Jquery Plugins, main Jquery -->
<script src="/resources/boot/js/plugins.js"></script>
<script src="/resources/boot/js/main.js"></script>

</body>
</html>