<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Iterator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>최근 본 상품</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <script type="text/javascript">
        // 페이지가 로딩될 때, 최근 본 상품을 불러옴(추후 mainPage에 로그인시 띄울까 고민중)
        $(document).ready(function() {
            // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근검색어 불러오기 진행
            var userno = <%=SS_USER_NO%>;
            console.log("받아온 회원번호 : " + userno);

            if (userno != null) {

                $.ajax({
                    url: "/getGoods.do",
                    type: "post",
                    // 꼭 JSON 형태로 데이터 받아올 것!
                    dataType: "JSON",
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    success: function(data) {

                        // 검색어 값들을 for문을 통해 저장
                        console.log("가져오기 성공!");
                        console.log(data);
                        console.log("타입 : " + typeof data);

                        // 최근에 저장된 데이터부터 불러와야하기 때문에 .reverse()로 배열 순 뒤집기
                        var reverse = data.reverse();
                        console.log("reverse data : " + reverse);

                        // 최근 본 상품 데이터, 설명 html을 담을 변수 선언
                        let recentlyGoods = "";

                        // 최근 본 상품을 출력할 개수(최근 5개로 지정)
                        var cnt = 5;
                        var len = reverse.length;

                        recentlyGoods += '<div class="font">최근 본 상품</div>';

                        // 데이터가 5개가 넘었을 경우, 총 건수에서 최근 5건만 표시되었음을 알림
                        if (cnt < len) {
                            recentlyGoods += "<div>총 " + len + "건의 결과, 최근 " + cnt + "건을 표시합니다.</div> <hr/>";

                        // 최근 본 상품이 없는 경우, 안내 멘트와 상품 보러가기 링크를 안내
                        } else if (len==0) {
                            recentlyGoods = '<span class="font">최근 본 상품이 없습니다. <hr/> <a class="font" href="/searchList.do">상품 보러가기</a></span>';

                            $("#recentlyGoods").html(recentlyGoods);
                            $("#recentlyGoods").show();

                        } else {
                            recentlyGoods += "<div>총 " + len + "건의 상품</div> <hr/>";
                        }

                        // 최근 본 상품 데이터가 있다면, 최근 본 상품 최대 5개까지 불러옴
                        if (len != 0) {
                            for (var i=0; i<len; i++) {

                                // .으로 접근 가능한 json 객체로 변환(JSON.parse)
                                var obj =JSON.parse(reverse[i]);

                                recentlyGoods += '<div class="col" style="margin: 0 auto;">';
                                recentlyGoods += '<a class="title" href="/noticeInfo.do?nSeq=' + obj.goods_no + '">';
                                recentlyGoods +=  '<img src="${pageContext.request.contextPath}/resource/images/' + obj.imgs + '" style="width: 150px; height: 150px; object-fit: contain" alt="이미지 불러오기 실패"/>';
                                recentlyGoods += '<br/>' + obj.goods_title + "</a> </div> <hr/>";

                                if (i >= 4) {
                                    break;
                                }
                            }
                            // 최근 본 상품 목록에 담음
                            $("#recentlyGoods").html(recentlyGoods);
                            $("#recentlyGoods").show();
                        }
                    }
                })
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

    <!-- 관심상품 표시하는 란 -->
    <div class="slider-area ">
        <div class="single-slider slider-height2 d-flex align-items-center" style="margin-top:2px;">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12">
                        <div class="hero-cap text-center">
                            <h2 style="color: #3d1a63; font-family: 'Do Hyeon', sans-serif;"> 최근 본 상품 </h2>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <main>

        <!-- 상품 목록 일부 보여주기(index) 시작 -->
        <div class="popular-items section-padding30">
            <!-- container 시작 -->
            <div class="container">

                <!-- Section tittle1 (지역정보, 날씨정보 표시) -->
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">

                        <div class="section-tittle mb-70 text-center" >
                            <h2><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                     style="width:300px;height: 75px;"></h2>
                            <div id="recentlyGoods" style="margin: 0 auto;"></div>
                        </div>
                    </div>
                </div>

                <!-- Button -->
                <div class="row justify-content-center">
                    <div class="room-btn pt-70" style="padding-top: 5px;">
                        <a href="/searchList.do" class="btn view-btn1 font">상품 보러가기</a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <style>
        .title {
            color: black;
            font-family: 'Noto Sans KR', sans-serif;
        }

        #recentlyGoods {
            color: black;
            font-family: 'Noto Sans KR', sans-serif;
            font-size: 20px;
        }

        .font {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->

</body>
</html>