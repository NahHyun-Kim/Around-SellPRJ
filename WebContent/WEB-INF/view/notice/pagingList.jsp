<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.dto.Criteria" %>
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
            // 한 페이지당 게시물 보기 개수를
            // 세팅하여 전달
            var sel = document.getElementById('cntPerPage').value;
            location.href = "/pagingList.do?nowPage=${paging.nowPage}&cntPerPage="+sel;
        }
    </script>
    <%
        Criteria pDTO = (Criteria) request.getAttribute("paging");

        int nowPage = pDTO.getNowPage();
        int startPage = pDTO.getStartPage();
        int endPage = pDTO.getEndPage();
        int cntPerPage  = pDTO.getCntPerPage();
        int lastPage = pDTO.getLastPage();
        int num = 1;

        List<NoticeDTO> sellList = (List<NoticeDTO>) request.getAttribute("sellList");

        if (sellList == null) {
            sellList = new ArrayList<NoticeDTO>();
        }

    %>
</head>
<body>
<div class="container">
    <div>
        <select id="cntPerPage" name="sel" onchange="selChange()">
            <option value="3" <%if (cntPerPage == 3) {%> selected <%}%>>3개씩 보기</option>
            <option value="6" <%if (cntPerPage == 6) {%> selected <%}%>>6개씩 보기</option>
            <option value="9" <%if (cntPerPage == 9) {%> selected <%}%>>9개씩 보기</option>
        </select>

        <!-- 판매글 리스트 -->
    <div class="row">
        <%
            for(int i=0; i<sellList.size(); i++) {
                NoticeDTO rDTO = sellList.get(i);

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
        <div>
            <select id="searchType" name="searchType">
                <option value="" selected disabled hidden>==카테고리를 선택하세요==</option>
                <option value="title">상품명</option>
                <option value="content">상품 설명</option>
                <option value="gaddr">상호명</option>
            </select>
            <input type="text" name="keyword" id="keyword"/>
            <button type="button" id="searchProduct" class="btn btn-info">검색하기</button>
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
                    <li><a href="/pagingList.do?nowPage=<%=startPage - 1%>&cntPerPage=<%=cntPerPage%>">&lt;</a>
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
                    <li><a
                            href="/pagingList.do?nowPage=<%=i%>&cntPerPage=<%=cntPerPage%>"><%=i%></a></li>
                    <%
                        }
                    %>
                    <%
                        }
                    %>
                    <%
                        if (endPage != lastPage) {
                    %>
                    <li><a
                            href="/pagingList.do?nowPage=<%=endPage + 1%>&cntPerPage=<%=cntPerPage%>">&gt;</a></li>
                    <%
                        }
                    %>

                </ul>
            </div>
        </div>
    </div>

<script type="text/javascript">
    $("#searchProduct").on("click", function() {
        var keyword = document.getElementById("keyword").value;
        console.log("가져온 키워드 : " + keyword);

        var searchType = document.getElementById('searchType').value;
        console.log("가져온 검색 타입 : " + searchType);

        if (keyword == "") {
            alert("검색어를 입력해 주세요.");
            document.getElementById("keyword").focus();
            return false;
        } else if (searchType = "") {
            alert("검색 타입을 지정해 주세요.");
            document.getElementById("searchType").focus();
            return false;
        } else { // 검색어, 타입이 모두 지정되어 검색을 눌렀을 때, 검색 실행
            location.href = "/pagingList.do?nowPage=1&cntPerPage=9&searchType="+searchType + "&keyword=" + keyword;
        }

    })
</script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
