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
    <title>Around-Sell 마이페이지</title>
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

                    resHTML += '<div class="col-md-12 form-group p_star"><label for="user_name" class="font">회원 이름</label><input class="form-control font" id="user_name" type="text" value="' + json.user_name + '" readOnly/></div>';
                    resHTML += '<div class="col-md-12 form-group p_star"><label for="phone_no" class="font">핸드폰 번호</label><input class="form-control font" id="phone_no" type="text" value="' + json.phone_no + '" readOnly/></div>';
                    resHTML += '<div class="col-md-12 form-group p_star"><label for="addr" class="font">가입 주소지</label><input class="form-control font" id="addr" type="text" value="' + json.addr + '" readOnly/></div>';
                    resHTML += '<div class="col-md-12 form-group p_star"><label for="reg_dt" class="font">가입일</label><input class="form-control font" id="reg_dt" type="text" value="' + json.reg_dt + '" readOnly/></div>';

                    $("#infoInput").html(resHTML);
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
                            <div id="infoInput"></div>

                            </ul>
                        </aside>
                            </div>

                        <a class="btn view-btn3 font" style="color: white;" onclick="doPassword()">회원정보 수정하기</a>

                        <script type="text/javascript">
                            function doPassword() {
                                            Swal.fire({
                                                icon: 'info',
                                                title: '비밀번호를 입력해 주세요.',
                                                input: 'password',
                                                customClass: {
                                                    validationMessage: 'my-validation-message',
                                                },

                                                preConfirm: (value) => {
                                                    if (!value) {
                                                        Swal.showValidationMessage(
                                                            '<i class="fa fa-info-circle"></i> 비밀번호를 입력해 주세요!'
                                                        )
                                                        return false;
                                                    }
                                                },

                                                inputValidator: (value) => {
                                                    // 비밀번호가 입력되었다면, ajax로 기존 비밀번호와 일치하는지 확인
                                                    if (value) {

                                                        $.ajax({
                                                            url: "/myPwdChk.do",
                                                            type: "post",
                                                            dataType: "JSON",
                                                            data: {
                                                                "password": value
                                                            },
                                                            success: function(data) {
                                                                console.log("일치하면 1, 다르면 0 : " + data);
                                                                // data == 1 (기존 비밀번호와 일치하면 수정 페이지로 이동)

                                                                if (data == 1) {
                                                                    console.log("비밀번호 일치!");
                                                                    location.href = "/updateUserForm.do";

                                                                    // 일치하지 않으면 다시 입력할 것을 알림
                                                                } else if (data == 0) {
                                                                    Swal.fire('비밀번호를 다시 입력해 주세요!','','error');
                                                                    return false;
                                                                }
                                                            },
                                                            error: function (jqXHR, textStatus, errorThrown) {
                                                                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                                                                console.log(errorThrown);
                                                            }
                                                        })
                                                    }
                                                }
                                            })
                            }
                        </script>

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
                    <div class="font" id="noSell"></div>
                        <button type="button" id="del" value="삭제하기" class="btn btn-danger font" style="display: block; margin: 0 auto;">삭제하기</button>
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
                        <input type="radio" name="del_num" id="del_num" class="mb-15" value="<%=rDTO.getGoods_no()%>"/>
                        <!-- 상품 이미지 -->
                        <div class="popular-img">
                            <img src="/resource/images/<%=rDTO.getImgs()%>" alt=""
                                 style="width:240px; height:240px; object-fit: contain; cursor: pointer" onclick="doDetail(<%=rDTO.getGoods_no()%>)">

                            <!-- hover 적용, 마우스 올릴 시 click me! 문구 표시 -->
                            <div class="img-cap">
                                <span onclick="doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>')">My Product!</span>
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
        font-size: 17px;
        font-weight: 400;
    }
</style>
<script type="text/javascript">

    var sellCnt = <%=total%>;
    console.log("나의 판매글 개수 : " + sellCnt);

    // 판매글이 없다면, 판매글이 없다는 멘트와 함께 게시글 등록하기 버튼을 띄움
    if (sellCnt == 0) {
        $("#del").hide();

        var noMent = "";
        noMent += '<p class="info">등록한 판매글이 없습니다. </p><br/>';
        noMent += '<a href="/noticeForm.do" class="btn view-btn3 font">판매글 등록하기</a>'
        $("#noSell").html(noMent);
    }

    // 삭제 버튼을 눌렀을때, 판매글 번호를 받아오고 confirm을 통해 재확인
    $("#del").on("click", function() {
        var num = document.getElementById("del_num").value;
        console.log("가져온 판매글 번호 : " + num);
        var bool = $("input[name=del_num]:radio").is(":checked");
        console.log(bool);

        if (bool == true) {Swal.fire({
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
                            Swal.fire({
                                title: '삭제에 성공했습니다.',
                                icon: 'info'
                            }).then(value => {
                                if (value) {
                                    window.location.reload();
                                }
                            })

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
