<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String user_no = (String) session.getAttribute("SS_USER_NO");
    List<NoticeDTO> rList = (List<NoticeDTO>) request.getAttribute("rList");

    if (rList == null) {
        rList = new ArrayList<NoticeDTO>();
    }
%>
<html>
<head>
    <title>나의 판매글 조회하기</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        function doDetail(seq) {
            location.href="/noticeInfo.do?nSeq=" + seq;
        }
    </script>
</head>
<body>
<div class="container">
    <div class="row">
        <%
            for(int i=0; i<rList.size(); i++) {
                NoticeDTO rDTO = rList.get(i);

                if (rDTO == null) {
                    rDTO = new NoticeDTO();
                }
        %>
        <div class="col">
            <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                이미지</a>
        </div>
        <div class="col">
            <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                <%=CmmUtil.nvl(rDTO.getGoods_title())%></a>
        </div>
        <div class="col">
            <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                <%=CmmUtil.nvl(rDTO.getGoods_addr())%></a>
        </div>
        <div class="col">
            <%=CmmUtil.nvl(rDTO.getGoods_price())%>
        </div>
        <% } %>
    </div>
    <a href="javascript:history.back()">뒤로가기</a>
    <a href="/index.do">메인으로</a>
</div>
</div>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
