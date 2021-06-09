<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="java.util.List" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% List<UserDTO> rList = (List<UserDTO>) request.getAttribute("rList");
    if (rList == null) {
        rList = new ArrayList<UserDTO>();
    }

    // 관리자만 회원 관리 가능
    String admin_no = (String) session.getAttribute("SS_USER_NO");

    int edit = 1; //1이면 회원 아님, 2이면 관리자 아님, 3이면 관리자
    if (admin_no == "") {
        edit = 1;
    } else if (admin_no.equals("0")) {
        edit = 3;
    } else {
        edit = 2;
    }

    /* body doOnload(); 로 체크
    * <script type="text/javascript">
    * if ((edit>) == 1){
        alert("로그인 후 이용해 주세요");
        * location.href="/logIn.do";
        * } else if((edit>) == 2) {
        * alert("관리자만 권한을 가질 수 있습니다.");
        * location.href="/logOut.do";
        * }
     */
%>
<html>
<head>
    <title>AroundSell- 회원 관리</title>
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

<!-- wordCloud 디자인용(로그인, 회원가입, 비밀번호 찾기 시 사용) -->
<%@ include file="../include/wordcloudForDesign.jsp"%>


    <input name="allCheck" type="checkbox" id="allCheck"/>전체 선택

    <div class="container">
        <h1>회원 관리 - 리스트 조회</h1>
        <div class="row">
            <div class="col-3 text-center"><b>회원 번호</b></div>
            <div class="col-2 text-center"><b>회원 이름</b></div>
            <div class="col-3 text-center"><b>가입일</b></div>
            <div class="col-2 text-center"><b>주소지</b></div>
        </div>

        <% int i=1;
        for(UserDTO r : rList) { %>
        <div class="row">
            <input name="RowCheck" type="checkbox" id="del" value="<%=r.getUser_no()%>"/>
            <div id="user_no" class="col-3 text-center"><%=CmmUtil.nvl(r.getUser_no())%></div>
            <div class="col-2 text-center"><a href="/getUserDetail.do?no=<%=r.getUser_no()%>"><%=CmmUtil.nvl(r.getUser_name()) %></a></div>
            <div class="col-3 text-center"><%=CmmUtil.nvl(r.getReg_dt()) %></div>
            <div class="col-2 text-center"><%=CmmUtil.nvl(r.getAddr2()) %></div>
        </div>
        <% i++;} %>

        <button class="btn btn-warning" onclick="deleteUser()">회원 삭제</button>
   </div>

    <script type="text/javascript">
        var res = document.getElementById("user_no").value;

        // 체크박스 선택에 따라 전체 선택, 전체 해제, 다중 삭제 구현
        var chkObj = document.getElementsByName("RowCheck");
        var rowCnt = chkObj.length;

        $("input[name='allCheck']").click(function() {
            var chk_listArr = $("input[name='RowCheck']");
            for(var i=0; i<chk_listArr.length; i++) {
                chk_listArr[i].checked = this.checked;
            }
        });

        // 모두 선택된 경우(rowCnt == RowCheck:checked length 와 같은 경우)에는 allCheck 활성화
        $("input[name='RowCheck']").click(function() {
            if($("input[name='RowCheck']:checked").length == rowCnt) {
                $("input[name='allCheck']")[0].checked = true;
            } else {
                $("input[name='allCheck']")[0].checked = false;
            }
        });

        function deleteUser() {

            // 다중 회원 삭제를 대비하여, 회원번호를 담을 배열 생성
            var valueArr = new Array();
            var list = $("input[name='RowCheck']");

            for (var i=0; i<list.length; i++) {
                if (list[i].checked) {
                    //선택되어 있는 회원번호를 valueArr에 push로 담음
                    valueArr.push(list[i].value);

                }
            }

            console.log("배열에 담은 회원번호 : " + valueArr);

            // 선택된 값이 없다면,
            if (valueArr.length == 0) {
                alert("선택한 회원이 없습니다.");

            }
            else {
                var chk = confirm("정말 삭제하시겠습니까? 회원의 판매글도 함께 삭제됩니다.");
                if (chk) {
                    $.ajax({
                        url : "/deleteUser.do",
                        type : "post",
                        data: {
                            // 배열에 담은 회원번호를 Controller로 전송하여, 삭제 진행
                            "valueArr" : valueArr
                        },
                        // 삭제에 성공했다면, 회원 목록 새로고침
                        success: function(data){
                            if (data == 1) {
                                alert("삭제에 성공했습니다.");
                                window.location.reload();
                            } else {
                                alert("삭제에 실패했습니다.");
                            }
                        },
                        error:function(jqXHR, textStatus, errorThrown) {
                            alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                            console.log(errorThrown);
                        }
                    })
                }
            }
        }
    </script>
<!-- include Footer -->
<%@ include file="../include/footer.jsp"%>

<!-- include JS File Start -->
<%@ include file="../include/jsFile.jsp"%>
<!-- include JS File End -->
</body>
</html>
