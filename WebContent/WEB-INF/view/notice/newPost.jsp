<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>판매글 등록</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <script type="text/javascript">
        $(document).ready(function() {
            console.log("userno : " + <%=SS_USER_NO%>);

            var user_no = "<%=SS_USER_NO%>";

            if (user_no == "null") {
                Swal.fire({
                    title: 'Around-Sell',
                    text: '로그인한 사용자만 판매글을 등록할 수 있습니다. 로그인 하시겠습니까?',
                    icon: "success",
                    confirmButtonText: "네!",
                    showCancelButton: false,
                    showDenyButton: true,
                    denyButtonText: "아니오",
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = "/logIn.do"
                    } else if (result.isDenied) {
                        location.href = "/getIndex.do"
                    }
                })

            }})

    //전송시 유효성 체크
    function doSubmit(f){
        if(f.goods_title.value == ""){
            Swal.fire('Input Title','제목을 입력해 주세요!','warning');
            f.goods_title.focus();
            return false;
        }
        if(calBytes(f.goods_title.value) > 200){
            Swal.fire('Too Long','최대 200Bytes까지 입력 가능합니다.','warning');
            f.goods_title.focus();
            return false;
        }
        if(f.goods_detail.value == ""){
            Swal.fire('Input Detail','상품 설명을 입력해 주세요!','warning');
            f.goods_detail.focus();
            return false;
        }
        if(calBytes(f.goods_detail.value) > 5000){
            Swal.fire('Too Long','최대 5000Bytes까지 입력 가능합니다.','warning');
            f.goods_detail.focus();
            return false;
        }
        if (f.goods_price.value == ""){
            Swal.fire('Input Price','상품 가격을 입력해 주세요!','warning');
            f.goods_price.focus();
            return false;
        }
        if (f.goods_addr.value == ""){
            Swal.fire('Input Addr','상호명을 입력해 주세요!','warning');
            f.goods_addr.focus();
            return false;
        }
        if (f.category.value == "") {
            Swal.fire('Select Category','카테고리를 선택해 주세요!','warning');
            f.category.focus();
            return false;
        }
    }

    //글자 길이 바이트 단위로 체크하기(바이트값 전달)
    function calBytes(str){
        var tcount = 0;
        var tmpStr = new String(str);
        var strCnt = tmpStr.length;
        var onechar;
        for (i=0;i<strCnt;i++){
            onechar = tmpStr.charAt(i);
            if (escape(onechar).length > 4){
                tcount += 2;
            }else{
                tcount += 1;
            }
        }
        return tcount;
    }
</script>
</head>

<style>
    #hide {
        width: 300px; height: 350px; font-family: 'Poor Story'; background-image: url('../../../resources/boot/img/logo/cart.gif'); background-size: cover;
    }

    #maphide {
        width: 300px; height: 350px; font-family: 'Poor Story'; background-image: url('../../../resources/boot/img/logo/maps.gif'); background-size: cover;
    }
</style>
<!-- body가 실행될 때, 로그인 여부를 실행하기 위해 onLoad() 함수 호출 -->
<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->


    <!-- 새로운 상품 -->
    <div class="slider-area ">
        <div class="single-slider slider-height2 d-flex align-items-center" style="margin-top:2px;">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12">
                        <div class="hero-cap text-center">
                            <h2 style="font-family: 'Do Hyeon', sans-serif; color: #3d1a63;"> NEW PRODUCT! </h2>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <main>

        <!-- REG area -->
        <!--===============posting Area =================-->
        <section class="login_part section_padding ">
            <div class="container">
                <div class="row align-items-center">

                    <div class="col-lg-6 col-md-6"  style="border-right: 1px dotted #d0a7e4;">
                        <div class="login_part_text text-center" style="margin: 0 auto;">
                            <div class="login_part_text_iner" style="margin-top: 5px;">
                                <div class="select_img"><img src=""/></div>

                                <br/>
                                <hr/>
                                <!-- 도로명주소 검색으로 선택한 판매 주소지를 표시하여 나타내는 지도(시각화 확인) -->
                                <div id="map" style="border-radius:10%; margin: 0 auto;"></div>
                                <div id="hide">Input Product Image!</div>
                                <hr/>
                                <div id="maphide">주소지를 선택해 주세요!</div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5 col-md-5">
                        <div class="login_part_form">
                            <div class="login_part_form_iner">
                                <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                                <form name="f" action="/noticeInsert.do" method="post" onsubmit="return doSubmit(this);" enctype="multipart/form-data" class="row contact_form">

                                    <!-- 이미지 등록 -->
                                    <input type="file" id="img" name="fileUpload" class="btn view-btn font" required/>

                                    <!-- 파일을 첨부하면, 판매글 작성 화면에서 이미지인지 보여줌 -->
                                    <script>
                                        $("#img").change(function() {
                                            if(this.files && this.files[0]) {
                                                var reader = new FileReader;
                                                reader.onload = function(data) {
                                                    $(".select_img img").attr("src",data.target.result).width(300);
                                                }
                                                $("#hide").hide();
                                                reader.readAsDataURL(this.files[0]);
                                            }
                                        });
                                    </script>

                                    <!-- 상품명 등록(제목으로 표시) -->
                                    <div class="col-md-12 form-group p_star">
                                        <br/>
                                        <label for="goods_title" class="font text-center">상품명</label>
                                        <input class="form-control font" type="text" name="goods_title" id="goods_title" placeholder="상품명을 입력해 주세요." />
                                    </div>


                                    <!-- 상품 설명 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="goods_detail" class="font text-center">상품 설명</label>
                                        <input class="form-control font" type="textarea" name="goods_detail" id="goods_detail" placeholder="상품 설명을 입력해 주세요." style="height: 100px;">
                                    </div>

                                    <!-- 상품 가격 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="goods_price" class="font text-center">상품 가격</label>
                                        <input class="form-control font" input type="text" name="goods_price" id="goods_price" placeholder="가격을 입력해 주세요 ex)6000" style="margin-top: 10px;">
                                    </div>

                                    <!-- 상품이 판매되는 상호명 또는 간략한 주소 입력(간략 ex) 아리따움 강서구청점) -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="goods_addr" class="font text-center">판매 상호명</label>
                                        <input class="form-control font" name="goods_addr" id="goods_addr" placeholder="판매하는 상호명을 입력해 주세요." style="margin-top: 10px;">
                                        <div class="check_font" id="phone_check"></div>
                                    </div>

                                    <!-- 주소 입력(도로명주소 이용) -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="sample5_address" class="font text-center">주소지 검색</label>
                                        <input class="form-control font" type="text" name="goods_addr2" id="sample5_address" placeholder="주소를 검색해 주세요." required style="margin-top: 10px;">
                                        <input type="button" class="btn_3 font" onclick="sample5_execDaumPostcode()" value="주소 검색"/>
                                    </div>


                                    <!-- 카테고리 입력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <select name="category" id="category">
                                            <option value="" selected disabled hidden>=카테고리=</option>
                                            <option value="화장품">화장품</option>
                                            <option value="패션">패션</option>
                                            <option value="잡화">잡화</option>
                                            <option value="식품">식품</option>
                                            <option value="가전">가전</option>
                                            <option value="건강의료">건강/의료</option>
                                        </select>
                                    </div>

                                    <div class="col-md-12 form-group">

                                        <!-- 판매글 등록 버튼 -->
                                        <button type="submit" value="submit" class="btn_3 font">
                                            판매글 등록!
                                        </button>
                                        <a class="lost_pass font" href="/searchList.do">판매글 목록으로</a>
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
        <!--================posting area end =================-->
    </main>

    <!-- 도로명주소 API js 파일-->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
    <!--<script type="text/javascript" src="/resource/js/addrAPI2.js?ver=1"></script>-->
    <script type="text/javascript">

        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
            mapOption = {
                center: new daum.maps.LatLng(37.537187, 127.005476), // 지도의 중심좌표
                level: 3 // 지도의 확대 레벨, 숫자가 작을수록 확대하여 보여준다.
            };

        //지도를 미리 생성
        var map = new daum.maps.Map(mapContainer, mapOption);
        //주소-좌표 변환 객체를 생성
        var geocoder = new daum.maps.services.Geocoder();
        //마커를 미리 생성
        var marker = new daum.maps.Marker({
            position: new daum.maps.LatLng(37.537187, 127.005476),
            map: map
        });

        function sample5_execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {

                    // 주소 검색 팝업 띄울 시, 영문 링크명 지정
                    popupName: 'postcodePopup';

                    var addr = data.address; // 최종 주소 변수

                    // 주소 정보를 해당 필드에 넣는다.
                    document.getElementById("sample5_address").value = addr;

                    // 주소로 상세 정보를 검색
                    geocoder.addressSearch(data.address, function(results, status) {
                        // 정상적으로 검색이 완료됐으면
                        if (status === daum.maps.services.Status.OK) {

                            var result = results[0]; //첫번째 결과의 값을 활용

                            // 해당 주소에 대한 좌표를 받아서
                            var coords = new daum.maps.LatLng(result.y, result.x);

                            // 마커 이미지의 이미지 주소
                            var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

                            // 마커 이미지의 이미지 크기
                            var imageSize = new kakao.maps.Size(24, 35);

                            // 마커 이미지를 생성
                            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

                            var marker = new kakao.maps.Marker({
                                map: map,
                                position: coords,
                                image : markerImage //마커 이미지
                            });

                            // 기존 표시하던 이미지를 숨긴다.
                            $("#hide").hide();
                            $("#maphide").hide();

                            // 지도를 보여준다.
                            mapContainer.style.display = "block";
                            map.relayout();
                            // 지도 중심을 변경한다.
                            map.setCenter(coords);
                            // 마커를 결과값으로 받은 위치로 옮긴다.
                            marker.setPosition(coords)
                        }
                    });
                },
                // 주소 검색 테마 색상 지정하여 변경
                theme: {
                    bgColor: "#FDE2FC", //바탕 배경색
                    searchBgColor: "#D7BAD9", //검색창 배경색
                    //contentBgColor: "", //본문 배경색(검색결과,결과없음,첫화면,검색서제스트)
                    pageBgColor: "#F9D2FC", //페이지 배경색
                    //textColor: "", //기본 글자색
                    queryTextColor: "#FFFFFF" //검색창 글자색
                    //postcodeTextColor: "", //우편번호 글자색
                    //emphTextColor: "", //강조 글자색
                    //outlineColor: "", //테두리
                },


            }).open();
        }

    </script>

    <!-- css 파일 -->
    <link rel="stylesheet" href="/resource/css/notice.css"/>
    <link rel="stylesheet" href="/resources/boot/css/nice-select.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js?ver=1"></script>

    <!-- include JS File -->
    <%@ include file="../include/jsFile.jsp"%>
</body>
</html>
