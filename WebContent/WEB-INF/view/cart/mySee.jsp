<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Iterator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String user_no = (String) session.getAttribute("SS_USER_NO");
    /*Set<String> rList = (Set<String>) request.getAttribute("rList");

    Iterator<String> it = rList.iterator();

    while(it.hasNext()) {
        System.out.println("rSet : " + it.next());
    }

        if (rList == null) {
            rList = new LinkedHashSet<String>();
        } */

%>
<html>
<head>
    <title>Title</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        // 페이지가 로딩될 때, 최근 본 상품을 불러옴(추후 mainPage에 로그인시 띄울까 고민중)
        $(document).ready(function() {
            // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근검색어 불러오기 진행
            var userno = <%=user_no%>;
            console.log("받아온 회원번호 : " + userno);

            if (userno != null) {

                $.ajax({
                    url: "/getGoods.do",
                    type: "post",
                    dataType: "JSON",
                   contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    success: function(data) {

                        var data = data;

                        // 검색어 값들을 for문을 통해 저장
                        console.log("가져오기 성공!");
                        console.log(data);
                        console.log("타입 : " + typeof data);

                        // 최근 본 상품부터 불러와야 하기 때문에, 역순으로 리스트를 가져옴
                        let searchList = "";

                        for (let i=data.length-1; i>=0; i--) {
                            // String 형태의 값을 변환함 .으로 접근할 수 있는 JSON 객체로 변환
                            var obj = JSON.parse(data[i]);

                            searchList += obj.goods_no + "<br>";
                            searchList += obj.imgs + "<br>";
                            searchList += obj.goods_title + "<br> <hr>";
                        }
                        console.log("불러오기 성공! searchList : " + searchList);

                        // 검색어 목록에 담음
                        $("#keywordList").html(searchList);
                        $("#keywordList").show();

                    }
                })
            } else {
                alert("로그인 후 이용해 주세요");
                location.href = "/logIn.do";
            }
        })
    </script>
</head>
<body>
<div>최근 본 상품</div>
<div id="keywordList"></div>
<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>
</body>
</html>
