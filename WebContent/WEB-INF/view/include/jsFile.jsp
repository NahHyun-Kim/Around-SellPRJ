<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!--script src="/resources/boot/vendor/modernizr-3.5.0.min.js"></script>-->
<!-- Jquery, Popper, Bootstrap -->
<!--<script src="/resources/boot/vendor/jquery-1.12.4.min.js"></script>-->

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

    <!-- 장바구니 담기 시 유효성 체크 + 장바구니 담기 -->
    // 판매글 목록에서 관심상품 담기 눌렀을 때
    function addCart(goods_no, user_no) {
        console.log("받아온 상품번호 : " + goods_no);
        console.log("게시글 올린 회원번호 : " + user_no);

        var ss_user_no = <%=SS_USER_NO%>;

        // 로그인하지 않은 상태로 장바구니 담기를 클릭했다면
        if (ss_user_no == null) {
            Swal.fire({
                title : 'Around-Sell',
                text : '관심상품 담기는 로그인한 회원만 가능합니다. 로그인 후 이용하시겠습니까?',
                icon : "warning",
                showCancelButton : true,
                confirmButtonText : "네! 로그인",
                cancelButtonText : "아니오, 그냥 볼래요"
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "/logIn.do"
                } else if (result.isCancled) {
                    return false;
                }
            })

        } else if (user_no == <%=SS_USER_NO%>) {
            Swal.fire('본인이 등록한 상품은 관심상품 등록이 불가능합니다','','warning');
        } else {

            console.log("장바구니 담기 진행!");
            $.ajax({
                url: "/cartChk.do",
                type: "post",
                data: {
                    "gn": goods_no,
                    "user_no": ss_user_no
                },
                dataType: "JSON",
                success: function (res) {

                    console.log("중복이면 1, 아니면 0 : " + res);

                    if (res > 0) {
                        Swal.fire('이미 등록된 상품입니다.', '', 'warning');
                        return false;
                    } else if (res == 0)// 등록되지 않은 상품이라면,
                    { // insert 실행
                        $.ajax({
                            url: "/insertCart.do",
                            type: "post",
                            data: {
                                "gn": goods_no
                                //$("#gn").val
                            },
                            dataType: "JSON",
                            success: function (data) {
                                // insertCart가 성공했을 경우, res에 1을 반환
                                if (data == 1) {

                                    Swal.fire({
                                        title: 'Around-Sell',
                                        text: '관심상품 등록에 성공했습니다. 지금 확인하시겠습니까?',
                                        icon: "success",
                                        showCancelButton: true,
                                        confirmButtonText: "네! 확인할래요",
                                        cancelButtonText: "나중에 볼래요"
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            location.href = "/myCart.do"
                                        } else if (result.isCancled) {
                                            return false;
                                        }
                                    })

                                } else {
                                    Swal.fire("등록에 실패했습니다", '', 'error');
                                    return false;
                                }
                            },
                            // error catch
                            error: function (jqXHR, textStatus, errorThrown) {
                                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                                console.log(errorThrown);
                            }
                        })
                    }
                }

            })
        }}


    // 상호명으로 검색 누를시
    function searchLocation(loc, seq) {

        Swal.fire({
            text : '해당 상호명으로 검색을 진행하시겠습니까?',
            icon : "question",
            confirmButtonText : "네!",
            confirmButtonColor : 'skyblue',
            showDenyButton :  true,
            denyButtonText : "상품 정보 볼래요",
            denyButtonColor : '#d0a7e4'

        }).then((result) => {
            if (result.isConfirmed) {
                location.href = "/searchList.do?nowPage=1&cntPerPage=9&searchType=L&keyword=" + loc;

            } else if (result.isDenied) {
                doDetail(seq);
            }
        })
    }

    // 관심상품, 최근 본 상품(회원에게만 제공되어 로그인 여부 유효성을 체크함)
    var user_no = <%=SS_USER_NO%>;
    function cartChk() {

        console.log("user_no : " + user_no);

        if (user_no == null) {
            Swal.fire({
                title: 'Around-Sell',
                text: '관심상품 이용은 회원만 가능합니다. 로그인 하시겠습니까?',
                icon: "info",
                showCancelButton: true,
                confirmButtonText: "네! 로그인",
                cancelButtonText: "아니오"
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "/logIn.do"
                } else if (result.isCancled) {
                    return false;
                }
            })
        } else {
            location.href = "/myCart.do";
        }
    }

    function seeChk() {

        console.log("user_no : " + user_no);

        if (user_no == null) {
            Swal.fire({
                title: 'Around-Sell',
                text: '최근 본 상품 조회는 회원만 가능합니다. 로그인 하시겠습니까?',
                icon: "info",
                showCancelButton: true,
                confirmButtonText: "네! 로그인",
                cancelButtonText: "아니오"
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "/logIn.do";
                } else if (result.isCancled) {
                    return false;
                }

            });
        } else {
            location.href = "/mySee.do";
        }

    }

    // 개인정보 수정 버튼을 눌렀을때, 비밀번호를 확인하고 들어가는 Swal
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
                            console.log("에러 발생! \n" + textStatus + ":" + errorThrown);
                            console.log(errorThrown);
                        }
                    })
                }
            }
        })
    }

    function formChk() {
        console.log("user_no : " + user_no);

        if (user_no == null) {
            Swal.fire({
                title: 'Around-Sell',
                text: '판매글 등록은 로그인한 사용자만 가능합니다. 로그인 하시겠습니까?',
                icon: "info",
                showCancelButton: true,
                confirmButtonText: "네! 로그인",
                cancelButtonText: "아니오"
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "/logIn.do";
                } else if (result.isCancled) {
                    return false;
                }

            });
        } else {
            location.href = "/noticeForm.do";
        }
    }

    // 숫자 형태만 입력되도록 함수 작성
    $(document).on("keyup", "input:text[numberOnly]", function() {
        $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
    });
</script>