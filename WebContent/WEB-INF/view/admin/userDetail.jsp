<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<% UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
    List<NoticeDTO> nList = (List<NoticeDTO>) request.getAttribute("nList");

    if (nList == null) {
        nList = new ArrayList<NoticeDTO>();
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
    <title>AroundSell- 회원 상세정보 조회</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>
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
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->

<main>


    <!-- 상품 목록 일부 보여주기(index) 시작 -->
    <div class="popular-items section-padding30">
        <!-- container 시작 -->
        <div class="container">

            <!-- Section tittle1 (지역정보, 날씨정보 표시) -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">

                    <div class="section-tittle mb-70 text-center">

                        <h2><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                 style="width:300px;height: 85px;"></h2>

                        <div class="blog_right_sidebar">
                            <aside class="single_sidebar_widget post_category_widget">
                                <br/>
                                <h4 class="widget_title mt-10" style="font-family: 'Noto Sans KR'">회원 상세정보 조회</h4>
                                <br/>
                                <div id="infoInput"></div>
                                <!-- 회원 상세정보 출력 -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="user_number" class="font">회원 번호</label>
                                    <input class="form-control font" id="user_number" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getUser_no())%>" readOnly/>
                                </div>

                                <div class="col-md-12 form-group p_star">
                                    <label for="user_name" class="font">회원 이름</label>
                                    <input class="form-control font" id="user_name" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getUser_name())%>" readOnly/>
                                </div>

                                <!-- 관리자 상세보기 시 이메일을 복호화하여 출력함 -->
                                <div class="col-md-12 form-group p_star">
                                    <label for="user_email" class="font">이메일</label>
                                    <input class="form-control font" id="user_email" type="email"
                                           value="<%=CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()))%>" readOnly/>
                                </div>

                                <div class="col-md-12 form-group p_star">
                                    <label for="phone_no" class="font">핸드폰 번호</label>
                                    <input class="form-control font" id="phone_no" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getPhone_no())%>" readOnly/>
                                </div>

                                <div class="col-md-12 form-group p_star">
                                    <label for="addr2" class="font">가입 주소지</label>
                                    <input class="form-control font" id="addr2" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getAddr2())%>" readOnly/>
                                </div>

                                <div class="col-md-12 form-group p_star">
                                    <label for="addr" class="font">상세 주소지</label>
                                    <input class="form-control font" id="addr" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getAddr())%>" readOnly/>
                                </div>

                                <div class="col-md-12 form-group p_star">
                                    <label for="reg_dt" class="font">가입일</label>
                                    <input class="form-control font" id="reg_dt" type="text"
                                           value="<%=CmmUtil.nvl(rDTO.getUser_name())%>" readOnly/>
                                </div>

                                </ul>
                            </aside>
                        </div>

                        <button type="button" class="btn view-btn3 font" id="user_no" value="<%=CmmUtil.nvl(rDTO.getUser_no())%>" onclick="deleteUser();">회원 삭제</button>

                    </div>

                </div>
            </div>

            <hr/>
            <!-- Button -->
            <div class="row justify-content-center">
                <div class="col-xl-7 col-lg-8 col-md-10">

                    <div class="section-tittle mb-70 text-center">
                        <aside class="single_sidebar_widget post_category_widget">
                            <h4 class="widget_title info font"><%=rDTO.getUser_name()%>님이 작성한 판매글</h4>
                            <br/>
                            <div class="font" id="noSell"></div>

                        </aside>
                    </div>
                </div>
            </div>

            <div class="row">
                <%
                    for (int i = 0; i < nList.size(); i++) {
                        NoticeDTO nDTO = nList.get(i);

                        if (nDTO == null) {
                            nDTO = new NoticeDTO();
                        }
                %>
                <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6">
                    <div class="single-popular-items mb-50 text-center">
                        <!-- 상품 이미지 -->
                        <div class="popular-img">
                            <img src="/resource/images/<%=nDTO.getImgs()%>" alt=""
                                 style="width:240px; height:240px; object-fit: contain; cursor: pointer"
                                 onclick="doDetail(<%=nDTO.getGoods_no()%>)">

                            <!-- hover 적용, 마우스 올릴 시 click me! 문구 표시 -->
                            <div class="img-cap">
                                <span>My Product!</span>
                            </div>

                        </div>

                        <div class="popular-caption">
                            <!-- 상품명 -->
                            <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(nDTO.getGoods_no())%>');">
                                <%=CmmUtil.nvl(nDTO.getGoods_title())%>
                            </a></h3>

                            <!-- 가격 -->
                            <h3>
                                <a href="javascript:doDetail('<%=CmmUtil.nvl(nDTO.getGoods_no())%>');"><%=CmmUtil.nvl(nDTO.getGoods_price())%>
                                </a></h3>

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

<script type="text/javascript">
    function deleteUser() {
        console.log("user value : " + $("#user_no").val())
        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "네!",
            cancelButtonText: "아니오"
        }).then(result => {
            $.ajax({
                url: "/deleteForceUser.do",
                type: "post",
                dataType: "json",
                data: {
                    "user_no": $("#user_no").val()
                },
                success: function (data) {
                    // 삭제에 성공했다면
                    if (data > 0) {
                        window.location.reload()
                        return false;
                    } else {
                        Swal.fire('Error','삭제에 실패했습니다.','error');
                        window.location.reload()
                        return true;
                    }
                }
            });

    })
    }
</script>

<!-- include Footer -->
<%@ include file="../include/footer.jsp" %>

<!-- include JS File Start -->
<%@ include file="../include/jsFile.jsp" %>
<!-- include JS File End -->

</body>
</html>
