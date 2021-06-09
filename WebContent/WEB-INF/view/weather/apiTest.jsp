<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="../include/session.jsp"%>
<html>
<head>
    <title>api 호출여부 조회</title>
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
</head>
<body>
<script type="text/javascript">
    $(document).ready(function() {
        console.log("준비 완료");

        function getAir() {


        // session이 존재할 때만 실행(가입한 지역구 기반으로 대기정보 가져옴)
        if (<%=SS_USER_NO%> != null) {
            var user_addr = '<%=SS_USER_ADDR2%>';
            alert("회원 세션 지역구 : " + user_addr);

            $.ajax({
                url: "/getAir.do",
                type: "get",
                dataType: "json",
                success: function (json) {
                    console.log("json 받아오기 성공!" + json);
                    console.log(typeof json);

                    var resHTML = "";
                    var cnt = 0;

                    for (var i = 0; i < json.length; i++) {

                        if (json[i].msrstename == user_addr) {
                            resHTML += '<div>' + json[i].msrstename + '의 대기환경 상태는 ' + json[i].grade;
                            resHTML += '이며, 미세먼지 & 초미세먼지 농도는 : ' + json[i].pm10 + ' ' + json[i].pm25 + ' 입니다. (단위:㎍/㎥)</div>';
                            cnt++;
                        }

                    }

                    alert("총 결과 수 : " + cnt);

                    // 지역구에 해당하는 대기정보를 가져왔다면, 결과를 보여줌
                    if (cnt > 0) {
                        $("#apiRes").html(resHTML);
                    } else if (cnt == 0) {
                        // 서울시에 해당하지 않는 지역의 경우에는 불러오지 못했다는 문구를 대신 띄움
                        $("#apiRes").html("대기 정보를 불러오지 못했습니다");
                    }


                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                    console.log(errorThrown);
                }
            })
        }
        }
        })

</script>

<div id="apiRes"></div>
</body>
</html>
