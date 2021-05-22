<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="static poly.util.CmmUtil.nvl" %>
<%@ page import="java.util.List" %>
<%@ page import="poly.dto.UserDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.EncryptUtil" %>
<%@ page import="poly.util.CmmUtil" %>
<% UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
    String SS_USER_NO = (String) session.getAttribute("SS_USER_NO");
    if (rDTO == null) {
        rDTO = new UserDTO();
    }

    System.out.println("회원 정보 불러왔는지 테스트 : " + EncryptUtil.decAES128CBC(rDTO.getUser_email()));

    int getLogin = 1;

    if (!(SS_USER_NO.equals(rDTO.getUser_no()))) {
        getLogin = 2;
    }
%>
<html>
<head>
    <title>Around-Sell 회원정보 수정</title>
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <style>
        #map {
            width: 350px;
            height: 200px;
            margin-top: 10px;
            display: none
        }
    </style>
    <script type="text/javascript">
        // 작성자 본인 여부 체크
        function doOnload() {
            // 본인이 아닌, 타 사용자가 접근했다면
            if ("<%=getLogin%>" == "2") {
                alert("로그인 후 이용해 주세요.");
                location.href="/logIn.do";
            }
        }
    </script>
</head>
<body onload="doOnload()">
회원정보 수정 폼(테스트)
<a href="javascript:history.back();">뒤로가기</a>
<a href="/index.do">홈으로</a>

<div class="container">
    <!-- 회원정보 수정 폼 -->
    <form action="/updateUser.do" method="post" onsubmit="return doEditUser()">

        <!-- 업데이트할 회원 번호 받아오기 -->
        <input type="hidden" name="user_no" value="<%=rDTO.getUser_no()%>"/>

        <!-- 회원 이메일(변경 불가능, 읽기 전용으로 복호화하여 표시) -->
        <div class="form-control">
            <label for="user_email">회원 이메일</label>
            <input type="email" name="user_email" id="user_email" value="<%=EncryptUtil.decAES128CBC(rDTO.getUser_email())%>" readonly/>
        </div>

        <!-- 회원 이름 -->
        <div class="form-control">
            <label for="user_name">회원 이름</label>
            <input type="text" name="user_name" id="user_name" value="<%=rDTO.getUser_name()%>"/>
            <div class="check_font" id="name_check"></div>
        </div>

        <!-- 비밀번호 -->
        <div class="form-control">
            <label for="password_1">비밀번호</label>
            <input type="password" name="password" id="password_1" placeholder="기존 비밀번호를 입력해 주세요." required/>
            <div class="check_font" id="pw_check1"></div>
        </div>
        <!-- 비밀번호 변경 이용 시, 비밀번호 변경 페이지로 이동(기존 비밀번호와 일치 시에만 이동하도록 구현 예정) -->
        <!-- button에 함수를 주어, 일치할 경우에만 이동되도록 함 -->
        <script type="text/javascript">
            function doPwd() {
                var userinput = document.getElementById("password_1").value;
                var nowpass = document.getElementById("now_pw").value;
                console.log("현재 비밀번호 : " + nowpass);
                console.log("유저가 입력한 비밀번호 : " + userinput);

                var sendData = "password="+userinput;
                console.log("sendData : " + sendData);

                $.ajax({
                    url : "/pwdCheck.do",
                    type : "post",
                    dataType : "json",
                    data :  sendData,
                    success(data) {
                        if (data == 1) {
                            location.href = "editPwForm.do";
                        } else { //비밀번호가 일치하지 않다면
                            alert("기존 비밀번호를 확인해 주세요.");
                            return false;
                        }
                    },  error:function(jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }
                })
            }
        </script>
        <button type="button" onclick="doPwd()">비밀번호 변경하기</button>
        <input type="hidden" id="now_pw" value="<%=rDTO.getPassword()%>"/>

        <!-- 비밀번호 확인 -->
        <div class="form-control">
            <label for="password_2">비밀번호 확인</label>
            <input type="password" name="password_2" id="password_2" placeholder="비밀번호 확인을 입력해 주세요." required/>
            <div class="check_font" id="pw_check2"></div>
        </div>

        <!-- 회원 주소지 입력(변경) -->
        <div>
            <label for="sample5_address">주소 입력</label>
            <input type="text" name="addr" id="sample5_address" placeholder="주소를 검색해 주세요" value="<%=rDTO.getAddr()%>"/>
            <input type="button" onclick="sample5_execDaumPostcode()" value="주소 검색"/><br>
            <!-- 도로명주소 검색으로 선택한 거주 주소지를 표시하여 나타내는 지도(시각화 확인) -->
            <div id="map"></div>
        </div>

        <!-- 핸드폰 번호 변경 -->
        <div class="form-group">
            <label for="phone_no">핸드폰 번호</label>
            <input type="text" name="phone_no" id="phone_no" placeholder="핸드폰 번호를 입력해 주세요." value="<%=rDTO.getPhone_no()%>"/>
            <div class="check_font" id="phone_check"></div>
        </div>

        <input type="submit" value="수정하기" />
        <input type="reset" value="다시 작성하기" />
        <a href="javascript:history.back();">뒤로가기</a>

    </form>

    <button type="button" id="user_no" value="<%=CmmUtil.nvl(rDTO.getUser_no())%>" onclick="deleteUser();">탈퇴하기</button>
    <script type="text/javascript">
        function deleteUser() {
            console.log("user value : " + $("#user_no").val())
            if (confirm('정말 탈퇴하시겠습니까? 탈퇴 시, 작성한 판매글도 함께 삭제됩니다.')) {
                $.ajax({
                    url: "/deleteForceUser.do",
                    type: "post",
                    dataType: "json",
                    data: {
                        "user_no": $("#user_no").val()
                    },
                    success: function (data) {
                        if (data > 0) {
                            alert("탈퇴가 완료되었습니다. 떠나신다니 아쉽습니다.");
                            location.href="/logIn.do";
                            return true;
                        }
                        else {
                            alert("탈퇴에 실패했습니다.");
                            window.location.reload()
                            return false;
                        }
                    }
                });
            }
        };
    </script>
</div>
<script type="text/javascript" src="/resource/valid/userCheck.js"></script>

<!-- bootstrap, css 파일 -->
<link rel="stylesheet" href="/resource/css/user.css"/>
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

<!-- 도로명주소 API js 파일-->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services"></script>
<script type="text/javascript" src="/resource/js/addrAPI2.js"></script>

</body>
</html>
