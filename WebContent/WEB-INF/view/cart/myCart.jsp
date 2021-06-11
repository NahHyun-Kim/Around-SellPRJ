<%@ page import="poly.dto.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%
    List<CartDTO> rList = (List<CartDTO>) request.getAttribute("rList");
    if (rList == null) {
        rList = new ArrayList<CartDTO>();
    }

    int total = 0;
%>
<html>
<head>
    <title>관심상품</title>
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

    <!-- 관심상품 표시하는 란 -->
    <div class="slider-area ">
        <div class="single-slider slider-height2 d-flex align-items-center" style="margin-top:2px;">
            <div class="container">
                <div class="row">
                    <div class="col-xl-12">
                        <div class="hero-cap text-center">
                            <h2 style="font-family: 'Do Hyeon', sans-serif; color: #3d1a63;"> MY FAVORITE! </h2>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 관심상품 문구 End -->

    <main>

        <!-- 장바구니 목록 보여주기 시작 -->
        <div class="popular-items section-padding30">
            <!-- container 시작 -->
            <div class="container">

                <!-- Section tittle2 (New 아이템 표시!) -->
                <div class="row justify-content-center">
                    <div class="col-xl-7 col-lg-8 col-md-10">
                        <div class="section-tittle mb-70 text-center" >

                            <h2><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                     style="width:300px;height: 75px;"></h2>
                            <h3><div id="cartCnt"></div></h3>
                            <div id="chk" style="font-size: 18px; font-weight: bold;"><input name="allCheck" type="checkbox" id="allCheck"/>&nbsp;전체 선택</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <%
                        for(int i=0; i<rList.size(); i++) {
                            CartDTO rDTO = rList.get(i);

                            if (rDTO == null) {
                                rDTO = new CartDTO();
                            }

                            total++;
                    %>
                    <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                        <div class="single-popular-items mb-50 text-center">

                            <!-- 상품 이미지 -->
                            <div class="popular-img">
                                <img src="/resource/images/<%=rDTO.getImgs()%>" alt=""
                                     style="width:240px; height:240px; object-fit: contain; cursor: pointer" onclick="doDetail(<%=rDTO.getGoods_no()%>)">

                                <!-- hover 적용, 마우스 올릴 시 click me! 문구 표시 -->
                                <div class="img-cap">
                                    <span>Favorite!</span>
                                </div>

                            </div>

                            <div class="popular-caption">
                                <!-- 상품명 -->
                                <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                                    <%=CmmUtil.nvl(rDTO.getGoods_title())%>
                                </a></h3> check!&nbsp;<input name="RowCheck" type="checkbox" id="del" value="<%=rDTO.getGoods_no()%>"/>

                                <!-- 가격 -->
                                <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');"><%=CmmUtil.nvl(rDTO.getGoods_price())%></a></h3>

                            </div>
                        </div>
                    </div>
                    <% } %>

                </div>
                <!-- end row -->

                <!-- 관심상품 삭제 Button -->
                <div class="row justify-content-center">
                    <div class="room-btn pt-70" style="padding-top: 5px;">
                        <a href="javascript:deleteValue()" class="btn view-btn1 font">상품 삭제!</a>
                        <a href="/searchList.do" class="btn view-btn1 font">판매글 보기</a>

                    </div>
                </div>

            </div>
        </div>
        <!-- 상품 목록 일부 보여주기(index) 끝 -->

        <input type="hidden" id="user_no" value="<%=SS_USER_NO%>"/>
    </main>

<script type="text/javascript">

    var res = document.getElementById("cartCnt");
    var total = (<%=total%>);

    console.log("받아온 판매글 개수 : " + total);
    // console.log("String으로 변환되지 않는지? : " + typeof total);

    // 검색 결과가 없다면, 검색 결과가 없다는 멘트와 함께 상품 보러가기 페이지로 이동 링크를 띄운다.
    if (total == 0) {

        var resultMent = '<hr/><span class="font" style="font-size: 20px;"><br/>' + "관심상품이 없습니다."  + "<br/><br/></span>"
         + "<span style='color: blue'>" +
            '<div class="row justify-content-center"><div class="room-btn pt-70" style="padding-top: 5px;"><a href="/searchList.do" class="btn view-btn1 font">상품 보러가기</a></span> </div>  </hr>';

        console.log("관심상품 멘트 : " + resultMent);

        // 상품이 없다면, 상품이 있을때 표시하는 체크박스와 삭제 버튼을 표시하지 않음.
        $(".btn").hide();
        $("#chk").hide();

        res.innerHTML = resultMent;
    } else if (total != 0) {

        // 총 상품 건수와 함께, 판매글 목록을 표시함
        var resultMent = "총 " + "<span style='color:red'>" + "<%=total%>" + "</span>" + "건의 상품";

        console.log("관심상품 멘트 : " + resultMent);

        res.innerHTML = resultMent;
    }

    var user_no = document.getElementById("user_no").value;
    console.log("받아온 회원 번호 : " + user_no);

    // 체크박스 선택에 따라 전체 선택, 전체 해제, 다중 삭제 구현
    var chkObj = document.getElementsByName("RowCheck");
    var rowCnt = chkObj.length;


    //if ($("input[name='allCheck']").is(":checked") == true){

    // 전체 선택을 클릭한다면, 모든 rowCheck의 체크박스 value를 checked 로 변경
    $("input[name='allCheck']").click(function() {
        var chk_listArr = $("input[name='RowCheck']");
        for (var i=0; i<chk_listArr.length; i++) {
            chk_listArr[i].checked = this.checked;
        }
    });

    // 특정 체크박스를 선택하면, 모두 선택된 경우 allCheck를 활성화한다.
    // rowCnt는 전체 RowCheck의 length로 계산한다.(개수)
    $("input[name='RowCheck']").click(function() {
        if($("input[name='RowCheck']:checked").length == rowCnt) {
            $("input[name='allCheck']")[0].checked = true;

        } else {
            $("input[name='allCheck']")[0].checked = false;
        }
    });

    function deleteValue() {

        var valueArr = new Array();
        var list = $("input[name='RowCheck']");


        for(var i=0; i<list.length; i++) {
            if (list[i].checked){ //선택되어 있으면 배열에 값을 저장
                valueArr.push(list[i].value);

            }
        }

        console.log("배열에 담은 값 : " + valueArr);

        // 선택된 값이 없다면,
        if (valueArr.length == 0) {
            Swal.fire('선택된 관심상품이 없습니다.','','warning');
        }
        else {

            Swal.fire({
                title: '정말 삭제하시겠습니까?',
                icon: "question",
                showCancelButton: true,
                confirmButtonText: "네!",
                cancelButtonText: "아니오"
            }).then((result) => {
                if (result.isConfirmed) {

                    $.ajax({
                        url: "/deleteCart.do",
                        type: "post",
                        // 배열 형태를 넘기기 위해 사용(traditional 속성)
                        // tranditional: true,
                        data: {
                            "valueArr" : valueArr
                        },
                        // 삭제에 성공했다면, 삭제 성공 알림 및 상품을 다시 보러 갈 것을 confirm
                        success: function(data) {
                            if (data == 1) {

                                Swal.fire({
                                    title : 'Around-Sell',
                                    text : '관심상품을 삭제하였습니다. 다른 상품을 보러 가시겠습니까?',
                                    icon : "success",
                                    showCancelButton : true,
                                    confirmButtonText : "네! ",
                                    cancelButtonText : "아니오, 그냥 볼래요"
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        location.href = "/searchList.do"
                                    } else {
                                        window.location.reload();
                                    }
                                })
                            } else {
                                Swal.fire('삭제에 실패했습니다.','','error');
                            }
                        }
                    });
                } else if (result.isCancled) {
                    return false;
                }
            })
        }
    }

</script>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>

    <!-- include Footer -->
    <%@ include file="../include/footer.jsp"%>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>
