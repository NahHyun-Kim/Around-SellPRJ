<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%
    NoticeDTO rDTO = (NoticeDTO) request.getAttribute("rDTO");

    // 정보를 불러오지 못했을 경우, 객체 생성
    if (rDTO == null) {
        rDTO = new NoticeDTO();
    }
    System.out.println("rDTO.getGoods_title() = " + rDTO.getGoods_title());
    System.out.println("rDTO.getGoods_addr2() 주소값 꼭 받아와야 함 = " + rDTO.getGoods_addr2());
    // 게시글 수정, 삭제 시 로그인&본인 여부 확인을 위한 세션값 받아오기
    String SS_USER_NO = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO"));

    // 로그인 여부&본인 여부를 판단하는 edit 변수 선언
    int edit = 1; // 1(작성자 아님), 2(본인이 작성), 3(로그인 안 함)

    // 로그인을 하지 않았다면(SS_USER_ID값이 null이라면)
    if (SS_USER_NO.equals("")) {
        edit = 3; // 로그인 안 함 표시

        // 세션으로 받아온 회원번호가 rDTO에서 가져온 회원번호와 같을 경우(=본인일 경우)
    } else if (SS_USER_NO.equals(rDTO.getUser_no())) {
        edit = 2;

    }

    System.out.println("SS_USER_NO : " + SS_USER_NO);
    System.out.println("user_no : " + rDTO.getUser_no());
%>
<html>
<head>
    <title>판매글 확인</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        // 게시글 수정하기
        function doEdit() {
            // 본인이라면(2), 수정 페이지로 이동
            if ("<%=edit%>" == 2) {
                location.href="/noticeEditInfo.do?nSeq=<%=rDTO.getGoods_no()%>";
                // 로그인이 안 된 상태라면
            } else if ("<%=edit%>" == 3) {
                alert("로그인 후 이용해 주세요.");
                location.href="/logIn.do";

            } else { // 본인이 아니라면(edit=1)
                alert("본인이 작성한 글만 수정이 가능합니다.");

            }
        }

        // 삭제하기
        function doDelete() {
            // 본인이라면(2), 삭제 확인을 물어본 후(confirm) 삭제
            if ("<%=edit%>" == 2) {
                if(confirm("판매글을 삭제하시겠습니까?")) {
                    location.href="/noticeDelete.do?nSeq=<%=rDTO.getGoods_no()%>";

                } else if ("<%=edit%>" == 3) { // 로그인이 안 된 상태라면
                    alert("로그인 후 이용해 주세요.");

                } else if ("<%=edit%>" == 1) { // 본인이 아니라면(edit=1) 삭제 불가능
                    alert("본인이 작성한 글만 삭제가 가능합니다.");
                }

            }
        }

        // 목록으로 이동하기
        function doList() {
            location.href="/noticeList.do";

        }

    </script>

</head>
<body>
    <div class="container">

        <!-- 판매글 상세조회 -->
        <!-- 추후 이미지 등록 예정 -->

        <!-- 조회수 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getHit()%>
            </div>
        </div>
        <!-- 카테고리 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getCategory()%>
            </div>
        </div>

        <!-- 상품명 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getGoods_title()%>
            </div>
        </div>

        <!-- 상호명 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getGoods_addr()%>
            </div>
        </div>

        <!-- 상품 설명 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getGoods_detail()%>
            </div>
        </div>

        <!-- 지도, 상호명, 위치, 거리 표시 -->
        <div class="row">
            <div class="col-6" id="map">지도 예정</div>
            <div class="col-6">
                <div class="row">
                    <div class="col" id="goods_addr">
                        <%=rDTO.getGoods_addr()%>
                    </div>
                </div>
                <div class="row">
                    <div class="col" id="goods_addr2" value="<%=rDTO.getGoods_addr2()%>">
                        <%=rDTO.getGoods_addr2()%>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        우리집으로부터 m(예정)
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <input type="button" onclick="return doEdit();" value="수정"/>
                        <input type="button" onclick="return doDelete();" value="삭제"/>
                        <input type="button" onclick="return doList();" value="목록으로"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 카카오지도 API js 파일-->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services,clusterer,drawing"></script>
    <script type="text/javascript" src="/resource/js/mapAPI.js"></script>

    <!-- bootstrap, css 파일 -->
    <link rel="stylesheet" href="/resource/css/notice.css"/>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>
</body>
</html>
