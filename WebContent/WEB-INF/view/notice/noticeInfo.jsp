<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="poly.dto.NoticeDTO" %>
<%@ page import="poly.util.CmmUtil" %>
<%
    NoticeDTO rDTO = (NoticeDTO) request.getAttribute("rDTO");

    String GOODS_NO = (String) rDTO.getGoods_no();
    System.out.println("가져온 상품번호 : " + GOODS_NO);

    // 게시글 수정, 삭제 시 로그인&본인 여부 확인을 위한 세션값 받아오기
    String SS_USER_NO = CmmUtil.nvl(((String) session.getAttribute("SS_USER_NO")), "-1");
    String SS_USER_ADDR = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR"));
    String SS_USER_NAME = CmmUtil.nvl((String) session.getAttribute("SS_USER_NAME"));
    String SS_USER_ADDR2 = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR2"));

    System.out.println("세션 주소값 : " + SS_USER_NAME);

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
    <!-- 부트스트랩 템플릿 CSS -->
    <%@ include file="../include/cssFile.jsp"%>

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
                            console.log("(최근 본 상품 insert) 실패!");
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
                Swal.fire({
                    title : 'Login Plz',
                    text: '댓글 작성은 로그인한 사용자만 가능합니다. 로그인 하시겠습니까?',
                    icon : "question",
                    confirmButtonText : "네!",
                    confirmButtonColor : 'skyblue',
                    showCancelButton: true,
                    cancelButtonText: '아니오'

                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = "/logIn.do"

                    }
                })
            }
        }

        // 댓글 등록 시 유효성 체크(댓글 등록 onclick시 실행)
        function doSubmit(){
            var comment = document.getElementById("comment").value;
            console.log("가져온 댓글 : " + comment);

            // 댓글이 입력되지 않았다면,
            if (comment == "") {
                Swal.fire('댓글을 입력해 주세요','','warning');
                $("#comment").focus();
                return false;
            }

            if (calBytes(comment) > 3000) {
                Swal.fire('Too Long','댓글은 최대 3000Byte까지 입력이 가능합니다.','warning');
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
                        Swal.fire('댓글 제한','한 게시물에 댓글은 3개까지 달 수 있습니다.','info');
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
                                    Swal.fire('댓글이 등록되었습니다!','','success');

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

            }

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

                    comment_list += '<section class="blog_area single-post-area section-padding"><div class="container"><div class="row"><div class="col-lg-3 posts-list"></div>';

                    // rList로 댓글 리스트를 JSON 형태로 받아와, 전체 사이즈만큼 출력.
                    // json형태는 .변수명으로 값을 가져올 수 있다.
                    for (var i=0; i<json.length; i++) {
                        var comment_no = json[i].comment_no;
                        console.log("받아온 댓글번호 : " + comment_no);

                        comment_list += '<div class="col-lg-6 posts-list"><div class="blog-author toShadow"><div class="media align-items-center">';
                        <%--comment_list += '<div>';--%>
                        <%--comment_list += ("작성자 : " + json[i].user_name+"<br>");--%>
                        <%--comment_list += (json[i].content+"<br>");--%>

                        // 긍정, 부정 댓글에 따라 표시되는 이모티콘을 다르게함
                        if (json[i].polarity == "+") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/good.png" style="width:30px; height:30px" />';
                        } else if (json[i].polarity == "-") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/crying.png" style="width:30px; height:30px"/>';
                        } else if (json[i].polarity == "0") {
                            comment_list += '<img src="${pageContext.request.contextPath}/resources/assets/img/oing.png" style="width:30px; height:30px"/>';
                        }

                        comment_list += '<div class="media-body"><h4>';
                        comment_list += '작성자 : ' + json[i].user_name + '</h4>';
                        comment_list += '<p>' + json[i].content + '</p></div></div></div></div>';

                        <%--// 본인이 작성한 댓글인 경우에만 수정, 삭제할 수 있도록 수정, 삭제 버튼을 표시함--%>
                        <%--if ((<%=SS_USER_NO%>) == (json[i].user_no))--%>
                        <%--{--%>
                        <%--    console.log("SS_USER_NO == user_no(삭제 가능!)" + (json[i].user_no));--%>
                        <%--    comment_list += '<button type="button" class="btn view-btn3 font ml-2" onclick="editForm(' + comment_no + ')">수정</button> &nbsp;';--%>
                        <%--    comment_list += '<button type="button" class="btn view-btn3 font" onclick="delComment(' + comment_no + ')">X</button><br>';--%>
                        <%--}--%>
                        <%--comment_list += '</div><hr/>';--%>


                    }
                        comment_list += '<div class="col-lg-3 posts-list"></div></div></div></section>';
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

            Swal.fire({
                title : '댓글을 삭제하시겠습니까?',
                icon : "question",
                confirmButtonText : "네!",
                confirmButtonColor : 'skyblue',
                showCancelButton: true,
                cancelButtonText: '아니오'

            }).then((result) => {
                if (result.isConfirmed) {
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
                                Swal.fire('삭제에 성공했습니다.','','success');
                                // 댓글 목록 불러오기
                                getComment();

                            } else if (data == 0) {
                                Swal.fire('삭제에 실패했습니다.','','error');
                            }
                        },

                        // error catch!
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert("에러 발생! \n" + textStatus + ":" + errorThrown);
                            console.log(errorThrown);
                        }
                    }) // ajax 끝
                }
            })

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
                Swal.fire('Input Comment','댓글을 입력해 주세요!','warning');
                $("#comment").focus();
                return false;
            }

            if (calBytes(comment) > 3000) {
                Swal.fire('Too Long','댓글은 최대 3000Byte까지 입력이 가능합니다.','warning');
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
                            Swal.fire('댓글을 수정했습니다!','','success');
                            // 댓글 목록 새로 가져오기
                            getComment();

                            // 수정을 위해 "등록(댓글 새로 insert)"과 "수정(댓글 내용 불러와서 edit)" 버튼을 바꿨으므로,
                            // 등록이 완료된 후 다시 화면에 새로운 댓글 등록창을 표시
                            document.getElementById("regComment").style.display = "block";
                            document.getElementById("editComment").style.display = "none";

                            // 댓글이 수정되었다면, 기존 입력창에 썼던 내용을 초기화(placeholder만 남는다.)
                            document.getElementById("comment").value = "";

                        } else if (data == 0) {
                            Swal.fire('댓글 수정에 실패했습니다.','','error');
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
                Swal.fire({
                    title : '로그인 후 이용해 주세요',
                    icon : "info",
                    showCancelButton : true,
                    confirmButtonText : "로그인",
                    cancelButtonText : "그냥 볼래요"
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = "/logIn.do"
                    }
                })

            } else { // 본인이 아니라면(edit=1)
                Swal.fire("본인이 작성한 글만 수정이 가능합니다.",'','warning');

            }
        }

        // 게시물 삭제하기
        function doDelete() {
            console.log("edit이 2라면 삭제 가능, 1이면 본인 아님 : " + <%=edit%>);
            console.log(typeof (<%=edit%>));
            // 본인이라면(2), 삭제 확인을 물어본 후(confirm) 삭제
            if ((<%=edit%>) == 2) {
                Swal.fire({
                    title : 'Around-Sell',
                    text : '판매글을 삭제하시겠습니까?',
                    icon : "question",
                    showCancelButton : true,
                    confirmButtonText : "네! 삭제할래요",
                    cancelButtonText : "아니오"
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = "/noticeDelete.do?nSeq=<%=rDTO.getGoods_no()%>";
                    }
                })

             }  else if ((<%=edit%>) == 3) { // 로그인이 안 된 상태라면
                Swal.fire("로그인 후 이용해 주세요.",'','warning');

        } else if ((<%=edit%>) == 1) { // 본인이 아니라면(edit=1) 삭제 불가능
            Swal.fire("본인이 작성한 글만 삭제가 가능합니다.",'','warning');
        }
        }

        // 목록으로 이동하기
        function doList() {
            location.href="/searchList.do";

        }

    </script>

</head>
<body>
    <!-- preloader -->
    <%@ include file="../include/preloader.jsp"%>
    <!-- preloader End -->

    <header>
        <div class="header-area">
            <div class="main-header header-sticky" style="box-shadow: 0 10px 15px rgba(25, 25, 25, 0.1);">
                <!--<div class="main-header header-sticky" style="border-bottom: 1px solid #E5E5E5; box-shadow:3px 3px 4px lightgrey;">-->
                <div class="container-fluid">
                    <div class="menu-wrapper">
                        <!-- aroundSell mainPage Top(로고+돋보기(=검색창 이동) -->
                        <div class="logo">
                            <a href="/getIndex.do"><img src="/resources/boot/img/logo/aroundsell_main.png" alt=""
                                                        style="width:170px;height: 48px;"></a>
                            <img class="search-switch" id="findlogo" src="/resources/boot/img/logo/aroundsell_find.png"
                                 style="margin-left: 12px; width: 30px; height: 35px; padding-bottom: 3px;"/>
                        </div>

                        <!-- aroundSell 메인 메뉴바-->
                        <div class="main-menu d-none d-lg-block" style="height:106px;">
                            <nav>
                                <ul id="navigation">
                                    <!-- 홈페이지(index), 워드클라우드와 전체 판매글을 표시한다.-->
                                    <li><a href="/getIndex.do">Home</a></li>

                                    <!-- 상품 등록 검색 결과를 제공하는 shop&Search -->
                                    <li><a href="/searchList.do">Shop & Search</a>
                                        <ul class="submenu">
                                            <li><a href="/searchList.do"> 상품 찾기</a></li>
                                            <li><a href="/noticeForm.do"> 판매글 등록하기</a></li>
                                        </ul>
                                    </li>

                                    <!-- 인기 상품 시각화 차트정보를 제공하는 Chart -->
                                    <li class="hot"><a href="#">Chart</a>
                                        <ul class="submenu">
                                            <li><a href="/wordCloud.do"> 워드 클라우드</a></li>
                                            <li><a href="/chart.do"> 인기 차트 </a></li>
                                        </ul>
                                    </li>

                                    <!-- 관심상품과 최근 본 상품 메뉴 -->
                                    <li><a href="#">Cart</a>
                                        <ul class="submenu">
                                            <li><a href="javascript:cartChk()">관심상품</a></li>
                                            <li><a href="javascript:seeChk()">최근 본 상품</a></li>
                                        </ul>
                                    </li>

                                    <!-- 로그아웃(혹은 로그인&회원가입), 회원 정보를 제공하는 메뉴 -->
                                    <% if (SS_USER_NO.equals("-1")) { %>
                                    <li><a href="#">LogIn / SignUp</a>
                                        <ul class="submenu">
                                            <li><a href="/logIn.do">로그인</a></li>
                                            <li><a href="/signup.do">회원가입</a></li>
                                            <li><a href="/userSearch.do">FIND ID/PW</a></li>
                                        </ul>
                                    </li>
                                    <% } else if (!SS_USER_NO.equals("-1") && !SS_USER_NO.equals("0")){ %>
                                    <li><a href="/myList.do">MyPage</a>
                                        <ul class="submenu">
                                            <li><a href="/logOut.do">로그아웃</a></li>
                                            <li><a href="javascript:doPassword()">개인정보 수정</a></li>
                                            <li><a href="/myList.do">마이페이지</a></li>
                                            <li><a href="/noticeForm.do">판매글 등록하기</a></li>
                                        </ul>
                                    </li>
                                    <% } else if (!SS_USER_NO.equals("-1") && SS_USER_NO.equals("0")) {%>
                                    <li><a href="/getUser.do">관리자 페이지</a>
                                        <ul class="submenu">
                                            <li><a href="/logOut.do">로그아웃</a></li>
                                            <li><a href="javascript:doPassword()">관리자 정보수정</a></li>
                                            <li><a href="/myList.do">마이페이지</a></li>
                                            <li><a href="/getUser.do">관리자 페이지</a></li>
                                        </ul>
                                    </li>
                                    <% } %>
                                </ul>
                            </nav>
                        </div>
                        <!-- 메뉴바 끝 -->

                        <!-- Header Right -->
                        <div class="header-right" style="padding-top:10px;">
                            <ul id="headers">
                                <li>
                                    <% if (!SS_USER_NO.equals("-1")) { %>
                                    <div class="header-chk font" style="color: #d0a7e4;">
                                        <%=CmmUtil.nvl(SS_USER_NAME)%>님&nbsp;(<%=CmmUtil.nvl(SS_USER_ADDR2)%>)
                                    </div>
                                    <% } else { %>
                                    <div class="header-chk"><a id="getLogin" href="/logIn.do">로그인 후 이용하세요</a></div>
                                    <% } %>
                                </li>
                                <!--<li><a href="/myCart.do"><span class="flaticon-shopping-cart"></span></a> </li>-->
                            </ul>
                        </div>
                    </div>
                    <!-- Mobile Menu -->
                    <div class="col-12">
                        <div class="mobile_menu d-block d-lg-none"></div>
                    </div>
                </div>
            </div>
        </div>

        <!--? Search model Begin -->
        <div class="search-model-box">
            <div class="h-100 d-flex align-items-center justify-content-center">
                <div class="search-close-btn">+</div>
                <div class="search-model-form">
                    <input type="text" id="search-input" placeholder="찾고싶은 상품을 입력하세요" onkeydown="if (event.keyCode == 13) search()"/>
                </div>
            </div>
        </div>
        <!-- Search model end -->
    </header>

    <style>
        .header-chk #getLogin {
            font-family: 'Noto Sans KR';
        }

        .imgStyle {
            width: 500px; height: 500px; display: block; margin-left: auto; margin-right: auto;
            box-shadow: 2px 2px 3px 3px rgba(0, 0, 0, 0.2);
        }
        @media (max-width: 892px) {
            .imgStyle {
                margin-top: 200px;
            }
        }

        #map {
            width: 500px; height: 300px; display: block; margin: 0 auto;
        }

        .dotOverlay distanceInfo {
            font-family: "Noto Sans KR";
        }

        .toShadow {
            box-shadow: 2px 2px 3px 3px rgba(0, 0, 0, 0.2);
            border-radius: 2%;
        }

    </style>

    <main>

        <section class="blog_area single-post-area section-padding">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3 posts-list"></div>
                    <div class="col-lg-6 posts-list">
                        <div class="blog-author toShadow">
                            <div class="media align-items-center">
                                <img src="assets/img/blog/author.png" alt="">
                                <div class="media-body">
                                        <h4>Harvard milan</h4>
                                    <p style="text-align: center;">댓글</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 posts-list"></div>
                </div>
            </div>
        </section>
        <!--================Single Product Area =================-->
        <div class="product_image_area">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-12">
                            <div class="single_product_img">
                                <img src="/resource/images/<%=rDTO.getImgs()%>" alt="이미지 불러오기 실패!" class="img-fluid imgStyle"/>
                            </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="single_product_text text-center">

                            <hr/>
                            <div class="blog_right_sidebar">
                                <aside class="single_sidebar_widget post_category_widget toShadow">
                                    <br/>
                                    <h3 class="widget_title mt-10 fontPoor"><%=rDTO.getGoods_title()%></h3>
                                    <br/>
                                    <div id="infoInput"></div>

                                    <!-- 판매상품 정보 출력 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="goods_price" class="font">판매 가격</label>
                                        <input class="form-control font Center" id="goods_price" type="text"
                                               readOnly/>
                                    </div>

                                    <script type="text/javascript">
                                        $("#goods_price").val(numberWithCommas(<%=rDTO.getGoods_price()%>) + '원');

                                        <!-- 가격 콤마로 표시하는 함수-->
                                        function numberWithCommas(x) {
                                            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                                        }
                                    </script>

                                    <!-- 상호명 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="StoreName" class="font Center">상호명</label>
                                        <input class="form-control font Center" id="StoreName" type="text"
                                               value="<%=rDTO.getGoods_addr()%>" readOnly/>
                                    </div>

                                    <!-- 상세 주소지 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="FullAddr" class="font Center">주소지</label>
                                        <input class="form-control font Center" id="FullAddr" type="text"
                                               value="<%=rDTO.getGoods_addr2()%>" readOnly/>
                                    </div>

                                    <!-- 카테고리 -->
                                    <div class="col-md-12 form-group p_star">
                                        <label for="categories" class="font Center">카테고리</label>
                                        <input class="form-control font Center" id="categories" type="text"
                                               value="<%=rDTO.getCategory()%>" readOnly/>
                                    </div>

                                </aside>
                            </div>

                                    <hr/>
                            <p class="font">상품 설명<br/>
                                <%=rDTO.getGoods_detail()%></p>
                            <br/>
                            <hr/>
                            <div class="col" style="display: none" id="user_addr"><%=SS_USER_ADDR%></div>
                            <div class="col" style="display: none" id="lat1"></div>
                            <div class="col" style="display: none" id="lon1"></div>
                            <div class="col" style="display: none" id="lat2"></div>
                            <div class="col" style="display: none" id="lon2"></div>

                            <div class="col font" id="goods_addr" style="display: none;"><%=rDTO.getGoods_addr()%></div>
                            <div class="col font" id="goods_addr2" style="display: none;"><%=rDTO.getGoods_addr2()%></div>
                            <div class="col font" id="category" style="display: none;"><%=rDTO.getCategory()%></div>

                            <h2><img src="/resources/boot/img/logo/aroundsell_sub.png" alt=""
                                     style="width:300px;height: 85px;"></h2>
                            <br/>
                            <div id="map"></div>
                            </p>
                            <div class="card_area">
                                <div class="add_to_cart">
                                    <a href="javascript:doCart('<%=rDTO.getGoods_no()%>', <%=rDTO.getUser_no()%>)" class="btn_3 font" id="doCart" style="font-family: 'Noto Sans KR'; color: white;">관심상품 등록</a>
                                    <a href="javascript:road()" class="btn_3 font" id="findroad">길찾기</a>
                                    <a href="javascript:searchDistance()" class="btn_3 font" id="searchD">거리 계산하기</a>

                                    <!-- 로그인한 경우에만 사전결제 서비스를 제공 -->
                                    <%if (!SS_USER_NO.equals("-1")) { %>
                                    <button type="button" class="btn_3 font" onclick="getPay()">사전 결제</button>
                                    <% } %>
                                    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>

                                    <script>

                                        function getPay() {

                                            Swal.fire({
                                                icon: 'question',
                                                text: '사전 결제 후, 매장 방문하여 물품을 수령할 수 있습니다. 결제하시겠습니까?',
                                                showConfirmButton: true,
                                                confirmButtonText: '네. 결제할래요',
                                                showCancelButton: true,
                                                cancelButtonText: '아니오, 그냥 볼래요.'
                                            }).then(value => {
                                                // 결제를 요청한 경우에만 결제 진행
                                                if (value.isConfirmed) {
                                                    // 부여받은 가맹점 식별코드
                                                    IMP.init('imp14361922');

                                                    IMP.request_pay({
                                                        pg: 'kakao', // version 1.1.0부터 지원.
                                                        pay_method: 'card',
                                                        merchant_uid: 'merchant_' + new Date().getTime(),
                                                        name: '<%=rDTO.getGoods_title()%>', //상품 이름
                                                        amount: '<%=rDTO.getGoods_price()%>', //판매 가격
                                                        buyer_email: 'iamport@siot.do',
                                                        buyer_name: '<%=SS_USER_NAME%>',
                                                        buyer_tel: '010-2100-1298',
                                                        buyer_addr: '<%=SS_USER_ADDR%>'
                                                        //buyer_postcode: '123-456'
                                                    }, function (rsp) {
                                                        if (rsp.success) {
                                                            var msg = '결제가 완료되었습니다.<br/>';
                                                            msg += '고유ID : ' + rsp.imp_uid + '<br/>';
                                                            //msg += '상점 거래ID : ' + rsp.merchant_uid;
                                                            msg += '결제 물품 : ' + '<%=rDTO.getGoods_title()%>' + '<br/>';
                                                            msg += '결제 금액 : ' + rsp.paid_amount + '원<br/>';
                                                            msg += '매장 방문 후 수령해 주세요!';
                                                        } else {
                                                            var msg = '결제에 실패하였습니다.<br/>';
                                                            msg += '에러내용 : ' + rsp.error_msg;
                                                        }
                                                        Swal.fire(msg);
                                                    });
                                                }
                                            })


                                        }
                                        </script>
                                    <div class="font" id="distance"></div>
                                    <br/>

                                    <!-- 작성자 본인일 때만 수정, 삭제 표시 -->
                                    <% if (SS_USER_NO.equals(rDTO.getUser_no())) { %>
                                    <div class="col-md-12 form-group">

                                        <a class="lost_pass font" href="javascript:doEdit()">판매글 수정</a>
                                        <br/>
                                        <a class="lost_pass font" href='javascript:doDelete()'>판매글 삭제하기</a>

                                    </div>
                                    <% } %>
                                <hr/>
                                </div>

                                <h3 class="widget_title mt-10 fontPoor">댓글</h3>
                                <!-- 댓글 작성란(임시) -->
                                <div class="row">
                                    <div class="col font">
                                        <% if (!SS_USER_NO.equals("-1")) { %>
                                        작성자 : <%=SS_USER_NAME%> <% } else { %>
                                        <a href="/logIn.do">로그인</a> 후 이용하세요!
                                        <% } %>
                                    </div>
                                </div>
                                <br/>
                                <div class="row">
                                    <div class="col-1"></div>
                                    <div class="col-7">
                                        <input class="form-control" type="textarea" name="comment" id="comment" onclick="validChk()" style="width: 300px; height:100px; margin: 0 auto;" placeholder="댓글을 입력하세요."/>
                                    </div>
                                    <div class="col-4">
                                        <br/>
                                        <button type="button" class="btn view-btn3 font ml-2" id="regComment" onclick="doSubmit()">댓글 등록</button>
                                        <!-- 댓글 수정을 눌렀을 때만 버튼이 표시되도록 설정 -->
                                        <button type="button" class="btn view-btn3 font" id="editComment" onclick="editComment()" style="display: none; margin: 0 auto;">댓글 수정</button>
                                    </div>
                                </div>
                                <hr/>

                                <div class="font" id="comment_list">해당 게시물에 대한 댓글이 없습니다.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <input type="hidden" id="user_no" value="<%=SS_USER_NO%>"/>
        <input type="hidden" id="gn" value="<%=rDTO.getGoods_no()%>"/>
        <!-- subscribe part end -->
    </main>

    <script type="text/javascript">

        function doCart(goods_no, user_no) {

                console.log("받아온 상품번호 : " + goods_no);
                console.log("게시글 올린 회원번호 : " + user_no);

                var ss_user_no = <%=SS_USER_NO%>;

                // 로그인하지 않은 상태로 장바구니 담기를 클릭했다면
                if (ss_user_no == "-1") {
                    Swal.fire({
                        title : 'Around-Sell',
                        text : '관심상품 담기는 로그인한 회원만 가능합니다. 로그인 후 이용하시겠습니까?',
                        icon : "warning",
                        showCancelButton : true,
                        confirmButtonText : "네! 로그인",
                        cancelButtonText : "아니오, 그냥 볼래요"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.href = "/logIn.do"
                        } else if (result.isCancled) {
                            return false;
                        }
                    })

                } else if (user_no == <%=SS_USER_NO%>) {
                    Swal.fire('본인이 등록한 상품은 관심상품 등록이 불가능합니다','','warning');
                } else {

                    console.log("장바구니 담기 진행!");
                    $.ajax({
                        url: "/cartChk.do",
                        type: "post",
                        data: {
                            "gn": goods_no,
                            "user_no": ss_user_no
                        },
                        dataType: "JSON",
                        success: function (res) {

                            console.log("중복이면 1, 아니면 0 : " + res);

                            if (res > 0) {
                                Swal.fire('이미 등록된 상품입니다.', '', 'warning');
                                return false;
                            } else if (res == 0)// 등록되지 않은 상품이라면,
                            { // insert 실행
                                $.ajax({
                                    url: "/insertCart.do",
                                    type: "post",
                                    data: {
                                        "gn": goods_no
                                        //$("#gn").val
                                    },
                                    dataType: "JSON",
                                    success: function (data) {
                                        // insertCart가 성공했을 경우, res에 1을 반환
                                        if (data == 1) {

                                            Swal.fire({
                                                title: 'Around-Sell',
                                                text: '관심상품 등록에 성공했습니다. 지금 확인하시겠습니까?',
                                                icon: "success",
                                                showCancelButton: true,
                                                confirmButtonText: "네! 확인할래요",
                                                cancelButtonText: "나중에 볼래요"
                                            }).then((result) => {
                                                if (result.isConfirmed) {
                                                    location.href = "/myCart.do"
                                                } else if (result.isCancled) {
                                                    return false;
                                                }
                                            })

                                        } else {
                                            Swal.fire("등록에 실패했습니다", '', 'error');
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
                }
        }

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

        function searchDistance() {

            var adr = "<%=SS_USER_ADDR%>";
            console.log("세션 주소 : " + adr);

        if (adr == "") {
            Swal.fire({
                title : 'Around-Sell',
                text : '로그인 후 거리를 확인할 수 있습니다. 로그인 하시겠습니까?',
                icon : "info",
                showCancelButton : true,
                confirmButtonText : "네! 로그인",
                cancelButtonText : "아니오, 그냥 볼래요"
            }).then((result) => {
                if (result.isConfirmed) {
                    location.href = "/logIn.do"
                }
            })
        } else {
        console.log("동작 확인(판매 위도) : " + lat1);
        console.log("동작 확인(유저 위도) : " + lat2);
        console.log("바뀜");

        var res = Math.ceil(calcDistance(lat1, lon1, lat2, lon2));

        console.log("우리집-판매 장소와의 거리 : " + res + "m");
        //$("#distance").text("우리집으로부터의 거리는 : " + res + "m 입니다.");

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
            var content = '<ul class="dotOverlay distanceInfo font">';
            content += '    <li>';
            content += '        <span class="label font">총거리 </span><span class="number">' + res + '</span>m<br/>';
            content += '    </li>';
            content += '    <li>';
            content += '        <span class="label font">도보 </span>' + walkHour + walkMin +'<br/>';
            content += '    </li>';
            content += '    <li>';
            content += '        <span class="label font">자전거 </span>' + bycicleHour + bycicleMin +'<br/>';
            content += '    </li>';
            content += '</ul>'

                return content;
        }

        var content = getTimeHTML(res);
        console.log("content : " + content);

        //$("#findpath").html(content);

        Swal.fire({
            title: '우리집과의 거리는?',
            icon: 'info',
            html: content,
            showCancelButton: true,
            showConfirmButton: true,
            confirmButtonText: '길찾기로 안내!',
            cancelButtonText: '잘 알았어요'
        }).then(value => {
            if (value.isConfirmed) {
                road();
            }
        })

        } }
    </script>
    <!-- 카카오지도 API js 파일-->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b5c003de0421fade00e68efc6fb912da&libraries=services,clusterer,drawing"></script>
    <script type="text/javascript" src="/resource/js/mapAPI.js?ver=2"></script>

    <!-- bootstrap, css 파일 -->

    <!-- 판매글 등록 시, 유효성 체크 js -->
    <script type="text/javascript" src="/resource/valid/noticeCheck.js"></script>

    <%@ include file="../include/footer.jsp"%>
    <!-- include JS File Start -->
    <%@ include file="../include/jsFile.jsp"%>
    <!-- include JS File End -->
</body>
</html>
