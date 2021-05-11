<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>판매글 수정</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
</head>
<body>

    <form action="/doPost.do" method="post">
        <div>
        <input type="text" name="title"/>
    </div>
    <div>
        <input type="textarea" name="contents"/>
    </div>
    <div>
        <input type="submit"></div>
    </div>
</form>

    <!-- bootstrap, css 파일 -->
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>
</body>
</html>
