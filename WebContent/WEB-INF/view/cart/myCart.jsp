<%@ page import="poly.dto.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%
    List<CartDTO> rList = (List<CartDTO>) request.getAttribute("rList");
    if (rList == null) {
        rList = new ArrayList<CartDTO>();
    }

    int total = 0;
%>
<html>
<head>
    <title>관심상품</title>
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>
</head>

<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <!-- Header(상단 메뉴바 시작!) Start -->
    <%@ include file="../include/header.jsp"%>
    <!-- Header End(상단 메뉴바 끝!) -->

<a href="/index.do">메인으로</a>
<a href="/searchList.do">판매글 </a>
<a href="javascript:history.back()">뒤로가기</a>

<div class="container">

    <div id="cartCnt"></div>
    <div id="chk"><input name="allCheck" type="checkbox" id="allCheck"/>전체 선택></div>
    <div class="row">
        <% for (int i=0; i<rList.size(); i++) {
            CartDTO rDTO = rList.get(i);

            if (rDTO == null) {
                rDTO = new CartDTO();
            }

            total++;

         %>
        <div class="col">
            <input name="RowCheck" type="checkbox" id="del" value="<%=rDTO.getGoods_no()%>"/>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <img src="/resource/images/<%=rDTO.getImgs()%>" style="width: 150px; object-fit: contain" alt="이미지 불러오기 실패"/>
            </a>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <%=rDTO.getGoods_title()%>
            </a>
            <a href="/noticeInfo.do?nSeq=<%=rDTO.getGoods_no()%>">
                <%=rDTO.getGoods_price()%>원
            </a>
        </div>

        <% } %>
    </div>

    <input type="hidden" id="user_no" value="<%=SS_USER_NO%>"/>

    <button class="btn btn-warning" onclick="deleteValue()">상품 삭제</button>
    <!--<button class="btn btn-danger" id="delAll" onclick="deleteAll()">관심상품 전체 비우기</button>-->
</div>

<script type="text/javascript">
    var res = document.getElementById("cartCnt");
    var total = (<%=total%>);

    console.log("받아온 판매글 개수 : " + total);
    // console.log("String으로 변환되지 않는지? : " + typeof total);

    // 검색 결과가 없다면, 검색 결과가 없다는 멘트와 함께 상품 보러가기 페이지로 이동 링크를 띄운다.
    if (total == 0) {

        var resultMent = "<span style='color:#ff0000'>" + "검색 결과가 없습니다."  + "</span>"
        + "<br/>" + "<span style='color: blue'>" + "<a href='/searchList.do'>상품 보러가기</a>";

        console.log("관심상품 멘트 : " + resultMent);

        // 상품이 없다면, 상품이 있을때 표시하는 체크박스와 삭제 버튼을 표시하지 않음.
        $(".btn").hide();
        $("#chk").hide();

        res.innerHTML = resultMent;
    } else if (total != 0) {

        // 총 상품 건수와 함께, 판매글 목록을 표시함
        var resultMent = "총 " + "<span style='color:red'>" + "<%=total%>" + "</span>" + "건의 상품";

        console.log("관심상품 멘트 : " + resultMent);

        res.innerHTML = resultMent;
    }

    var user_no = document.getElementById("user_no").value;
    console.log("받아온 회원 번호 : " + user_no);

    // 체크박스 선택에 따라 전체 선택, 전체 해제, 다중 삭제 구현
    var chkObj = document.getElementsByName("RowCheck");
    var rowCnt = chkObj.length;


    //if ($("input[name='allCheck']").is(":checked") == true){

    // 전체 선택을 클릭한다면, 모든 rowCheck의 체크박스 value를 checked 로 변경
    $("input[name='allCheck']").click(function() {
        var chk_listArr = $("input[name='RowCheck']");
        for (var i=0; i<chk_listArr.length; i++) {
            chk_listArr[i].checked = this.checked;
        }
    });

    // 특정 체크박스를 선택하면, 모두 선택된 경우 allCheck를 활성화한다.
    // rowCnt는 전체 RowCheck의 length로 계산한다.(개수)
    $("input[name='RowCheck']").click(function() {
        if($("input[name='RowCheck']:checked").length == rowCnt) {
            $("input[name='allCheck']")[0].checked = true;

        } else {
            $("input[name='allCheck']")[0].checked = false;
        }
    });

    function deleteValue() {

        var valueArr = new Array();
        var list = $("input[name='RowCheck']");


        for(var i=0; i<list.length; i++) {
            if (list[i].checked){ //선택되어 있으면 배열에 값을 저장
                valueArr.push(list[i].value);

            }
        }

        console.log("배열에 담은 값 : " + valueArr);

        // 선택된 값이 없다면,
        if (valueArr.length == 0) {
            alert("선택된 관심상품이 없습니다.");
        }
        else {
            var chk = confirm("정말 삭제하시겠습니까?");
            if (chk) {
            $.ajax({
                url: "/deleteCart.do",
                type: "post",
                // 배열 형태를 넘기기 위해 사용(traditional 속성)
                // tranditional: true,
                data: {
                    "valueArr" : valueArr
                },
                // 삭제에 성공했다면, 삭제 성공 알림 및 상품을 다시 보러 갈 것을 confirm
                success: function(data) {
                    if (data == 1) {
                        var delConfirm = confirm("관심상품을 삭제하였습니다. 다른 상품을 보러 가시겠습니까?");
                        if (delConfirm) {
                            location.href = "/searchList.do";
                        } else {
                            window.location.reload();
                        }
                    } else {
                        alert("삭제에 실패했습니다.");
                    }
                }
            });
        } else {
                // 취소를 누른 경우, 삭제를 진행하지 않음
                return false;
            }
        }
    }

    // 전체 상품 비우기를 눌렀을 때 함수 실행
    /*function deleteAll() {

        console.log("삭제할 회원 번호(관심상품) : " + user_no);
        if (user_no != null) {

            var chkConfirm = confirm("정말 관심상품을 모두 삭제하시겠습니까?");

            if (chkConfirm) {
                $.ajax({
                    url: "/delCart.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        // 해당하는 회원 번호를 장바구니 전체 삭제를 위해 보냄
                        "user_no": user_no
                    },
                    success: function (data) {
                        // 삭제에 성공했다면,
                        var delConfirm = confirm("관심상품 목록을 비웠습니다. 상품을 보러 가시겠습니까?");

                        if (data > 0) {// 삭제된 수만큼 data를 반환하여, data==1이 아니라 data>0으로 한다.
                            if (delConfirm) {
                                location.href = "/searchList.do";
                            } else {
                                window.location.reload();
                            }
                        } else if (data == 0) {
                            alert("삭제에 실패했습니다.");
                            window.location.reload();
                        }
                    },

                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }
                })
            }
        } else {
            // 취소 누를 시, 전체상품 체크 해제
            $("input[name='allCheck']").checked = false;
        }
    }*/
</script>
<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/notice.css"/>

    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>
