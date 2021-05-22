<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String user_no = (String) session.getAttribute("SS_USER_NO");
    List<NoticeDTO> rList = (List<NoticeDTO>) request.getAttribute("rList");

    if (rList == null) {
        rList = new ArrayList<NoticeDTO>();
    }
%>
<html>
<head>
    <title>나의 판매글 조회하기</title>
    <!-- jquery -->
    <script src="/resource/js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript">
        function doDetail(seq) {
            location.href="/noticeInfo.do?nSeq=" + seq;
        }
    </script>
</head>
<body>
<div class="container">
    <button type="button" id="del" value="삭제하기" class="btn-danger">삭제하기</button>
    <div class="row">
        <%
            for(int i=0; i<rList.size(); i++) {
                NoticeDTO rDTO = rList.get(i);

                if (rDTO == null) {
                    rDTO = new NoticeDTO();
                }
        %>
        <div class="col">
            <div class="row">
                <input type="radio" name="del_num" id="del_num" value="<%=rDTO.getGoods_no()%>"/>
            </div>
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
    <a href="javascript:history.back()">뒤로가기</a>
    <a href="/index.do">메인으로</a>
</div>
</div>

<script type="text/javascript">
    // 삭제 버튼을 눌렀을때, 판매글 번호를 받아오고 confirm을 통해 재확인
    $("#del").on("click", function() {
        var num = document.getElementById("del_num").value;
        console.log("가져온 판매글 번호 : " + num);

        confirm("정말 삭제하시겠습니까?");

        // 예(=true)를 누른 경우, ajax 호출로 해당 판매글 삭제 실행
        if (confirm) {
            var sendData = "del_num="+num;

            // 판매글 번호를 넘겨 ajax 호출
            $.ajax({
                url : "/delMySell.do",
                type : "post",
                data : {
                    "del_num" : num
                },
                dataType : "JSON",
                success : function(res) {
                    console.log("res : " + res);
                    if (res == 1) {
                        alert("삭제에 성공했습니다.");
                        window.location.reload();
                    } else if (res == 0) {
                        alert("삭제에 실패했습니다.");
                        return false;
                    }
                },
                error : function(jqXHR, textStatus, errorThrown) {
                    alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                    console.log(errorThrown);
                }

            })
        } else {
            return false;
        }
    })
</script>

<!-- bootstrap, css 파일 -->
<script src="/resources/js/bootstrap.js"></script>
<link rel="stylesheet" href="/resources/css/bootstrap.css"/>

</body>
</html>
