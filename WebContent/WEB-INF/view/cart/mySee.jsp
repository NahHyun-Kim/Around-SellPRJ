<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Iterator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>Title</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

    <script type="text/javascript">
        // 페이지가 로딩될 때, 최근 본 상품을 불러옴(추후 mainPage에 로그인시 띄울까 고민중)
        $(document).ready(function() {
            // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근검색어 불러오기 진행
            var userno = <%=SS_USER_NO%>;
            console.log("받아온 회원번호 : " + userno);

            if (userno != null) {

                $.ajax({
                    url: "/getGoods.do",
                    type: "post",
                    // 꼭 JSON 형태로 데이터 받아올 것!
                    dataType: "JSON",
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    success: function(data) {

                        console.log("data null인지?(length값) : " + data.length);

                        // 검색어 값들을 for문을 통해 저장
                        console.log("가져오기 성공!");
                        console.log(data);
                        console.log("타입 : " + typeof data);

                        let recentlyGoods = "";

                        /** 최근 본 상품을 5개만 출력하려면, 역순으로(최근) 출력하기 때문에 data.length-1에서 data.length-5 (=cnt) 만큼 출력하면 된다.
                         * 그러나 5개 이하인 데이터를 불러오면 index가 0이하가 된다. (데이터가 4개인데 5개를 요청하고 없는 데이터에 파싱을 요청함, 따라서)
                         *
                         * // 오류? Unexpected token u in JSON at position 0 at JSON.parse -> 파싱할 마지막 데이터 존재하지 않아 undefined, parsing 불가)
                         * 따라서 data.length(ex.4개) < cnt(출력할 개수) 일 경우에는, 전체를 출력하도록 for문을 작성한다.(전체길이에서 0까지 모두!)
                         *
                         * data.length = 5라면 5개부터는 data.length-1(=4)부터 data.length-cnt(0)까지 4,3,2,1,0 인덱스의 맞는 데이터 개수를 불러오므로 유효함
                         * **/
                        // 최근 본 상품을 출력할 개수(적은 데이터에 대한 오류를 잡기위해 임의로 5개로 정함-> 추후 변경할 수도)
                        var cnt = 5;
                        var len = data.length;

                        // 표시하고자 하는 5개의 목록보다 데이터가 많으면, 5개만 표시
                        if (len > 0 && len >= cnt) {
                            // 최근 본 상품을 표시할 개수를 정할 수 있음(-> 가져온 리스트에서 역순 출력. 임시로 5개로 설정(테스트))

                            for (let i=len-1; i>=len-cnt; i--) {

                                console.log("dataType ? : " + typeof data[i]);
                                // String 형태의 값을 변환함 .으로 접근할 수 있는 JSON 객체로 변환

                                var obj =JSON.parse(data[i]);

                                /*
                                recentlyGoods += obj.goods_no + "<br>";
                                recentlyGoods += obj.imgs + "<br>";
                                recentlyGoods += obj.goods_title + "<br> <hr>"; */

                                if (i==len-1) {

                                    // 데이터가 5개가 넘었을 경우, 총 건수에서 최근 5건만 표시되었음을 알림
                                    if (cnt < len) {
                                        recentlyGoods += "<div>최근 본 상품</div> ";
                                        recentlyGoods += "<div>총 " + len + "건의 결과, 최근 " + cnt + "건을 표시합니다.</div>";
                                    } else {
                                        recentlyGoods += "<div>최근 본 상품</div> ";
                                    }
                                }




                                //  recentlyGoods += '<div>최근 본 상품</div> <br>';
                                recentlyGoods += '<div class="col">';
                                recentlyGoods += '<a href="/noticeInfo.do?nSeq=' + obj.goods_no + '">';
                                recentlyGoods +=  '<img src="${pageContext.request.contextPath}/resource/images/' + obj.imgs + '" style="width: 150px; object-fit: contain" alt="이미지 불러오기 실패"/>';
                                recentlyGoods += obj.goods_title + "</a> </div>";

                            }
                            console.log("불러오기 성공! searchList : " + recentlyGoods);

                            // 검색어 목록에 담음
                            $("#recentlyGoods").html(recentlyGoods);
                            $("#recentlyGoods").show();

                        // 데이터가 표시하고자 하는 데이터가 적을 경우, for문을 전체로 돌려 모든 데이터를 불러온다.
                        } else if (len > 0 && len < cnt) {
                            for (let i=len-1; i>=0; i--) {

                                // String 형태의 값을 변환함 .으로 접근할 수 있는 JSON 객체로 변환

                                var obj =JSON.parse(data[i]);

                                if (i==len-1) {

                                    recentlyGoods += "<div>최근 본 상품</div>";

                                }

                              //recentlyGoods += '<div>최근 본 상품</div> <br>';
                                recentlyGoods += '<div class="col">';
                                recentlyGoods += '<a href="/noticeInfo.do?nSeq=' + obj.goods_no + '">';
                                recentlyGoods +=  '<img src="${pageContext.request.contextPath}/resource/images/' + obj.imgs + '" style="width: 150px; object-fit: contain" alt="이미지 불러오기 실패"/>';
                                recentlyGoods += obj.goods_title + "</a> </div>";

                            }
                            console.log("불러오기 성공! searchList : " + recentlyGoods);

                            // 검색어 목록에 담음
                            $("#recentlyGoods").html(recentlyGoods);
                            $("#recentlyGoods").show();


                            /* 로그인 + 최근 본 상품이 없다면
                            * 상품이 없더라도, 빈 배열값 [] 이 반환되어(null로 뜨지 않음), data.length 의 길이로 0이면(=데이터가 없으면) 안내를 띄운다.
                            */
                        } else if (data.length == 0) {

                            var resultMent = '최근 본 상품이 없습니다. <hr/> <a href="/noticeList.do">상품 보러가기</a>';

                            $("#recentlyGoods").html(resultMent);
                            $("#recentlyGoods").show();
                        }
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
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

<div class="container">
<%--  <div>최근 본 상품</div>--%>
    <div class="row">
        <div id="recentlyGoods"></div>
    </div>
    <hr>
</div>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>