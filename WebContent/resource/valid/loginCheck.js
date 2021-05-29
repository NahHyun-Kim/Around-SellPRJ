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

$("#close").click(function() {
    $(".modal").fadeOut();
});

function loginChk() {
    // 실시간으로 유효성 체크를 하기 때문에, 유효성이 잘못되었거나 값이 입력되지 않으면 다시 확인해 달라는 모달창을 띄움
    // 유효성 테스트에서 공백 또는 맞지 않은 형태를 입력할 경우 모두 false가 나오기 때문에 .val() == "" 을 따로 넣지 않아도 포함된다.
    if (emailJ.test($(email).val()) == false || pwJ.test($(pwd1).val()) == false || phoneJ.test($(phnum).val()) == false) {
        $(".modal-body").text("입력한 정보를 다시 한 번 확인해 주세요.");
        $(".modal-title").text("Around-Sell 로그인");
        $(".modal").fadeIn();
        return false;
    }
}