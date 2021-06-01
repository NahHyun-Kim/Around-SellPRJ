<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.dto.Criteria" %>
<%@ page import="java.util.Iterator" %>
<%
    String SS_USER_NO = (String) session.getAttribute("SS_USER_NO");
    String SS_USER_ADDR2 = (String) session.getAttribute("SS_USER_ADDR2"); // 추후 사용, 지역구별 판매글
%>
<html>
<head>
    <title>판매글 목록(페이징)</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        function doDetail(seq) {
            location.href="/noticeInfo.do?nSeq=" + seq;
        }

        function selChange() {
            // 한 페이지당 게시물 보기 개수를 세팅하여 전달
            // 기존의 보기 개수 + 검색어에 대한 페이징을 수행하기 위해 searchType, keyword를 함께 받아온다.

            var sel = document.getElementById('cntPerPage').value;

            console.log("select change! cntPerPage : " + sel);

            // 선택한 option 값 받아오기
            var s = document.getElementById("searchType");
            var searchType = s.options[s.selectedIndex].value;
            //var searchType = document.getElementById("st").value;

            console.log("searchType(선택한 옵션 값) : " + searchType);

            var keyword = document.getElementById("keyword").value;
            console.log("가져온 키워드(Controller 검색 결과 또는 검색결과에서 페이징용) : " + keyword);

            // 정렬된 상태로 페이징 하는 경우를 위해 정렬값을 받아옴
            var od = document.getElementById('odType');
            var odType = od.options[od.selectedIndex].value;

            console.log("선택한 정렬 값 : " + odType);
            console.log("정렬 null ? : " + (odType == ""));

            // 검색어가 없이 페이징만 요청하는 경우에는, 불필요한 @param(검색 관련) 을 붙이지 않고 페이징 쿼리만 전송
            if (searchType == "" || keyword == "") {
                location.href = "/searchList.do?nowPage=${paging.nowPage}&cntPerPage="+sel;
            }
            // 검색어가 있는 상태로 페이징 변경을 요청했다면, 검색타입과 검색어를 함께 요청하여 새로 페이징함
            else if (searchType != "" || keyword != ""){
                // 정렬 타입이 지정되지 않았다면, 검색 결과값을 페이징 요청
                if (odType == "") {
                    location.href= "/searchList.do?nowPage=${paging.nowPage}&cntPerPage="+sel+"&searchType="+ searchType+"&keyword="+keyword;
                }
                // 정렬 타입이 지정되었다면, 정렬 요청한 결과값을 페이징 요청
                else if (odType != "") {
                    location.href="/searchList.do?nowPage=${paging.nowPage}&cntPerPage="+sel+"&searchType="+ searchType+"&keyword="+keyword + "&odType=" + odType;
                }

            }

        }
    </script>
    <%
        // 페이징 처리를 위해 필요한 페이지, 숫자값 pDTO에서 받아오기(+검색타입, 키워드)
        Criteria pDTO = (Criteria) request.getAttribute("paging");

        int nowPage = pDTO.getNowPage();
        int startPage = pDTO.getStartPage();
        int endPage = pDTO.getEndPage();
        int cntPerPage  = pDTO.getCntPerPage();
        int lastPage = pDTO.getLastPage();
        int num = 1;

        // 총 검색 결과건수를 표시하기 위한 total 변수 함께 가져옴
        int total = pDTO.getTotal();

        // 검색된 상태로 페이징할 경우 searchType과 keyword를 함께 보낸다.
        String searchType = pDTO.getSearchType();
        String keyword = pDTO.getKeyword();

        // 정렬할 경우 odType을 받아온다.
        String odType = pDTO.getOdType();

        System.out.println("받아온 타입 : " + searchType + ", 받아온 검색어 : " + keyword + ", 정렬 : " + odType);

        List<NoticeDTO> searchList = (List<NoticeDTO>) request.getAttribute("searchList");

        if (searchList == null) {
            searchList = new ArrayList<NoticeDTO>();
        }

        List<String> addrList = new ArrayList<>();

        String tempaddr = "";
        for (NoticeDTO i : searchList) {
            tempaddr = i.getGoods_addr2();
            System.out.println(tempaddr);
        }
    %>

    <script type="text/javascript">

        var latArr = new Array();
        var lonArr = new Array();
    </script>
</head>
<body>
<div class="container">
    <div>
        <select id="cntPerPage" name="sel" onchange="selChange()">
            <option value="3" <%if (cntPerPage == 3) {%> selected <%}%>>3개씩 보기</option>
            <option value="6" <%if (cntPerPage == 6) {%> selected <%}%>>6개씩 보기</option>
            <option value="9" <%if (cntPerPage == 9) {%> selected <%}%>>9개씩 보기</option>
        </select>

        <div id="searchResult"></div>

        <!-- 판매글 리스트 -->
        <div class="row">
            <%
                for(int i=0; i<searchList.size(); i++) {
                    NoticeDTO rDTO = searchList.get(i);

                    if (rDTO == null) {
                        rDTO = new NoticeDTO();
                    }
            %>
            <div class="col"><%=num%>
                <%
                    num++;
                %>
            </div>

            <div class="col">
                <a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                    <img src="/resource/images/<%=rDTO.getImgs()%>" style="width:150px; height:200px; object-fit:contain" alt="이미지 불러오기 실패"></a>
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

        <!-- 검색창, 검색 후 정렬 가능, 검색한 결과와 카테고리를 저장한다. -->
        <div>
            <!-- 검색창(카테고리 지정) -->
            <select id="searchType" name="searchType">
                <option value="" selected disabled hidden>==카테고리를 선택하세요==</option>
                <option value="T" <%=CmmUtil.nvl(searchType).equals("T")?"selected":""%>>상품명</option>
                <option value="C" <%=CmmUtil.nvl(searchType).equals("C")?"selected":""%>>상품 설명</option>
                <option value="L" <%=CmmUtil.nvl(searchType).equals("L")?"selected":""%>>상호명</option>
                <option value="J" <%=CmmUtil.nvl(searchType).equals("J")?"selected":""%>>주소지</option>
                <option value="G" <%=CmmUtil.nvl(searchType).equals("G")?"selected":""%>>카테고리</option>
                <option value="A" <%=CmmUtil.nvl(searchType).equals("A")?"selected":""%>>제목+내용</option>
                <option value="W" <%=CmmUtil.nvl(searchType).equals("W")?"selected":""%>>작성자</option>
            </select>

            <div class="row">
                <div class="col-6">
                    <!-- 검색창(키워드 입력, 검색창 선택 시 최근검색어 불러옴) -->
                    <input type="text" name="keyword" id="keyword" value="${paging.keyword}" />

                    <!-- div로 최근검색어 리스트에 추가함 -->
                <div id="searchHistory" style="display:none;">
                    <ul id="list">
                    </ul>
                </div>
                </div>
                <div class="col-6">
                    <button type="button" id="searchProduct" class="btn btn-info">검색하기</button>
                </div>
            </div>

            <!--<button type="button" id="searchProduct" class="btn btn-info">검색하기</button> -->

            <input type="hidden" id="st" name="searchType" value="${paging.searchType}"/>


            <!-- 검색 후 정렬(null이면 자동으로 ORDER BY GOODS_NO DESC) -->
            <select id="odType" name="odType" style="display:none;">
                <option value="" selected disabled hidden>=정렬=</option>
                <option value="hit" <%=CmmUtil.nvl(odType).equals("hit")?"selected":""%>>인기순</option>
                <option value="low" <%=CmmUtil.nvl(odType).equals("low")?"selected":""%>>가격 낮은순</option>
                <option value="high" <%=CmmUtil.nvl(odType).equals("high")?"selected":""%>>가격 높은순</option>
            </select>

            <input type="hidden" id="ot" name="odType" value="${paging.odType}"/>
            <!-- 테스트용, 추후 삭제 예정(onChange 함수로 정렬 성공) -->
            <!--<button type="button" id="orderProduct" class="btn btn-info">정렬하기</button>-->
        </div>
        <button class="btn btn-info" type="button" onclick="location.href='/noticeForm.do'">글쓰기</button>
        <a href="/index.do">홈으로</a>
        <a href="javascript:history.back()">뒤로가기</a>
        <hr/>
    </div>

    <div>
        <div id="paging">
            <ul>
                <%if (startPage != 1) { %>
                <li><a href="/searchList.do?nowPage=<%=startPage - 1%>&cntPerPage=<%=cntPerPage%>">&lt;</a>
                        <%
                            }
                            %> <%
                for (int i = startPage; i <= endPage; i++) {
 %>             <%
                if (i == nowPage) {
 %>
                <li class="active"><span><%=i%></span></li>
                <%
                    }
                %>
                <%
                    if (i != nowPage) {
                %>
                <li><a href="/searchList.do?nowPage=<%=i%>&cntPerPage=<%=cntPerPage%>"><%=i%></a></li>
                <%}%>
                <%}%>
                <%if (endPage != lastPage) { %>
                <li><a href="/searchList.do?nowPage=<%=endPage + 1%>&cntPerPage=<%=cntPerPage%>">&gt;</a></li>
                <%}%>

            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        //console.log("세션 null(로그인 상태?) : " + (<%=SS_USER_ADDR2%>) != null);
        var res = document.getElementById("searchResult");

        var keyword = "<%=keyword%>";
        var total = "<%=total%>";
        var odType = "<%=odType%>";

        console.log("총 결과 건수 : " + total);
        console.log("키워드 : " + keyword);
        console.log("keyword null? : " + (keyword == "null"));
        console.log("정렬 타입 있는지? : " + (odType == "null"));

        var s = document.getElementById("searchType");
        var searchType = s.options[s.selectedIndex].text;
        console.log("searchType(value 말고 text값) : " + searchType);

        var resultMent = "";

        // 검색어가 있는 상태라면, 검색 결과 건수를 보여줌
        // 판매 주소지(검색타입 J)로 검색하는 경우, "해당 주소지"에 대한 n건의 검색결과로 깔끔하게 나타냄
        if (keyword != "null" && searchType != "주소지" && searchType != "카테고리") {

            console.log("검색된 게시물 수 : " + total);

            resultMent = "<span style='color:#ff0000'>" + keyword + "</span>에 대한 " + "총 <span style='color:blue'>" + total + "</span> 건의 검색 결과";
            console.log("검색결과 멘트 : " + resultMent);

            // 검색한 상품이 있을 때에만 정렬 기능을 지원하므로, 기본 display:none 속성을 해제한다.
            $("#odType").show();

            res.innerHTML = resultMent;

            // 검색어가 존재하지 않으면, 전체 게시물 건수를 보여줌.
        } else if (keyword == "null") {

            console.log("전체 게시물 수 : " + total);

            var totalMent = "전체 <span style='color:blue'>" + total + "</span> 건의 상품";

            res.innerHTML = totalMent;
        } else if (keyword != "null" && (searchType == "주소지" || searchType == "카테고리")) {

            console.log("검색된 게시물 수 : " + total);

            resultMent = "해당 " + searchType + "<span style='color:#ff0000'>(" + keyword + ")</span>에 대한 " + "총 <span style='color:blue'>" + total + "</span> 건의 검색 결과";
            console.log("검색결과 멘트 : " + resultMent);

            // 검색한 상품이 있을 때에만 정렬 기능을 지원하므로, 기본 display:none 속성을 해제한다.
            $("#odType").show();

            res.innerHTML = resultMent;
        }

    })

    // 검색 버튼 클릭 시, 값을 받아와 검색 실행
    $("#searchProduct").on("click", function() {
        // 키워드 값 받아오기
        var keyword = document.getElementById("keyword").value;
        console.log("가져온 키워드 : " + keyword);

        // 검색 종류(selectBox) 받아오기 -> 선택한 값을 받아와야 함(s.selectedIndex.value)
        /*var searchType = document.getElementById('searchType').value;
        console.log("가져온 검색 타입 : " + searchType); */

        // 선택한 option 값 받아오기
        var s = document.getElementById("searchType");
        var searchType = s.options[s.selectedIndex].value;

        console.log("searchType(선택한 옵션 값) : " + searchType);

        // 화면에서 키워드나 타입이 선택되지 않았다면, 검색을 하지 않도록 제어함
        /*
        * form id를 지정 후,
        * $("#폼이름"); 을 var 변수에 담아 !변수명.find("option:selected").val()) 로 표현할 수 있다.
        * */

        // 검색어와 타입이 모두 입력되면 controller로 전송하여 검색 결과 반환
        if (keyword != "" && searchType != "") {
            console.log("searchType(선택한 옵션 값 : " + searchType);
            location.href = "/searchList.do?nowPage=1&cntPerPage=9&searchType=" + searchType + "&keyword=" + keyword;

            // 검색어나 타입이 존재하지 않으면, 검색이 실행되지 않고 입력하기를 알림 띄움
        } else if (searchType == "" && keyword == "") {
            console.log("검색 타입과 검색어를 입력해 주세요.");
            alert("검색 타입과 검색어를 입력해 주세요.");
            document.getElementsByName("searchType")[0].focus();
            return false;

            // 검색 타입만 존재하지 않는 경우
        }   else if (searchType == "") {
            console.log("검색 타입을 지정해 주세요.");
            alert("검색 타입을 지정해 주세요.");
            document.getElementsByName("searchType")[0].focus();
            return false;

        } else if (keyword == "") {
            console.log("검색어를 입력해 주세요.");
            alert("검색어를 입력해 주세요.");
            document.getElementById("keyword").focus();
            return false;
        }


    })

    // 정렬 타입을 클릭하면, 선택한 키워드값과 정렬타입을 저장한 채로 정렬 요청 url 전송
    $("#odType").on("change", function() {
    //$("#orderProduct").on("click", function() {
        //키워드 값 받아오기
        var keyword = document.getElementById("keyword").value;
        console.log("가져온 키워드 : " + keyword);

        // 선택한 option 값 받아오기
        var s = document.getElementById("searchType");
        var searchType = s.options[s.selectedIndex].value;

        console.log("searchType(선택한 옵션 값) : " + searchType);
        console.log("검색 타입, 검색어 : " + searchType + keyword);

        // 정렬 종류(selectBox) 받아오기 -> 선택한 값을 받아와야 함(s.selectedIndex.value)
        var o = document.getElementById("odType");
        var odType = o.options[o.selectedIndex].value;
        console.log("가져온 정렬 타입 : " + odType);

        console.log("정렬 시작!(링크 보내기 직전) : " + odType);
        // orderType이 지정되면 받아온 검색 결과 + 정렬 함수를 실행함
        if (odType != "") {
            console.log("정렬 쿼리 보냄!");
            location.href = "/searchList.do?nowPage=1&cntPerPage=9&searchType=" + searchType + "&keyword=" + keyword + "&odType=" + odType;
        } else {
            alert("실패했습니다!");
            return false;
        }
    })

    // 검색창을 클릭했을때, 로그인 상태로 검색 기록이 있는 사용자라면 최근검색어 리스트 제공
    $("#keyword").on("click", function() {

        var userno = <%=SS_USER_NO%>;
        console.log("세션 유저번호 있는지 체크 : " + userno);

        // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근검색어 불러오기 진행
        if (userno != null) {

            $.ajax({
                url: "/getKeyword.do",
                type: "post",
                success: function(data) {
                    console.log("data : " + data);

                    /*
                    * 최근검색어 목록 동적으로 생성하여 불러오기
                    */
                    var searchArr = new Array();

                    // 검색어 값들을 for문을 통해 배열에 저장
                    for (let i=data.length-1; i>=0; i--) {
                        searchArr.push(data[i]);
                    }

                    // remove() 요소 자체를 지움, empty 요소의 내용을 지움 -> empty()로 검색어 리스트(내용)를 지움
                    $("#list").empty();
                    console.log("기존 검색어 지우기 완료!");
                    for (let i=0; i<searchArr.length; i++) {
                        var searchKeyword = searchArr[i];

                        console.log("검색한 키워드 값 : " + searchKeyword);

                        // 검색어 목록을 list에 append 함
                        $("#list").append('<li id="' + i + '" onclick="insertKeyword(' + i + ')" >' + searchKeyword + '</li>');

                    }
                    $("#list").append('<button class="btn btn-danger" onclick="rmKeyword()"">X</button>');
                    $("#searchHistory").show();


                }
            })
        }
    })

    // 최근검색어 클릭 시, 검색어창에 자동 입력되게 하는 함수
    function insertKeyword(keyword) {
        console.log("insertKeyword() 함수 호출!");

        var insertKeyword = keyword;
        console.log("받아온 검색어 : " + insertKeyword);

        var value = document.getElementById(insertKeyword).innerHTML;
        console.log("받아온 검색어2 : " + value);

        // 클릭한 최근검색어를 검색창에 자동 입력되도록 설정
        $('input[name=keyword]').attr('value', value);

        console.log("검색어 입력 성공!");
    }

    // 최근검색어 창 없애기(X)
    function rmKeyword() {

        $("#searchHistory").hide();
        $("#list").empty();
        $('input[name=keyword]').attr('value', "");
        console.log("검색어 창 벗어나면 숨기기 + 기존 요소 지움!");

    }

</script>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css?ver=1"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
