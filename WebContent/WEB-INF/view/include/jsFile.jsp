<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--script src="/resources/boot/vendor/modernizr-3.5.0.min.js"></script>-->
<!-- Jquery, Popper, Bootstrap -->
<!--<script src="/resources/boot/vendor/jquery-1.12.4.min.js"></script>-->
<!-- sweet alert2 -->
<script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

<!-- 메뉴바 검색 지원 -->
<script type="text/javascript">
    function search() {
        let keyword = document.getElementById("search-input").value;
        window.location.assign("/searchList.do?nowPage=1&cntPerPage=9&searchType=T&keyword=" + keyword);
    }
</script>