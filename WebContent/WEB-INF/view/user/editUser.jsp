<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="java.util.List" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
    if (rDTO == null) {
        rDTO = new UserDTO();
    }

    System.out.println("회원 정보 불러왔는지 테스트 : " + EncryptUtil.decAES128CBC(rDTO.getUser_email()));

    int getLogin = 1;

    if (!(SS_USER_NO.equals(rDTO.getUser_no()))) {
        getLogin = 2;
    }
%>
<html>
<head>
    <title>Around-Sell 회원정보 수정</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>

    <style>
        #map {
            width: 350px;
            height: 200px;
            margin-top: 10px;
            display: none
        }
    </style>
<%--    <script type="text/javascript">--%>

<%--       $(document).ready(function() {--%>
<%--            var validChk = <%=getLogin%>;--%>
<%--            console.log("본인이 접근했는지 : " + validChk);--%>

<%--            if (validChk == 2) {--%>
<%--                Swal.fire({--%>
<%--                    title: '로그인 후 이용해 주세요',--%>
<%--                    icon: 'warning',--%>
<%--                    setTimeout: '2500',--%>
<%--                    showConfirmButton: false--%>
<%--                }).then(value => {--%>
<%--                    if (value) {--%>
<%--                        location.href = "/logIn.do";--%>
<%--                    }}--%>
<%--                    )--%>
<%--            }--%>
<%--        })--%>
<%--    </script>--%>
</head>
<body>
<!-- preloader -->
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->

<!-- wordCloud 디자인용(로그인, 회원가입, 비밀번호 찾기 시 사용) -->
<%@ include file="../include/wordcloudForDesign.jsp"%>

<main>

    <!-- REG area -->
    <!--================REG_PART Area =================-->
    <section class="login_part section_padding ">
        <div class="container">
            <div class="row align-items-center">

                <div class="col-lg-6 col-md-6"  style="border-right: 1px dotted #d0a7e4;">
                    <div class="login_part_text text-center">
                        <div class="login_part_text_iner" style="margin-top: 5px;">
                            <div style="font-size: 30px; font-family: 'Do Hyeon';">회원정보 수정</div>
                            <!-- 로그인/ 회원가입 디자인용 워드클라우드 -->
                            <div id="chartdivLogin"></div>

                            <!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
                            <div id="map" style="border-radius:10%; margin: 0 auto;"></div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 col-md-5">
                    <div class="login_part_form">
                        <div class="login_part_form_iner">
                            <img src="/resources/boot/img/logo/aroundsell_sub.png" style="width: 200px; display: block; margin: 10px auto;" />

                            <form action="/updateUser.do" method="post" onsubmit="return doEditUser()" class="row contact_form">

                                <!-- 업데이트할 회원 번호 받아오기 -->
                                <input type="hidden" name="user_no" value="<%=rDTO.getUser_no()%>"/>

                                <!-- 회원 이메일(변경 불가능, 읽기 전용으로 복호화하여 표시) -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="user_email" class="font">회원 이메일</label>
                                    <input class="form-control font" type="email" name="user_email" id="user_email" value="<%=EncryptUtil.decAES128CBC(rDTO.getUser_email())%>" readonly/>
                                </div>

                                <!-- 이름 입력 -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="user_name" class="font">회원 이름</label>
                                    <input class="form-control font" input type="text" name="user_name" id="user_name" value="<%=rDTO.getUser_name()%>" style="margin-top: 10px;">
                                    <div class="font" id="name_check"></div>
                                </div>

                                <!-- 기존 비밀번호 입력 -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="password_1" class="font">비밀번호 <button type="button" class="btn view-btn1 font ml-20" onclick="doPwd()" >비번 변경</button>
                                        <input type="hidden" id="now_pw" value="<%=rDTO.getPassword()%>"/></label>
                                    <input class="form-control font" type="password" name="password" id="password_1" placeholder="기존 비밀번호를 입력해 주세요." style="margin-top: 10px;">
                                    <div class="font" id="pw_check1"></div>
                                </div>

                                <!-- 비밀번호 변경 이용 시, 비밀번호 변경 페이지로 이동(기존 비밀번호와 일치 시에만 이동하도록 구현) -->
                                <script type="text/javascript">
                                    function doPwd() {
                                        var userinput = document.getElementById("password_1").value;
                                        var nowpass = document.getElementById("now_pw").value;
                                        console.log("현재 비밀번호 : " + nowpass);
                                        console.log("유저가 입력한 비밀번호 : " + userinput);

                                        var sendData = "password="+userinput;
                                        console.log("sendData : " + sendData);

                                        $.ajax({
                                            url : "/pwdCheck.do",
                                            type : "post",
                                            dataType : "json",
                                            data :  sendData,
                                            success(data) {
                                                if (data == 1) {
                                                    //location.href = "editPwForm.do";
                                                        Swal.fire({
                                                            icon: 'question',
                                                            title: '변경할 비밀번호를 입력하세요.',
                                                            input: 'password',
                                                            customClass: {
                                                                validationMessage: 'my-validation-message',
                                                            },
                                                            // inputAttributes: {
                                                            //     id: "password1",
                                                            // },
                                                            preConfirm: (value) => {
                                                                if (!value) {
                                                                    Swal.showValidationMessage(
                                                                        '<i class="fa fa-info-circle"></i> 비밀번호를 입력해 주세요!'
                                                                    )
                                                                }
                                                            },

                                                            inputValidator: (value) => {
                                                                // 비밀번호가 입력되었다면, ajax로 비밀번호 수정 요청
                                                                if (value) {

                                                                    $.ajax({
                                                                        url: "/updatePwAjax.do",
                                                                        type: "post",
                                                                        data: {
                                                                            "password" : value
                                                                        },
                                                                        success: function(data) {
                                                                            console.log("전송 성공했으면 1, 실패하면 0" + data);
                                                                            // 비밀번호 변경이 성공했다면, 세션 초기화와 함께 로그인 창으로 이동
                                                                            if (data == 1) {
                                                                                Swal.fire({
                                                                                    title: 'Around-Sell',
                                                                                    text: '비밀번호 변경에 성공하였습니다. 재 로그인해 주세요!',
                                                                                    icon: 'success',
                                                                                    timer: 2500,
                                                                                    showConfirmButton: false
                                                                                }).then(val => {
                                                                                    if (val) {
                                                                                        location.href = "/logIn.do"
                                                                                    }
                                                                                });
                                                                            } else if (data == 0) {
                                                                                Swal.fire('Around-Sell','비밀번호 변경에 실패하였습니다. 재 시도해 주세요!','error');
                                                                                return false;
                                                                            } else if (data == 2) {
                                                                                Swal.fire('Around-Sell','기존 비밀번호와 일치합니다. 새로운 비밀번호를 입력해 주세요!','warning');
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

                                                } else { //비밀번호가 일치하지 않다면
                                                    Swal.fire('기존 비밀번호를 확인해 주세요.','','info');
                                                    return false;
                                                }
                                            },  error:function(jqXHR, textStatus, errorThrown) {
                                                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                                                console.log(errorThrown);
                                            }
                                        })
                                    }
                                </script>

                                <!-- 비밀번호 확인 입력 -->
                                <div class="col-md-12 form-group p_star">
                                    <input class="form-control font" type="password" name="password2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." style="margin-top: 10px;">
                                    <div class="font" id="pw_check2"></div>
                                </div>

                                <!-- 핸드폰 번호 변경 -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="phone_no" class="font">핸드폰 번호</label>
                                    <input class="form-control font" type="text" name="phone_no" id="phone_no" placeholder="핸드폰 번호를 입력해 주세요." value="<%=rDTO.getPhone_no()%>" style="margin-top: 10px;">
                                    <div class="font" id="phone_check"></div>
                                </div>

                                <!-- 주소 입력(도로명주소 이용) -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="sample5_address" class="font">주소 입력 <button type="button" class="btn view-btn1 font ml-15" onclick="sample5_execDaumPostcode()">주소 검색</button></label>
                                    <input class="form-control font mt-10" type="text" name="addr" id="sample5_address" placeholder="주소를 검색해 주세요." value="<%=rDTO.getAddr()%>" required readonly/>
                                </div>

                                <div class="col-md-12 form-group">

                                    <!-- 회원가입, 로그인 버튼 -->
                                    <button type="submit" value="submit" class="btn_3 font">
                                        회원정보 수정
                                    </button>
                                    <a class="lost_pass font" href="/myList.do">마이페이지로</a>
                                    <br/>
                                    <a class="lost_pass font" href="javascript:deleteUser()">탈퇴하기</a>

                                    <input type="hidden" id="user_no" value="<%=CmmUtil.nvl(rDTO.getUser_no())%>"/>
                                    <script type="text/javascript">
                                        function deleteUser() {
                                            console.log("user value : " + $("#user_no").val())
                                            Swal.fire({
                                                icon: 'question',
                                                title: 'Really? :(',
                                                text: '정말 탈퇴하시겠습니까? 작성하신 판매글도 모두 삭제됩니다.',
                                                showConfirmButton: true,
                                                confirmButtonText: '네. 탈퇴할래요',
                                                showCancelButton: true,
                                                cancelButtonText: '아니오'
                                            }).then(result => {

                                                // 확인을 누르면, 비밀번호 다시 입력 후 탈퇴 진행
                                               if (result.isConfirmed) {
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
                                                                           alert("비밀번호 일치! 탈퇴 진행");

                                                                           $.ajax({
                                                                               url: "/deleteForceUser.do",
                                                                               type: "post",
                                                                               dataType: "json",
                                                                               data: {
                                                                                   "user_no": $("#user_no").val()
                                                                               },
                                                                               success: function (data) {
                                                                                   if (data > 0) {
                                                                                       Swal.fire({
                                                                                           title:'탈퇴가 완료되었습니다.',
                                                                                           icon: 'info',
                                                                                           showConfirmButton: false,
                                                                                           timer: 2000
                                                                                       }).then(val => {
                                                                                           if (val) {
                                                                                               location.href = "/getIndex.do";
                                                                                           }
                                                                                       });
                                                                                   } else {
                                                                                       Swal.fire('Error','오류로 탈퇴에 실패했습니다. 재 시도해 주세요.', 'error');
                                                                                       window.location.reload()
                                                                                   }
                                                                               }
                                                                               // 일치하지 않으면 다시 입력할 것을 알림
                                                                           })
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

                                                });
                                        };
                                    </script>
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

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

<script type="text/javascript" src="/resource/valid/userCheck.js?ver=2"></script>
</body>
</html>
