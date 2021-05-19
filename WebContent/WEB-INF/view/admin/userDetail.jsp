<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
%>
<html>
<head>
    <title>AroundSell- 회원 상세정보 조회</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<div class="container">

    <h1>회원 상세정보 조회</h1>
    <div class="row">
        <div class="col-sm-3 text-center"><b>회원 번호</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getUser_no())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>회원 이름</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getUser_name())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>이메일</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(EncryptUtil.decAES128CBC(rDTO.getUser_email()))%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>가입일</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getReg_dt())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>주소지</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getAddr2())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>상세 주소</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getAddr())%></div>
    </div>
    <div class="row">
        <div class="col-sm-3 text-center"><b>전화번호</b></div>
        <div class="col-sm-9 text-center"><%=CmmUtil.nvl(rDTO.getPhone_no())%></div>
    </div>
    <a href="javascript:window.history.back();"><i class="bx bx-server"></i>뒤로가기</a>
    <button type="button" id="user_no" value="<%=CmmUtil.nvl(rDTO.getUser_no())%>" onclick="deleteUser();">회원 삭제</button>

    <div class="row">
        <div class="col-3">상품 사진</div>
        <div class="col-3">상품명</div>
        <div class="col-3">상호명</div>
        <div class="col-3">가격</div>
    </div>

    <div class="row">
        <%
            for(int i=0; i<nList.size(); i++) {
                NoticeDTO nDTO = nList.get(i);

                if (nDTO == null) {
                    nDTO = new NoticeDTO();
                }
        %>
        <div class="col-3">
            <a href="/noticeInfo.do?nSeq=<%=nDTO.getGoods_no()%>">
                <img src="/resource/images/<%=nDTO.getImgs()%>" alt="이미지 불러오기 실패" style="width:150px; object-fit: contain"/>
            </a>
        </div>
        <div class="col-3">
            <a href="/noticeInfo.do?nSeq=<%=nDTO.getGoods_no()%>">
                <%=CmmUtil.nvl(nDTO.getGoods_title())%></a>
        </div>
        <div class="col-3">
            <a href="/noticeInfo.do?nSeq=<%=nDTO.getGoods_no()%>">
                <%=CmmUtil.nvl(nDTO.getGoods_addr())%></a>
        </div>
        <div class="col-3">
            <%=CmmUtil.nvl(nDTO.getGoods_price())%>
        </div>
        <% } %>
    </div>
    <a href="javascript:history.back()">뒤로가기</a>
    <a href="/index.do">메인으로</a>
</div>

</div>

<script type="text/javascript">
        function deleteUser() {
            console.log("user value : " + $("#user_no").val())
        if (confirm('정말 삭제하시겠습니까?')) {
            $.ajax({
                url: "/deleteForceUser.do",
                type: "post",
                dataType: "json",
                data: {
                    "user_no": $("#user_no").val()
                },
                success: function (data) {
                    if (data > 0) {
                        window.location.reload()
                        return false;
                    }
                    else {
                        alert("삭제에 실패했습니다.");
                        window.location.reload()
                        return true;
                    }
                }
            });
        }
    };
</script>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
