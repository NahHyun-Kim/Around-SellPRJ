<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.dto.Criteria" %>

<html>
<head>
    <title>판매글 목록(페이징)</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp" %>
    <link rel="stylesheet" href="/resources/boot/css/nice-select.css">

    <script type="text/javascript">
    </script>
    <%
        // 페이징 처리를 위해 필요한 페이지, 숫자값 pDTO에서 받아오기(+검색타입, 키워드)
        Criteria pDTO = (Criteria) request.getAttribute("paging");
        int nowPage = pDTO.getNowPage();
        int startPage = pDTO.getStartPage();
        int endPage = pDTO.getEndPage();
        int cntPerPage = pDTO.getCntPerPage();
        int lastPage = pDTO.getLastPage();
        int num = 1;
        // 총 검색 결과건수를 표시하기 위한 total 변수 함께 가져옴
        int total = pDTO.getTotal();
        // 검색된 상태로 페이징할 경우 searchType과 keyword를 함께 보낸다.
        String searchType = CmmUtil.nvl(pDTO.getSearchType(), "null");
        String keyword = CmmUtil.nvl(pDTO.getKeyword(),"null");
        // 정렬할 경우 odType을 받아온다.
        String odType = CmmUtil.nvl(pDTO.getOdType(), "null");
        System.out.println("받아온 타입 : " + searchType + ", 받아온 검색어 : " + keyword + ", 정렬 : " + odType);
        List<NoticeDTO> searchList = (List<NoticeDTO>) request.getAttribute("searchList");
        if (searchList == null) {
            searchList = new ArrayList<NoticeDTO>();
        }
        List<String> addrList = new ArrayList<>();
        String tempaddr = "";

    %>
</head>
<body>
<!-- preloader -->
<%@ include file="../include/preloader.jsp" %>
<!-- preloader End -->

<!-- Header(상단 메뉴바 시작!) Start -->
<%@ include file="../include/header.jsp" %>
<!-- Header End(상단 메뉴바 끝!) -->

<style>
    .pointPage {
        background-color: #d0a7e4;
        border-radius: 50%;
    }

    .toPurple {
        color: rebeccapurple;
    }
</style>
<!-- 상품 리스트 + 검색 section 시작 -->
<div class="popular-items section-padding30">
    <!-- container 시작 -->
    <div class="container">

        <!-- Section tittle -->
        <div class="row justify-content-center">
            <div class="col-xl-7 col-lg-8 col-md-10">
                <div class="section-tittle mb-70 text-center" >
                    <hr/>
                    <h3 class="mb-10 toCenter"><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                                    style="width:300px;height: 75px;"></h3>
                    <h2 style="font-family: 'Poor Story'">Search your Item!</h2>
                    <br>
                    <p style="font-family: 'Poor Story'">원하는 집 주변 상품을 검색하세요!</p>

                    <div id="searchResult"></div>
                    <!-- 검색창, 검색 후 정렬 가능, 검색한 결과와 카테고리를 저장한다. -->
                    <div>
                        <!-- 검색창(카테고리 지정) -->
                        <select id="searchType" name="searchType">
                            <option value="" selected disabled hidden>검색 타입</option>
                            <option value="T" <%=CmmUtil.nvl(searchType).equals("T") ? "selected" : ""%>>상품명</option>
                            <option value="C" <%=CmmUtil.nvl(searchType).equals("C") ? "selected" : ""%>>상품 설명</option>
                            <option value="L" <%=CmmUtil.nvl(searchType).equals("L") ? "selected" : ""%>>상호명</option>
                            <option value="J" <%=CmmUtil.nvl(searchType).equals("J") ? "selected" : ""%>>주소지</option>
                            <option value="G" <%=CmmUtil.nvl(searchType).equals("G") ? "selected" : ""%>>카테고리</option>
                            <option value="A" <%=CmmUtil.nvl(searchType).equals("A") ? "selected" : ""%>>제목+내용</option>
                            <option value="W" <%=CmmUtil.nvl(searchType).equals("W") ? "selected" : ""%>>작성자</option>
                        </select>

                        <div class="row">
                            <div class="col-6">
                                <!-- 검색창(키워드 입력, 검색창 선택 시 최근검색어 불러옴) -->
                                <input type="text" name="keyword" id="keyword" value="${paging.keyword}" class="form-control font ml-20" style="width: 300px;"/>

                                <!-- div로 최근검색어 리스트에 추가함 -->
                                <div id="searchHistory" style="display:none;">
                                    <ul id="list">
                                    </ul>
                                </div>
                            </div>
                            <div class="col-4">
                                <button type="button" id="searchProduct" class="btn view-btn font">검색하기</button>
                            </div>
                        </div>

                        <!--<button type="button" id="searchProduct" class="btn btn-info">검색하기</button> -->

                        <input type="hidden" id="st" name="searchType" value="${paging.searchType}"/>


                        <!-- 검색 후 정렬(null이면 자동으로 ORDER BY GOODS_NO DESC) -->
                        <select id="odType" name="odType" style="display:none;">
                            <option value="" selected disabled hidden>=정렬=</option>
                            <option value="hit" <%=CmmUtil.nvl(odType).equals("hit") ? "selected" : ""%>>인기순</option>
                            <option value="low" <%=CmmUtil.nvl(odType).equals("low") ? "selected" : ""%>>가격 낮은순</option>
                            <option value="high" <%=CmmUtil.nvl(odType).equals("high") ? "selected" : ""%>>가격 높은순
                            </option>
                        </select>

                        <input type="hidden" id="ot" name="odType" value="${paging.odType}"/>
                        <!-- 테스트용, 추후 삭제 예정(onChange 함수로 정렬 성공) -->
                        <!--<button type="button" id="orderProduct" class="btn btn-info">정렬하기</button>-->
                    </div>

                    <hr/>

                    <!-- 페이징 게시물 수 -->
                    <select id="cntPerPage" name="sel" onchange="selChange()">
                        <option value="3" <%if (cntPerPage == 3) {%> selected <%}%>>3개씩 보기</option>
                        <option value="6" <%if (cntPerPage == 6) {%> selected <%}%>>6개씩 보기</option>
                        <option value="9" <%if (cntPerPage == 9) {%> selected <%}%>>9개씩 보기</option>
                        <option value="12" <%if (cntPerPage == 12) {%> selected <%}%>>12개씩 보기</option>
                        <option value="18" <%if (cntPerPage == 18) {%> selected <%}%>>18개씩 보기</option>
                    </select>
                </div>

            </div>
        </div>

        <!-- 상품 리스트 시작! -->
        <div class="row">

            <%
                for (int i = 0; i < searchList.size(); i++) {
                    NoticeDTO rDTO = searchList.get(i);
                    if (rDTO == null) {
                        rDTO = new NoticeDTO();
                    }
            %>

            <!-- for문으로 상품 리스트 불러오기, 전체 이미지+텍스트 감싸는 col -->
            <div class="col-xl-4 col-lg-4 col-md-6 col-sm-6">
                <%
                    num++;
                %>
                <div class="single-popular-items mb-50 text-center">

                    <!-- 상품 이미지 -->
                    <div class="popular-img">
                        <img src="/resource/images/<%=rDTO.getImgs()%>" alt=""
                             style="width:240px; height:240px; object-fit: contain; cursor: pointer" onclick="doDetail(<%=rDTO.getGoods_no()%>)">
                        <div class="img-cap">
                            <span>Click Me!</span>
                        </div>
                        <div class="favorit-items">
                            <span class="flaticon-heart" onclick="addCart(<%=rDTO.getGoods_no()%>,<%=rDTO.getUser_no()%>)"></span>
                        </div>
                    </div>
                    <div class="popular-caption">
                        <h3><a href="javascript:doDetail('<%=CmmUtil.nvl(rDTO.getGoods_no())%>');">
                            <%=CmmUtil.nvl(rDTO.getGoods_title())%>
                        </a></h3>
                        <!--<span style="font-size: 15px;"><%=CmmUtil.nvl(rDTO.getGoods_addr())%></span>-->
                        <span><%=CmmUtil.nvl(rDTO.getGoods_price())%></span>
                        <!-- 상호명 -->
                        <h5><a class="font" style="color: #d0a7e4;" href="javascript:searchLocation('<%=CmmUtil.nvl(rDTO.getGoods_addr())%>', <%=rDTO.getGoods_no()%>)"><%=CmmUtil.nvl(rDTO.getGoods_addr())%></a></h5>

                    </div>
                </div>
            </div>
            <% } %>


        </div>
        <!-- end row -->

        <!-- Button -->
        <div class="row justify-content-center">
            <div class="room-btn pt-70">

                <!-- paging button 시작 -->
                <div id="paging">
                    <div class="row">
                        <%if (startPage != 1) { %>
                        <div class="col-1 toPurple"><a class="toPurple" href="/searchList.do?nowPage=<%=startPage - 1%>&cntPerPage=<%=cntPerPage%>&searchType=<%=searchType%>&keyword=<%=keyword%>&odType=<%=odType%>">&lt;</a></div>
                        <%
                            }
                        %> <% for (int i = startPage; i <= endPage; i++) { %> <%
                        if (i == nowPage) { %>
                        <div class="col-1"><span class="pointPage"><%=i%></span></div>
                        <%
                            }
                        %>
                        <%
                            if (i != nowPage) {
                        %>
                        <div class="col-1"><a class="toPurple" href="/searchList.do?nowPage=<%=i%>&cntPerPage=<%=cntPerPage%>&searchType=<%=searchType%>&keyword=<%=keyword%>&odType=<%=odType%>"><%=i%>
                        </a></div>
                        <%}%>
                        <%}%>
                        <%if (endPage != lastPage) { %>
                        <div class="col-1"><a class="toPurple" href="/searchList.do?nowPage=<%=endPage + 1%>&cntPerPage=<%=cntPerPage%>&searchType=<%=searchType%>&keyword=<%=keyword%>&odType=<%=odType%>">&gt;</a></div>
                        <%}%>

                    </div>

                    <!-- paging button 끝 -->

                </div>

                <a href="/myCart.do" class="btn view-btn1 mt-1">MY Favorite</a>

            </div>

            <!-- end Container -->
        </div>
    </div>
    <!-- 상품 리스트 + 검색 section 끝 -->

    <!--? Shop Method Start-->
    <div class="shop-method-area">
        <div class="container">
            <div class="method-wrapper">

            </div>
        </div>
    </div>
    <!-- Shop Method End-->
    </main>
    <!-- end Main -->
</div>

<script type="text/javascript">
    // 게시글 상세보기(상품번호를 전달받아 상세보기 페이지로 이동)
    function doDetail(seq) {
        location.href = "/noticeInfo.do?nSeq=" + seq;
    }
    function selChange() {
        // 한 페이지당 게시물 보기 개수를 세팅하여 전달
        // 기존의 보기 개수 + 검색어에 대한 페이징을 수행하기 위해 searchType, keyword를 함께 받아온다.
        var sel = document.getElementById('cntPerPage').value;
        // 선택한 option 값 받아오기
        var s = document.getElementById("searchType");
        var searchType = s.options[s.selectedIndex].value;
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
            location.href = "/searchList.do?nowPage=${paging.nowPage}&cntPerPage=" + sel;
        }
        // 검색어가 있는 상태로 페이징 변경을 요청했다면, 검색타입과 검색어를 함께 요청하여 새로 페이징함
        else if (searchType != "" || keyword != "") {
            // 정렬 타입이 지정되지 않았다면, 검색 결과값을 페이징 요청
            if (odType == "") {
                location.href = "/searchList.do?nowPage=${paging.nowPage}&cntPerPage=" + sel + "&searchType=" + searchType + "&keyword=" + keyword;
            }
            // 정렬 타입이 지정되었다면, 정렬 요청한 결과값을 페이징 요청
            else if (odType != "") {
                location.href = "/searchList.do?nowPage=${paging.nowPage}&cntPerPage=" + sel + "&searchType=" + searchType + "&keyword=" + keyword + "&odType=" + odType;
            }
        }
    }
    // 페이지가 로딩될 때 (검색, 페이징 등을 위한 정보 저장)
    $(document).ready(function () {
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
            resultMent = '<p class="font"><span class="font" style="color:#ff0000">' + keyword + "</span>에 대한 " + "총 <span style='color:blue'>" + total + "</span> 건의 검색 결과</p>";
            console.log("검색결과 멘트 : " + resultMent);
            // 검색한 상품이 있을 때에만 정렬 기능을 지원하므로, 기본 display:none 속성을 해제한다.
            $("#odType").show();
            res.innerHTML = resultMent;
            // 검색어가 존재하지 않으면, 전체 게시물 건수를 보여줌.
        } else if (keyword == "null") {
            console.log("전체 게시물 수 : " + total);
            var totalMent = '<p class="font">전체 <span style="color:blue">' + total + '</span> 건의 상품</p>';
            // nice-select 디자인에 속성이 바뀌어서 카테고리/정렬/페이징 순의 1번째 인덱스(0,1,2) 인 정렬을 숨김 처리
            // eq(index) -> 해당하는 인덱스 요소에 대해서만 적용, .odd / even(짝.홀수) / :first/last(처음.마지막)
            $(".nice-select:eq(1)").hide();
            res.innerHTML = totalMent;
        } else if (keyword != "null" && (searchType == "주소지" || searchType == "카테고리")) {
            console.log("검색된 게시물 수 : " + total);
            resultMent = '<p class="font">해당 ' + searchType + "<span style='color:#ff0000'>(" + keyword + ")</span>에 대한 " + "총 <span style='color:blue'>" + total + "</span> 건의 검색 결과</p>";
            console.log("검색결과 멘트 : " + resultMent);
            // 검색한 상품이 있을 때에만 정렬 기능을 지원하므로, 기본 display:none 속성을 해제한다.
            $("#odType").show();
            res.innerHTML = resultMent;
        }
    })
    // 검색 버튼 클릭 시, 값을 받아와 검색 실행
    $("#searchProduct").on("click", function () {
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
            Swal.fire('Input Something','검색 타입과 검색어를 입력해 주세요!','warning');
            document.getElementsByName("searchType")[0].focus();
            return false;
            // 검색 타입만 존재하지 않는 경우
        } else if (searchType == "") {
            console.log("검색 타입을 지정해 주세요.");
            Swal.fire('Check SearchType','검색 타입을 지정해 주세요!','warning');
            document.getElementsByName("searchType")[0].focus();
            return false;
        } else if (keyword == "") {
            console.log("검색어를 입력해 주세요.");
            Swal.fire('Check Keyword','검색어를 입력해 주세요!','warning');
            document.getElementById("keyword").focus();
            return false;
        }
    })
    // 정렬 타입을 클릭하면, 선택한 키워드값과 정렬타입을 저장한 채로 정렬 요청 url 전송
    $("#odType").on("change", function () {
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
            Swal.fire("실패했습니다!",'','error');
            return false;
        }
    })
    // 검색창을 클릭했을때, 로그인 상태로 검색 기록이 있는 사용자라면 최근검색어 리스트 제공
    $("#keyword").on("click", function () {
        var userno = <%=SS_USER_NO%>;
        console.log("세션 유저번호 있는지 체크 : " + userno);
        // 받아온 회원 정보가 있을 경우(로그인한 사용자인 경우), 최근검색어 불러오기 진행
        if (userno != null) {
            $.ajax({
                url: "/getKeyword.do",
                type: "post",
                success: function (data) {
                    console.log("data : " + data);
                    /*
                    * 최근검색어 목록 동적으로 생성하여 불러오기
                    */
                    var searchArr = new Array();
                    // 검색어 값들을 for문을 통해 배열에 저장
                    for (let i = data.length - 1; i >= 0; i--) {
                        searchArr.push(data[i]);
                    }
                    // remove() 요소 자체를 지움, empty 요소의 내용을 지움 -> empty()로 검색어 리스트(내용)를 지움
                    $("#list").empty();
                    console.log("기존 검색어 지우기 완료!");

                    // 최근검색어가 없을 경우에는 제공하지 않음(length가 0이 아닐때만 검색어 제공)
                    if (searchArr.length != 0) {
                        for (let i = 0; i < searchArr.length; i++) {
                            var searchKeyword = searchArr[i];
                            console.log("검색한 키워드 값 : " + searchKeyword);
                            // 검색어 목록을 list에 append 함
                            $("#list").append('<li class="font" id="' + i + '" onclick="insertKeyword(' + i + ')" >' + searchKeyword + '</li>');
                        }
                        $("#list").append('<button class="btn view-btn3 p-0" style="width:25px; height: 25px;" onclick="rmKeyword()"">X</button>');
                        $("#searchHistory").show();
                    }

                }
            })
        }
    })
    // 최근검색어 클릭 시, 검색어창에 자동 입력되게 하는 함수
    function insertKeyword(keywordId) {
        console.log("insertKeyword() 함수 호출!");

        console.log("받아온 id값 : " + keywordId);

        var value = document.getElementById(keywordId).innerHTML;
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
<link rel="stylesheet" href="/resource/css/notice.css?ver=2"/>

<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File -->
<%@ include file="../include/jsFile.jsp" %>
</body>
</html>