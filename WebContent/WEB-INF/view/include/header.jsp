<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                                <% if (SS_USER_NAME == null) { %>
                                <li><a href="#">LogIn / SignUp</a>
                                    <ul class="submenu">
                                        <li><a href="/logIn.do">로그인</a></li>
                                        <li><a href="/signup.do">회원가입</a></li>
                                        <li><a href="/userSearch.do">FIND ID/PW</a></li>
                                    </ul>
                                </li>
                                <% } else if (SS_USER_NAME != null && !SS_USER_NO.equals("0")){ %>
                                <li><a href="/myList.do">MyPage</a>
                                    <ul class="submenu">
                                        <li><a href="/logOut.do">로그아웃</a></li>
                                        <li><a href="/updateUserForm.do">개인정보 수정</a></li>
                                        <li><a href="/myList.do">마이페이지</a></li>
                                        <li><a href="/noticeForm.do">판매글 등록하기</a></li>
                                    </ul>
                                </li>
                                <% } else if (SS_USER_NAME != null && SS_USER_NO.equals("0")) {%>
                                <li><a href="/getUser.do">관리자 페이지</a>
                                    <ul class="submenu">
                                        <li><a href="/logOut.do">로그아웃</a></li>
                                        <li><a href="/updateUserForm.do">관리자 정보수정</a></li>
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
                                <% if (SS_USER_NAME != null) { %>
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
</style>