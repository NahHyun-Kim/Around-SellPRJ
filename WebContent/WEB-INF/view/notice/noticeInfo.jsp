<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.util.CmmUtil" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%
    NoticeDTO rDTO = (NoticeDTO) request.getAttribute("rDTO");

    String GOODS_NO = (String) rDTO.getGoods_no();
    System.out.println("가져온 상품번호 : " + GOODS_NO);

    // 정보를 불러오지 못했을 경우, 객체 생성
    /*if (rDTO == null) {
        rDTO = new NoticeDTO();
    }*/

    // 게시글 수정, 삭제 시 로그인&본인 여부 확인을 위한 세션값 받아오기
    String SS_USER_NO = CmmUtil.nvl(((String) session.getAttribute("SS_USER_NO")), "-1");
    String SS_USER_ADDR = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR"));
    String SS_USER_NAME = CmmUtil.nvl((String) session.getAttribute("SS_USER_NAME"));

    System.out.println("세션에서 받아온 회원 주소 = " + SS_USER_ADDR);
    System.out.println("rDTO.getGoods_addr2() 주소값 꼭 받아와야 함 = " + rDTO.getGoods_addr2());

    // 로그인 여부&본인 여부를 판단하는 edit 변수 선언
    int edit = 1; // 1(작성자 아님), 2(본인이 작성), 3(로그인 안 함)

    // 로그인을 하지 않았다면(SS_USER_ID값이 nvl 처리를 타고 -1 이라면)
    if (SS_USER_NO.equals("-1")) {
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
        $(document).ready(function() {

            // 댓글 리스트 가져오기
            getComment();

            var loginChk = "<%=CmmUtil.nvl(SS_USER_NO)%>";
            console.log("로그인 여부?(유저번호) : " + loginChk);

            // 로그인 상태로 판매글 상세보기를 로딩했다면, 최근 본 상품에 등록 진행
            if (loginChk != "-1") {
                $.ajax({
                    url: "/insertGoods.do",
                    type: "post",
                    data: {
                        "user_no" : loginChk,
                        "goods_no" : <%=rDTO.getGoods_no()%>,
                        "imgs" : "<%=rDTO.getImgs()%>",
                        "goods_title" :  "<%=rDTO.getGoods_title()%>"
                    },
                    success: function(data) {
                        if (data > 0) {
                            console.log("최근 본 상품 insert 성공!");
                        } else if (data == 0) {
                            alert("(최근 본 상품 insert) 실패!");
                        }
                    }
                })
            } else {
                console.log("로그인 안 함 또는 세션값 못받아옴 : " + loginChk);
            }
        })
    </script>
    <script type="text/javascript">

        // 댓글창(textarea) 클릭 시, 유효성 체크
        function validChk() {
            if ((<%=edit%>) == 3) { //로그인 하지 않은 사용자라면
                if (confirm("댓글 작성은 로그인한 사용자만 가능합니다. 로그인 후 이용 하시겠습니까?")) {
                    location.href = "/logIn.do";
                }
            }
        }

        // 댓글 등록 시 유효성 체크(댓글 등록 onclick시 실행)
        function doSubmit(){
            var comment = document.getElementById("comment").value;
            console.log("가져온 댓글 : " + comment);

            // 댓글이 입력되지 않았다면,
            if (comment == "") {
                alert("댓글을 입력해 주세요.");
                $("#comment").focus();
                return false;
            }

            if (calBytes(comment) > 3000) {
                alert("댓글은 최대 3000Bytes 까지 입력 가능합니다.");
                $("#comment").focus();
                return false;
            }

            $.ajax({
                url: "commentCnt.do",
                type: "post",
                data: {
                    "user_no" : <%=SS_USER_NO%>,
                    "goods_no" : <%=rDTO.getGoods_no()%>
                },
                success : function(res) {
                    console.log("댓글 몇개? : " + res);
                    if (res == 3) {
                        alert("한 게시물에 댓글은 3개까지 달 수 있습니다.");
                        return false;

                        // 댓글이 3개 이하라면, 댓글 등록 진행
                    } else if (res < 3) {

                        $.ajax({
                            url : "/insertComment.do",
                            type: "post",
                            dataType: "JSON",
                            data: {
                                "content" : comment,
                                "goods_no" : '<%=rDTO.getGoods_no()%>',
                                "user_no" : '<%=SS_USER_NO%>',
                                "user_name" : '<%=SS_USER_NAME%>'
                            },
                            success: function (data) {
                                if (data == 1) { //등록에 성공했다면
                                    alert("댓글이 등록되었습니다.");

                                    // 댓글이 등록되었다면, 기존 입력창에 썼던 내용을 초기화(placeholder만 남는다.)
                                    document.getElementById("comment").value = "";
                                    //window.location.reload() 는 판매글 전체가 다시 로딩되어 화면이동 없이 처리할 수 있는 ajax와 적합하지 않은 듯 함
                                    // 댓글 리스트를 가져오는 getComment() 함수를 통해 댓글 리스트만 다시 가져온다.
                                    getComment();
                                }
                                else if (data == 0) { // 등록에 실패했다면
                                    console.log("댓글 등록 실패!");
                                    return false;
                                }
                            },
                            // error catch!
                            error: function (jqXHR, textStatus, errorThrown) {
                                alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                                console.log(errorThrown);
                            }
                        })
                    }
                }
            })
            /**
             *  댓글 유효성에 문제가 없다면, ajax로 댓글 등록을 호출
             *  */
            //else {

            }
        //}

        //글자 길이 바이트 단위로 체크하기(바이트값 전달)
        function calBytes(str){
            var tcount = 0;
            var tmpStr = new String(str);
            var strCnt = tmpStr.length;
            var onechar;
            for (i=0;i<strCnt;i++){
                onechar = tmpStr.charAt(i);
                if (escape(onechar).length > 4){
                    tcount += 2;
                }else{
                    tcount += 1;
                }
            }
            return tcount;
        }

        /**
         * 등록된 댓글 가져오기(댓글 등록,수정,삭제,상세보기 페이지 로딩 시 사용)
         * */
        function getComment() {
            $.ajax({
                url : "/getComment.do",
                type : "post",
                dataType: "JSON", //json 형식으로 받아야 .으로 리스트에 접근 가능
                data: {
                    "goods_no" : '<%=rDTO.getGoods_no()%>'
                },
                // rList를 json이라는 이름으로 받음
                success: function (json) {
                    var comment_list = "";
                    var total = json.length;
                    var totalMent = "총 " + total + " 건의 댓글";

                    console.log("총 댓글 수 : " + total);

                    // rList로 댓글 리스트를 JSON 형태로 받아와, 전체 사이즈만큼 출력.
                    // json형태는 .변수명으로 값을 가져올 수 있다.
                    for (var i=0; i<json.length; i++) {
                        var comment_no = json[i].comment_no;
                        console.log("받아온 댓글번호 : " + comment_no);

                        comment_list += '<div>';
                        comment_list += ("작성자 : " + json[i].user_name+"<br>");
                        comment_list += (json[i].content+"<br>");

                        // 긍정, 부정 댓글에 따라 표시되는 이모티콘을 다르게함
                        if (json[i].polarity == "+") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/good.png" style="width:30px; height:30px" />';
                        } else if (json[i].polarity == "-") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/crying.png" style="width:30px; height:30px"/>';
                        } else if (json[i].polarity == "0") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/oing.png" style="width:30px; height:30px"/>';
                        }

                        // 본인이 작성한 댓글인 경우에만 수정, 삭제할 수 있도록 수정, 삭제 버튼을 표시함
                        if ((<%=SS_USER_NO%>) == (json[i].user_no))
                        {
                            console.log("SS_USER_NO == user_no(삭제 가능!)" + (json[i].user_no));
                            comment_list += '<button type="button" class="btn btn-info" onclick="editForm(' + comment_no + ')">수정</button><br>';
                            comment_list += '<button type="button" class="btn btn-danger" onclick="delComment(' + comment_no + ')">X</button><br>';
                        }
                        comment_list += '</div>';
                    }
                    $("#total").html(totalMent);
                    $("#comment_list").html(comment_list);
                }
            })
        }

        /** 댓글 삭제하기(해당 글에 대한 댓글번호를 함수 호출 시 파라미터로 전달하여,
        * ajax로 해당 댓글을 삭제한다.(삭제 or 수정 후 getComment() 불러오기)
         */
        function delComment(comment_no) {

            console.log("삭제할 댓글 번호(comment_no) : " + comment_no);
            var delConfirm = "댓글을 삭제하시겠습니까?";

            if (confirm(delConfirm)) {
                // 본인이 작성한 댓글에 대해서만 수정, 삭제 버튼이 표시되기 때문에 바로 ajax 삭제 진행
                $.ajax({
                    url : "delComment.do",
                    type : "post",
                    // 서버로 전송할 data(댓글번호)
                    data :
                        {
                            "comment_no" : comment_no
                        },

                    // 삭제에 성공했다면(data==1)
                    success: function(data) {
                        if (data == 1) {
                            alert("삭제에 성공했습니다.");
                            // 댓글 목록 불러오기
                            getComment();

                        } else if (data == 0) {
                            alert("삭제에 실패했습니다.");
                        }
                    },

                    // error catch!
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }
                }) // ajax 끝

            } // confirm 끝

        }

        /**
         * 댓글 수정을 위해 기존 댓글 불러오기
         * */
        function editForm(comment_no) {

            console.log("수정할 댓글 번호(comment_no) : " + comment_no);

            $.ajax({
                url : "getCommentDetail.do",
                type : "post",
                dataType : "JSON", //json 형태로 DTO를 받아 데이터를 뽑아올 수 있다.
                data : {
                    "comment_no" : comment_no
                },
                success : function(res) {
                    console.log("받아온 댓글 DTO 정보(json) : " + res);

                    /**
                     * 수정 체크 시, 기존 댓글 등록을 실행하면 새로운 댓글로 등록되기 때문에,
                     * 새로운 edit (댓글 수정) 버튼을 만들어서 기존의 등록 버튼을 지우고 수정 버튼을 보여준다.
                     * */
                    document.getElementById("regComment").style.display = "none";
                    document.getElementById("editComment").style.display = "block";
                    console.log("기존 등록 버튼 대신 수정 버튼 띄우기 성공!");

                    var originalComment = res.content;
                    var comment_no = res.comment_no;
                    console.log("기존 댓글 내용, 댓글 번호 : " + originalComment + comment_no);

                    // 기존 댓글 박스에(textarea) 기존 댓글을 넣고,
                    // button value값에 수정할 댓글 번호 값을 넣는다.(추후 더 효율적인 코드 찾아보기)
                    var commentBox = document.getElementById("comment");
                    var editBtn = document.getElementById("editComment");
                    commentBox.value = originalComment;
                    editBtn.value = comment_no;
                }
            })
        }

        /**
         * 댓글 수정 로직 ajax
         * */
        function editComment() {

            var comment = document.getElementById("comment").value;

            // 수정 버튼에 value로 등록되어 있는 comment_no 댓글번호를 가져옴
            var editBtn = document.getElementById("editComment");
            var comment_no = editBtn.value;

            console.log("댓글 번호 가져왔는지 : " + comment_no);

            // 댓글이 입력되지 않았다면,
            if (comment == "") {
                alert("댓글을 입력해 주세요.");
                $("#comment").focus();
                return false;
            }

            if (calBytes(comment) > 3000) {
                alert("댓글은 최대 3000Bytes 까지 입력 가능합니다.");
                $("#comment").focus();
                return false;
            }

            else {
                // 댓글 수정 ajax 로직 진행
                $.ajax({
                    url : "editComment.do",
                    type : "post",
                    dataType : "JSON",
                    data : {
                        "content" : comment,
                        "comment_no" : comment_no,
                        "user_name" : '<%=SS_USER_NAME%>'
                    },
                    // 성공했다면(data == 1, 수정 성공)
                    success : function(data) {
                        console.log("수정 성공! data가 1이라면 성공" + data);

                        if (data == 1) {
                            alert("댓글을 수정했습니다.");
                            // 댓글 목록 새로 가져오기
                            getComment();

                            // 수정을 위해 "등록(댓글 새로 insert)"과 "수정(댓글 내용 불러와서 edit)" 버튼을 바꿨으므로,
                            // 등록이 완료된 후 다시 화면에 새로운 댓글 등록창을 표시
                            document.getElementById("regComment").style.display = "block";
                            document.getElementById("editComment").style.display = "none";

                            // 댓글이 수정되었다면, 기존 입력창에 썼던 내용을 초기화(placeholder만 남는다.)
                            document.getElementById("comment").value = "";

                        } else if (data == 0) {
                            alert("댓글 수정에 실패했습니다.");
                            return false;
                        }
                    },
                    // error catch!
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                        console.log(errorThrown);
                    }

                })

            }

        }

        // 게시글 수정하기
        function doEdit() {
            // 본인이라면(2), 수정 페이지로 이동
            if ((<%=edit%>) == 2) {
                location.href="/noticeEditInfo.do?nSeq=<%=rDTO.getGoods_no()%>";
                // 로그인이 안 된 상태라면
            } else if ((<%=edit%>) == 3) {
                alert("로그인 후 이용해 주세요.");
                location.href="/logIn.do";

            } else { // 본인이 아니라면(edit=1)
                alert("본인이 작성한 글만 수정이 가능합니다.");

            }
        }

        // 게시물 삭제하기
        function doDelete() {
            console.log("edit이 2라면 삭제 가능, 1이면 본인 아님 : " + <%=edit%>);
            console.log(typeof (<%=edit%>));
            // 본인이라면(2), 삭제 확인을 물어본 후(confirm) 삭제
            if ((<%=edit%>) == 2) {
                if(confirm("판매글을 삭제하시겠습니까?")) {
                    location.href = "/noticeDelete.do?nSeq=<%=rDTO.getGoods_no()%>";
                }
             }  else if ((<%=edit%>) == 3) { // 로그인이 안 된 상태라면
                alert("로그인 후 이용해 주세요.");

        } else if ((<%=edit%>) == 1) { // 본인이 아니라면(edit=1) 삭제 불가능
            alert("본인이 작성한 글만 삭제가 가능합니다.");
        }
        }

        // 목록으로 이동하기
        function doList() {
            location.href="/searchList.do";

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
            <div class="col-6" id="map"></div>
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
                        <button type="button" id="findroad" onclick="return road()">길찾기</button>
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
        <!-- end 지도 관련 -->

        <div id="total"></div>
        <!-- 댓글 작성란(임시) -->
        <div class="row">
            <div class="col">작성자 : <%=SS_USER_NAME%></div>
        </div>
        <div class="row">
            <div class="col-6">
                <input type="textarea" name="comment" id="comment" onclick="validChk()" style="width: 200px; height:100px" placeholder="댓글을 입력하세요."/>
            </div>
            <div class="col-6">
                <button type="button" class="btn btn-info" id="regComment" onclick="doSubmit()">댓글 등록</button>
                <!-- 댓글 수정을 눌렀을 때만 버튼이 표시되도록 설정 -->
                <button type="button" class="btn btn-info" id="editComment" onclick="editComment()" style="display: none">댓글 수정</button>
            </div>
        </div>

        <div id="comment_list">해당 게시물에 대한 댓글이 없습니다.</div>

    </div>

    <input type="hidden" id="user_no" value="<%=SS_USER_NO%>"/>
    <input type="hidden" id="gn" value="<%=rDTO.getGoods_no()%>"/>
    <script type="text/javascript">
        // 장바구니 담기 클릭 시, 함수 실행
       $("#doCart").on("click", function() {

           var goods_nm = document.getElementById("gn").value;
           var user_no = document.getElementById("user_no").value;

           console.log("edit value(로그인 3이면 안함), 2면 본인(불가), 1이면 가능 : " + (<%=edit%>));
           console.log("받아온 상품 번호 : " + goods_nm);
           console.log("받아온 회원 번호 : " + user_no);

           // 로그인 안 한 사용자라면, 로그인 후 관심상품 담기를 유도
           if ((<%=edit%>) == 3) {
               alert("로그인 후 이용해 주세요.");
               location.href="/logIn.do";
               return false;
           } else if ((<%=edit%>) == 2) {
               alert("본인이 작성한 글은 관심상품 등록이 불가능합니다.");
               return false;
           } else { // 로그인 한 작성자 본인이 아닌 일반 구매자라면, 관심상품 등록 허용
               // 로그인 한 사용자라면, 이미 등록되었는지 확인 후 등록되지 않은 상품이면 등록 진행

               $.ajax({
                   url: "/cartChk.do",
                   type: "post",
                   data: {
                   "gn": goods_nm,
                       "user_no" : user_no
                   },
               dataType: "JSON",
                   success: function(res) {

                       console.log("중복이면 1, 아니면 0 : " + res);

                    if (res > 0) {
                        alert("이미 등록된 상품입니다.");
                        return false;
                    } else if(res == 0)// 등록되지 않은 상품이라면,
                    { // insert 실행
                        $.ajax({
                        url: "/insertCart.do",
                        type: "post",
                        data: {
                           "gn": goods_nm
                           //$("#gn").val
                        },
                       dataType: "JSON",
                       success: function (data) {
                           // insertCart가 성공했을 경우, res에 1을 반환
                           if (data == 1) {
                               // 예를 누를 경우, 관심상품 페이지로 이동
                               if (confirm("관심상품 등록에 성공했습니다. 지금 확인하시겠습니까?") == true) {
                                   location.href = "/myCart.do";
                               } else {
                                   return false;
                               }
                           } else {
                               alert("등록에 실패했습니다.");
                               return false;
                           }
                       },
                       // error catch
                       error: function (jqXHR, textStatus, errorThrown) {
                           alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                           console.log(errorThrown);
                       }
                   })
               }
           }
        })
        }})
    </script>
    <script type="text/javascript">

        var lat1 = document.getElementById("lat1").innerText;
        var lon1 = document.getElementById("lon1").innerText;
        var lat2 = document.getElementById("lat2").innerText;
        var lon2 = document.getElementById("lon2").innerText;

        // 길찾기를 눌렀을 때, 카카오 길찾기 페이지로 이동
        function road() {
            var url = "https://map.kakao.com/link/to/" + "<%=rDTO.getGoods_addr()%>," + lat1 + "," + lon1;
            console.log("url : " + url);

            window.open(url, '_blank');
        }

        function search() {
            var adr = "<%=SS_USER_ADDR%>";
            console.log("세션 주소 : " + adr);

        if (adr == "") {
            if (confirm("로그인한 사용자만 거리를 확인할 수 있습니다. 로그인 하시겠습니까?")) {
                location.href = "/logIn.do";
            }
        } else {
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
    <script type="text/javascript" src="/resource/js/mapAPI.js?ver=1"></script>

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
