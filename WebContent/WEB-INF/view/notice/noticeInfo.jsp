<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%
    NoticeDTO rDTO = (NoticeDTO) request.getAttribute("rDTO");

    // 정보를 불러오지 못했을 경우, 객체 생성
    if (rDTO == null) {
        rDTO = new NoticeDTO();
    }

    // 게시글 수정, 삭제 시 로그인&본인 여부 확인을 위한 세션값 받아오기
    String SS_USER_NO = CmmUtil.nvl((String) session.getAttribute("SS_USER_NO"));
    String SS_USER_ADDR = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR"));

    System.out.println("세션에서 받아온 회원 주소 = " + SS_USER_ADDR);
    System.out.println("rDTO.getGoods_addr2() 주소값 꼭 받아와야 함 = " + rDTO.getGoods_addr2());

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
        <!-- 이미지 -->
        <div class="row">
            <div class="col">
        <img class="thumb" src="/resource/images/<%=rDTO.getImgs()%>" style="width:350px;" alt="이미지 불러오기 실패">
            </div>
        </div>

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

        <!-- 상품 가격 -->
        <div class="row">
            <div class="col">
                <%=rDTO.getGoods_price()%>원
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
                    <!-- 거리 계산, 지도에 장소 표시를 위해 선언 -->
                    <div class="col" id="goods_addr2"><%=rDTO.getGoods_addr2()%></div>
                    <div class="col" style="display: none" id="user_addr"><%=SS_USER_ADDR%></div>
                    <div class="col" style="display: none"id="lat1"></div>
                    <div class="col" style="display: none" id="lon1"></div>
                    <div class="col" style="display: none" id="lat2"></div>
                    <div class="col" style="display: none" id="lon2"></div>
                </div>
                <div class="row">
                    <div class="col" id="distance">
                        <input type="button" id="searchD" onclick="return search()" value="거리 검색"/>
                    </div>
                    <div class="col" id="findpath"></div>
                </div>
                <div class="row">
                    <div class="col">
                        <button class="btn btn-info" type="button" id="doCart">관심상품 등록</button>
                        <input type="button" onclick="return doEdit();" value="수정"/>
                        <input type="button" onclick="return doDelete();" value="삭제"/>
                        <input type="button" onclick="return doList();" value="목록으로"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <input type="hidden" id="user_no" value="<%=SS_USER_NO%>"/>
    <input type="hidden" id="gn" value="<%=rDTO.getGoods_no()%>"/>
    <script type="text/javascript">
        // 장바구니 담기 클릭 시, 함수 실행
       $("#doCart").on("click", function() {

           var goods_nm = document.getElementById("gn").value;

           console.log("edit value(로그인 3이면 안함), 2면 본인(불가), 1이면 가능 : " + (<%=edit%>));
           console.log("받아온 상품 번호 : " + goods_nm);

           // 로그인 안 한 사용자라면, 로그인 후 관심상품 담기를 유도
           if ((<%=edit%>) == 3) {
               alert("로그인 후 이용해 주세요.");
               location.href="/logIn.do";
               return false;
           } else if ((<%=edit%>) == 2) {
               alert("본인이 작성한 글은 관심상품 등록이 불가능합니다.");
               return false;
           } else { // 로그인 한 작성자 본인이 아닌 일반 구매자라면, 관심상품 등록 허용
               // 로그인 한 사용자라면,
               $.ajax({
                   url: "/insertCart.do",
                   type: "post",
                   data: {
                       gn : goods_nm
                       //$("#gn").val
                   },
                   dataType: "JSON",
                   success: function(data) {
                       // insertCart가 성공했을 경우, res에 1을 반환
                       if (data == 1) {
                           confirm("관심상품 등록에 성공했습니다. 지금 확인하시겠습니까?");
                           // 예를 누를 경우, 관심상품 페이지로 이동
                           if (confirm){
                               location.href="/myCart.do";
                           }
                       } else {
                           alert("등록에 실패했습니다.");
                           return false;
                       }
                   },
                   // error catch
                   error : function(jqXHR, textStatus, errorThrown) {
                       alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                       console.log(errorThrown);
                   }
               })
           }
        })
    </script>
    <script type="text/javascript">
        function search() {
            var adr = "<%=SS_USER_ADDR%>";
            console.log("세션 주소 : " + adr);

        if (adr == "") {
            alert("로그인 후 이용해 주세요.");
            location.href="/logIn.do";
            } else {
        var lat1 = document.getElementById("lat1").innerText;
        var lon1 = document.getElementById("lon1").innerText;
        var lat2 = document.getElementById("lat2").innerText;
        var lon2 = document.getElementById("lon2").innerText;

        console.log("동작 확인(판매 위도) : " + lat1);
        console.log("동작 확인(유저 위도) : " + lat2);
        console.log("바뀜");

        var res = Math.ceil(calcDistance(lat1, lon1, lat2, lon2));

        console.log("우리집-판매 장소와의 거리 : " + res + "m");
        $("#distance").text("우리집으로부터의 거리는 : " + res + "m 입니다.");

        // 위, 경도 좌표값을 받아와 거리를 계산하는 함수
        function calcDistance(lat1, lon1, lat2, lon2)
            {
                var theta = lon1 - lon2;
                dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1))
                    * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
                dist = Math.acos(dist);
                dist = rad2deg(dist);
                dist = dist * 60 * 1.1515;
                dist = dist * 1.609344;
                return Number(dist*1000).toFixed(2);
            }

            function deg2rad(deg) {
                return (deg * Math.PI / 180);
            }
            function rad2deg(rad) {
                return (rad * 180 / Math.PI);
            }

            function getTimeHTML(res) {

            // 도보의 시속은 평균 4km/h 이고 도보의 분속은 67m/min입니다
            var walkkTime = res / 67 | 0;
            var walkHour = '', walkMin = '';

            // 계산한 도보 시간이 60분 보다 크면 시간으로 표시합니다
            if (walkkTime > 60) {
                walkHour = '<span class="number">' + Math.floor(walkkTime / 60) + '</span>시간 '
            }
            walkMin = '<span class="number">' + walkkTime % 60 + '</span>분'

            // 자전거의 평균 시속은 16km/h 이고 이것을 기준으로 자전거의 분속은 267m/min입니다
            var bycicleTime = res / 227 | 0;
            var bycicleHour = '', bycicleMin = '';

            // 계산한 자전거 시간이 60분 보다 크면 시간으로 표출합니다
            if (bycicleTime > 60) {
                bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>시간 '
            }
            bycicleMin = '<span class="number">' + bycicleTime % 60 + '</span>분'

            // 거리와 도보 시간, 자전거 시간을 가지고 HTML Content를 만들어 리턴
            var content = '<ul class="dotOverlay distanceInfo">';
            content += '    <li>';
            content += '        <span class="label">총거리</span><span class="number">' + res + '</span>m';
            content += '    </li>';
            content += '    <li>';
            content += '        <span class="label">도보</span>' + walkHour + walkMin;
            content += '    </li>';
            content += '    <li>';
            content += '        <span class="label">자전거</span>' + bycicleHour + bycicleMin;
            content += '    </li>';
            content += '</ul>'

                return content;
        }

        var content = getTimeHTML(res);
        console.log("content : " + content);

        $("#findpath").html(content);

        } }
    </script>
    <!-- 카카오지도 API js 파일-->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services,clusterer,drawing"></script>
    <script type="text/javascript" src="/resource/js/mapAPI.js"></script>

    <!-- bootstrap, css 파일 -->
    <style>
        #map {
            width: 350px;
            height: 200px;
            margin-top: 10px;
        }
    </style>
    <script src="/resources/js/bootstrap.js"></script>
    <link rel="stylesheet" href="/resources/css/bootstrap.css"/>

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>
</body>
</html>
