var email = document.getElementById("user_email");
var pw = document.getElementById("password");

var emchk = document.getElementById("email_check");
var pwchk = document.getElementById("pwd_check");

//이메일 형식 저장
var emailJ = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
//비밀번호 형식 저장
var pwJ = /^[a-zA-Z0-9]{4,20}$/;

//이메일이 형식과 일치하는지 확인
$(email).on("change keyup paste", function() {
        if (emailJ.test($(email).val()) == false) {
            $(emchk).text('올바른 형식으로 이메일을 입력해 주세요.');
            $(emchk).css('color', 'red');
        } else {
           $(emchk).hide();
        }
    })

//비밀번호가 비밀번호 형식에 일치하는지 확인
$(pw).on("change keyup paste", function() {
    if (pwJ.test($(pw).val()) == false) {
        $(pwchk).text('올바른 형식으로 비밀번호를 입력해 주세요.');
        $(pwchk).css('color','red');
    } else {
        $(pwchk).hide();
    }
})