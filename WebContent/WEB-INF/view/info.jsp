<%@ page import="poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String msg = CmmUtil.nvl((String)request.getAttribute("msg"));
    String url = CmmUtil.nvl((String)request.getAttribute("url"));
%>
<html>
<head>
    <meta charset="UTF-8">
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <title></title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>
<script type="text/javascript">
    $(document).ready(function() {
        Swal.fire({
            title: 'Around-Sell',
            text: "<%=msg%>",
            icon: 'info',
            buttons: true
        }).then(val => {
            if (val) {
                location.href = "<%=url%>";
            }
        });
    })
</script>
</body>
</html>
