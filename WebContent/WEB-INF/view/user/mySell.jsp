<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%
    List<NoticeDTO> rList = (List<NoticeDTO>) request.getAttribute("rList");

    if (rList == null) {
        rList = new ArrayList<NoticeDTO>();
    }

    int total = 0;
%>
<html>
<head>
    <title>나의 판매글 조회하기</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <script type="text/javascript">
        function doDetail(seq) {
            location.href="/noticeInfo.do?nSeq=" + seq;
        }

        $(document).ready(function() {

            var user_no = <%=SS_USER_NO%>;

            if (user_no == null) {
                Swal.fire({
                    title: '로그인 후 이용해 주세요.',
                    icon: 'info',
                    showConfirmButton: false,
                    timer: 2500
                }).then(val => {
                    if (val) {
                        location.href = "/logIn.do";
                    }
                });

            } else {
                // 회원 정보 가져오기
                $.ajax({
                url: "getUserAjax.do",
                type: "post",
                dataType: "JSON",
                success: function(json) {
                    console.log("json 데이터 : " + json);

                    var resHTML = "";


                    resHTML += '<li><p class="info">이름 : ' + json.user_name + '</li>';
                    resHTML += '<li><p class="info">핸드폰 번호 : ' + json.phone_no + '</li>';
                    resHTML += '<li><p class="info">주소지 : ' + json.addr + '</li>';
                    resHTML += '<li><p class="info">가입일 : ' + json.reg_dt + '</li>';

                    // $(".list cat-list").append(resHTML);
                    $("#userInfo").append(resHTML);
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

<!-- 마이페이지 메인 -->
<div class="slider-area ">
    <div class="single-slider slider-height2 d-flex align-items-center" style="margin-top:2px;">
        <div class="container">
            <div class="row">
                <div class="col-xl-12">
                    <div class="hero-cap text-center">
                        <h2 style="color: #3d1a63; font-family: 'Do Hyeon', sans-serif;"> My Page </h2>

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
                                 style="width:300px;height: 85px;"></h2>

                            <div class="blog_right_sidebar">
                        <aside class="single_sidebar_widget post_category_widget">
                            <br/>
                            <h4 class="widget_title mt-10" style="font-family: 'Noto Sans KR'">나의 회원정보</h4>
                            <br/>
                            <ul class="list cat-list" id="userInfo">
<%--                                <br/>--%>
<%--                                <div id="resHTML"></div>--%>

                            </ul>
                        </aside>
                            </div>

                        <a href="/updateUserForm.do" class="btn view-btn3">회원정보 수정하기</a>
                    </div>

                </div>
            </div>

            <hr/>
            <!-- Button -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">

                    <div class="section-tittle mb-70 text-center" >
                <aside class="single_sidebar_widget post_category_widget">
                    <h4 class="widget_title info" >나의 판매글</h4>
                    <br/>
                        <button type="button" id="del" value="삭제하기" class="btn btn-danger cen" style="display: block; margin: 0 auto;">삭제하기</button>
                </aside>
                    </div>
                </div>
            </div>

            <div class="row">
                <%
                    for(int i=0; i<rList.size(); i++) {
                        NoticeDTO rDTO = rList.get(i);

                        if (rDTO == null) {
                            rDTO = new NoticeDTO();
                        }

                        total++;
                %>
                <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <input type="radio" name="del_num" id="del_num" value="<%=rDTO.getGoods_no()%>"/>
                        <!-- 상품 이미지 -->
                        <div class="popular-img">
                            <img src="/resource/images/<%=rDTO.getImgs()%>" alt=""
                                 style="width:240px; height:240px; object-fit: contain; cursor: pointer" onclick="doDetail(<%=rDTO.getGoods_no()%>)">

                            <!-- hover 적용, 마우스 올릴 시 click me! 문구 표시 -->
                            <div class="img-cap">
                                <span>My Product!</span>
                            </div>

                        </div>

                        <div class="popular-caption">
                            <!-- 상품명 -->
                            <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                                <%=CmmUtil.nvl(rDTO.getGoods_title())%>
                            </a></h3>

                            <!-- 가격 -->
                            <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');"><%=CmmUtil.nvl(rDTO.getGoods_price())%></a></h3>

                        </div>
                    </div>
                </div>
                <% } %>

            </div>
            <!-- end row -->


        </div>
    </div>
    <!-- 상품 목록 일부 보여주기(index) 끝 -->

</main>

<style>
    .info {
        font-family: 'Noto Sans KR';
        font-size: 20px;
        font-weight: 400;
    }
</style>
<script type="text/javascript">
    // 삭제 버튼을 눌렀을때, 판매글 번호를 받아오고 confirm을 통해 재확인
    $("#del").on("click", function() {
        var num = document.getElementById("del_num").value;
        console.log("가져온 판매글 번호 : " + num);
        var bool = $("input[name=del_num]:radio").is(":checked");
        console.log(bool);

        if (bool == true) {
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "네!",
            cancelButtonText: "아니오"
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: "/delMySell.do",
                    type: "post",
                    data: {
                        "del_num": num
                    },
                    dataType: "JSON",
                    success: function (res) {
                        console.log("res : " + res);
                        if (res == 1) {
                            Swal.fire("삭제에 성공했습니다.", '', 'success');
                            window.location.reload();
                        } else if (res == 0) {
                            Swal.fire("삭제에 실패했습니다.", '', 'error');
                            return false;
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }

                })
            } else if (result.isCancled) {
                return false;
            }
        })
    } else if (bool==false) {
            Swal.fire('삭제할 상품을 선택해 주세요', '', 'info');

    }
    }
        )

</script>

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File Start -->
<%@ include file="../include/jsFile.jsp"%>
<!-- include JS File End -->

</body>
</html>
