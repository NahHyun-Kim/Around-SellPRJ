<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="java.util.List" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% List<UserDTO> rList = (List<UserDTO>) request.getAttribute("rList");
    if (rList == null) {
        rList = new ArrayList<UserDTO>();
    }

    int edit = 1; //1이면 회원 아님, 2이면 관리자 아님, 3이면 관리자
    if (SS_USER_NO == null) {
        edit = 1;
    } else if (SS_USER_NO.equals("0")) {
        edit = 3;
    } else {
        edit = 2;
    }

%>
<html>
<head>
    <title>AroundSell- 회원 관리</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <script type="text/javascript">
        $(document).ready(function() {
            var adminChk = <%=edit%>;

            console.log(adminChk);

            if (adminChk == 1) {
                Swal.fire({
                    title:'로그인 후 이용해 주세요.',
                    icon: 'warning',
                    showConfirmButton: false,
                    timer: 2500
                }).then(val => {
                    if (val) {
                        location.href = "/logIn.do";
                    }
                });
            } else if (adminChk == 2) {
                Swal.fire({
                    title:'권한이 없습니다.',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: 2000
                }).then(val => {
                    if (val) {
                        location.href = "/getIndex.do";
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

<div class="slider-area ">
    <div class="single-slider slider-height2 d-flex align-items-center" style="margin-top:2px;">
        <div class="container">
            <div class="row">
                <div class="col-xl-12">
                    <div class="hero-cap text-center">
                        <h2 style="color: #3d1a63; font-family: 'Do Hyeon', sans-serif;"> 회원 관리 </h2>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<section class="confirmation_part section_padding">
    <div class="container">
        <div class="row font">
            <div class="col-lg-12">
                <div class="order_details_iner maxWidth">
                    <h3 class="mb-10 toCenter"><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                              style="width:300px;height: 75px;"></h3>
                    <table class="table table-borderless">
                        <thead>
                        <tr class="toCenter fontPoor toBold">
                            <th scope="col"><input name="allCheck" type="checkbox" id="allCheck"/>&nbsp; 전체 선택</th>
                            <th scope="col">회원 번호</th>
                            <th scope="col">회원명</th>
                            <th scope="col">가입일</th>
                            <th scope="col">주소지</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% int i=1;
                            for(UserDTO r : rList) { %>
                        <tr class="toCenter">
                            <th><input name="RowCheck" type="checkbox" id="del" value="<%=r.getUser_no()%>"/></th>
                            <th class="fontPoor"><%=CmmUtil.nvl(r.getUser_no())%></th>
                            <th class="fontPoor"><a class="toPurple fontPoor" href="/getUserDetail.do?no=<%=r.getUser_no()%>"><%=CmmUtil.nvl(r.getUser_name()) %></a></th>
                            <th class="fontPoor"><%=CmmUtil.nvl(r.getReg_dt()) %></th>
                            <th class="fontPoor"><%=CmmUtil.nvl(r.getAddr2()) %></th>
                        </tr>
                        <% } %>
                        </tbody>
                        <tfoot>
                        <tr>
                            <th class="toCenter" scope="col" colspan="5"><button class="btn view-btn3 mt-20 font" onclick="deleteUser()">회원 삭제</button></th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</section>

<%--        <button class="btn btn-warning" onclick="deleteUser()">회원 삭제</button>--%>

    <script type="text/javascript">
        //var res = document.getElementById("user_no").value;

        // 체크박스 선택에 따라 전체 선택, 전체 해제, 다중 삭제 구현
        var chkObj = document.getElementsByName("RowCheck");
        var rowCnt = chkObj.length;

        $("input[name='allCheck']").click(function() {
            var chk_listArr = $("input[name='RowCheck']");
            for(var i=0; i<chk_listArr.length; i++) {
                chk_listArr[i].checked = this.checked;
            }
        });

        // 모두 선택된 경우(rowCnt == RowCheck:checked length 와 같은 경우)에는 allCheck 활성화
        $("input[name='RowCheck']").click(function() {
            if($("input[name='RowCheck']:checked").length == rowCnt) {
                $("input[name='allCheck']")[0].checked = true;
            } else {
                $("input[name='allCheck']")[0].checked = false;
            }
        });

        function deleteUser() {

            // 다중 회원 삭제를 대비하여, 회원번호를 담을 배열 생성
            var valueArr = new Array();
            var list = $("input[name='RowCheck']");

            for (var i=0; i<list.length; i++) {
                if (list[i].checked) {
                    //선택되어 있는 회원번호를 valueArr에 push로 담음
                    valueArr.push(list[i].value);

                }
            }

            console.log("배열에 담은 회원번호 : " + valueArr);

            // 선택된 값이 없다면,
            if (valueArr.length == 0) {
                Swal.fire('Check Plz','선택한 회원이 없습니다!','warning');
            }
            else {
                Swal.fire({
                    title: 'Around-Sell',
                    text: '정말 탈퇴 처리하시겠습니까? 회원의 모든 정보가 함께 삭제됩니다.',
                    icon: 'warning',
                    showConfirmButton: true,
                    confirmButtonText: '네. 삭제합니다',
                    showCancelButton:  true,
                    cancelButtonText: '아니오'
                }).then(result => {

                    if (result.isConfirmed) {
                        console.log("삭제 요청");
                        $.ajax({
                            url : "/deleteUser.do",
                            type : "post",
                            data: {
                                // 배열에 담은 회원번호를 Controller로 전송하여, 삭제 진행
                                "valueArr" : valueArr
                            },
                            // 삭제에 성공했다면, 회원 목록 새로고침
                            success: function(data){
                                if (data == 1) {
                                    Swal.fire({
                                        title : 'Admin',
                                        text : '회원 삭제에 성공했습니다.',
                                        icon : "success",
                                        confirmButtonText : "네! ",
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            window.location.reload();
                                        }
                                    })

                                } else {
                                    Swal.fire('Error','오류로 회원 삭제에 실패했습니다.','error');
                                    return false;
                                }
                            },
                            error:function(jqXHR, textStatus, errorThrown) {
                                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                                console.log(errorThrown);
                            }
                        })
                    }

                    }
                )
            }
        }
    </script>

<style>
    .toCenter {
        text-align: center;
    }

    .maxWidth {
        width: 70%;
        margin: 0 auto;
    }

    .toPurple {
        color: purple;
    }

    .toPurple:hover {
        color: gray;
    }

    .toBold {
        font-width: bold;
    }
</style>
<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File Start -->
<%@ include file="../include/jsFile.jsp"%>
<!-- include JS File End -->
</body>
</html>
