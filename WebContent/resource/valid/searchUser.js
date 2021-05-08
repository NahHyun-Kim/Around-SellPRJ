// 체크 버튼에 따라 이메일 찾기/비밀번호 찾기 기능이 달라진다.
function search_check(num) {
    if (num == '1') {
        // 이메일 찾기인 경우, 비밀번호 찾기 div를 감춤
        document.getElementById("searchP").style.display = "none";
        document.getElementById("searchE").style.display = "";
    } else if (num == '2') { // 비밀번호 찾기인 경우
        document.getElementById("searchE").style.display = "none";
        document.getElementById("searchP").style.display = "";
         }
}

var findEmail = document.getElementById("searchBtn");
var phoneNum = document.getElementById("inputPhone");

$(findEmail).click(function() {
    if (phoneNum.val() == "") {
        $(emchk).text('올바른 형식으로 이메일을 입력해 주세요.');
        $(emchk).css('color', 'red');
    } else {
        //ajax 호출
        $.ajax({
            //function을 실행할 url
            url: "/signup/emailCheck.do",
            type: "post",
            dataType: "json",
            data: {
                "user_email": $(umail).val()
            },
            success: function (data) {
                if (data == 1) { // 이미 존재하여 1을 반환하면
                    $(emchk).text('이미 가입된 이메일입니다.');
                    $(emchk).css('color', 'red');
                } else if (data == 0) { // 존재하지 않아 0을 반환하면
                    $(emchk).text('사용 가능한 이메일입니다.');
                    $(emchk).css('color', 'green');
                }
            }
        })
    }
})