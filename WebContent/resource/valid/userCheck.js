var nameJ = /^[가-힣]{2,6}$/;
// 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
// 회원이름 유효성 체크 멘트
var nmchk = document.getElementById("name_check");
// signUp.jsp에서 회원 이름을 나타내는 id값
var uname = document.getElementById("user_name");

// 이름에 특수문자가 들어가지 않도록 설정
$(uname).on("propertychange change keyup paste input", function () {
        if (nameJ.test($(uname).val())) {
        console.log(nameJ.test($(uname).val()));
        $(nmchk).text('이름이 입력되었습니다 :)');
        $(nmchk).css('color', 'green');
    } else if ($(uname).val() == "") { //이름이 입력되지 않았다면
        $(nmchk).text('이름을 입력해 주세요.');
        $(nmchk).css('color', 'red');
    } else { //이름 형식이 유효하지 않다면
        $(nmchk).text('이름을 확인해 주세요.');
        $(nmchk).css('color', 'red');
    }
});

// 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
// 회원주소 유효성 체크 멘트
var adchk = document.getElementById("addr_check");
// signUp.jsp에서 회원 주소를 나타내는 id값
var uaddr = document.getElementById("sample5_address");
// 주소에 공백이 들어가지 않도록 설정(빈 값)
$(uaddr).blur(function () {
    if ($(uaddr).val() == "") {
        $(adchk).text('주소를 선택해 주세요.');
        $(adchk).css('color', 'red');
    } else {
        $(adchk).text('주소가 입력되었습니다 :)');
        $(adchk).css('color', 'green');
    }
});

//폰번호 01012345678 형식으로, 조건에 맞는 형태만 사용
var phoneJ = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
// 회원 핸드폰 번호 유효성 체크 멘트
var phchk = document.getElementById("phone_check");
// signUp.jsp에서 회원 핸드폰 번호를 나타내는 id값
var phnum = document.getElementById("phone_no");

$(phnum).on("propertychange change keyup paste input", function () {
    if (phoneJ.test($(phnum).val()) == false) {
        if ($(phnum).val() == "") {
            $(phchk).text('핸드폰 번호를 입력해 주세요.');
            $(phchk).css('color', 'red');
        } else { //빈 값도 false로 인식되어, if문 안에서 조건을 따로 줌.
            $(phchk).text('유효하지 않은 핸드폰 번호입니다.');
            $(phchk).css('color', 'red');
        }

    } else { // 유효성을 만족한다면
        // ajax 호출
        $.ajax({
            url: "/signup/phoneCheck.do",
            type: "post",
            dataType: "json",
            data: {
                "phone_no": $(phnum).val()
            },
            success: function (data) {
                if (data == 1) {
                    $(phchk).text('이미 가입된 핸드폰 번호입니다.');
                    $(phchk).css('color', 'red');
                } else {
                    $(phchk).text('사용 가능한 핸드폰 번호입니다 :)');
                    $(phchk).css('color', 'green');
                }
            }
        })
    }

});

//이메일 형식 저장
var emailJ = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;

// 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
var emchk = document.getElementById("email_check");
// signUp.jsp에서 회원 이메일을 나타내는 id값
var umail = document.getElementById("user_email");

$(umail).on("change keyup paste", function() {
    if (emailJ.test($(umail).val()) == false) {
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

// 비밀번호 형식 저장(영문 대, 소문자, 대소문자로 시작하는 8~20자리)
var pwJ = /^[a-zA-Z0-9]{4,20}$/;

// 유효성 체크를 보여주는 id값을 변수에 담음(getElementById('id값')
var pwchk1 = document.getElementById("pw_check1");
var pwchk2 = document.getElementById("pw_check2");

//signUp.jsp에서 비밀번호, 비밀번호 확인을 나타내는 id값
var pwd1 = document.getElementById("password_1");
var pwd2 = document.getElementById("password_2");

$(pwd1).on("change keyup paste", function() {
    if (pwJ.test($(pwd1).val()) == false) { //유효성에 맞지 않다면 또는 값이 입력되지 않았다면(또한 false)
        if ($(pwd1).val() == "") {
            $(pwchk1).text('비밀번호를 입력해 주세요.');
            $(pwchk1).css('color', 'red');
        } else { //빈 값도 false로 인식되어, if문 안에서 조건을 따로 줌.
            $(pwchk1).text('비밀번호는 영문, 숫자를 포함한 4~20자로 입력해 주세요.');
            $(pwchk1).css('color', 'red');
            console.log(pwJ.test($(pwd1).val()));
        }
    } else { //유효성에 충족되었다면
        $(pwchk1).text('비밀번호가 입력 되었습니다 :)');
        $(pwchk1).css('color', 'green');
    }
});

$(pwd2).on("change keyup paste", function() {
    if ($(pwd1).val() != $(pwd2).val()) {
        $(pwchk2).text('비밀번호가 일치하지 않습니다.');
        $(pwchk2).css('color', 'red');
    } else { //비밀번호 확인이 일치한다면
        $(pwchk2).text('비밀번호가 일치합니다:)');
        $(pwchk2).css('color', 'green');
        console.log($(pwd1).val() == $(pwd2).val())
    }
});

$("#close").click(function() {
    $(".modal").fadeOut();
});

function signupCheck() {

    // 실시간으로 유효성 체크를 하기 때문에, 유효성이 잘못되었거나 값이 입력되지 않으면 다시 확인해 달라는 모달창을 띄움
    if (emailJ.test($(umail).val()) == false || nameJ.test($(uname).val()) == false
    || ($(pwd1).val() != $(pwd2).val()) || pwJ.test($(pwd1).val()) == false || phoneJ.test($(phnum).val()) == false ||
    $(addr).val() == "") {

        Swal.fire('입력한 정보를 다시 한 번 확인해 주세요.','','warning');

        return false;

    }


    /*
    // 이메일 정규식에 맞지 않거나, 값이 입력되지 않은 경우
    if (emailJ.test($(umail).val()) == false) {
        if ($(umail).val() == "") {
            $(emchk).text('이메일은 필수 입력 사항입니다.');
            $(emchk).css('color','blue');
            $(umail).focus();
            return false;
        } else {
            console.log(emailJ.test($(umail).val()));
            $(emchk).text('올바른 형식으로 이메일을 입력해 주세요.');
            $(emchk).css('color', 'blue');
            $(umail).focus();
            return false;
        }
    }

    else if (nameJ.test($(uname).val()) == false) {
        if ($(uname).val() == "") {
            $(nmchk).text('이름은 필수 입력 사항입니다.');
            $(nmchk).css('color','blue');
            $(uname).focus();
            return false;
        } else {
            console.log(nameJ.test($(uname).val()));
            $(nmchk).text('올바른 형식으로 이름을 입력해 주세요.');
            $(nmchk).css('color', 'blue');
            $(uname).focus();
            return false;
        }
    }


    else if (($(pwd1).val() != $(pwd2).val())) {
        $(pwchk2).text('일치하는 비밀번호를 입력해 주세요.');
        $(pwchk2).css('color', 'blue');
        $(pwd2).focus();
        return false;
    }

    else if  (pwJ.test($(pwd1).val()) == false) {
        if ($(pwd1).val() == "") {
            $(pwchk1).text('비밀번호는 필수 입력 사항입니다.');
            $(pwchk1).css('color', 'blue');
            $(pwd1).focus();
            return false;
        } else {
            $(pwchk1).text('올바른 형식으로 비밀번호를 입력해 주세요.');
            $(pwchk1).css('color', 'blue');
            $(pwd1).focus();
            return false;
        }
    }

    else if ($(pwd2).val() == "") {
        $(pwchk2).text('비밀번호 확인은 필수 입력 사항입니다.');
        $(pwchk2).css('color', 'blue');
        $(pwd2).focus();
        return false;
    }

    else if (phoneJ.test($(phnum).val()) == false) {
        if ($(phnum).val() == "") {
            $(phchk).text('핸드폰 번호는 필수 입력 사항입니다.');
            $(phchk).css('color', 'blue');
            $(phnum).focus();
            return false;
        } else {
            console.log(phoneJ.test($(phnum).val()));
            $(phchk).text('올바른 형식의 핸드폰 번호를 입력해 주세요.');
            $(phchk).css('color', 'blue');
            $(phnum).focus();
            return false;
        }
    }


    else if ($(uaddr).val() == "") {
        $(adchk).text('주소는 필수 입력 사항입니다.');
        $(adchk).css('color', 'blue');
        $(uaddr).focus();
        return false;
    }
*/
    /* var valid_Arr = new Array(5).fill(false);
    // 가입하기를 실행할 때, 유효성 검사
    // 이메일 정규식
    if (emailJ.test($(umail).val())) {
        console.log(emailJ.test($(umail).val()));
        // 이메일 정규식이 맞을 경우
        valid_Arr[0] = true;
    }
    // 맞지 않을 경우
    else {
        valid_Arr[0] = false;
    }

    // 이름 정규식
    if (nameJ.test($(uname).val())) {
        console.log(nameJ.test($(uname).val()));
        // 이름 정규식이 맞을 경우
        valid_Arr[1] = true;
    }
    // 맞지 않을 경우
    else {
        valid_Arr[1] = false;
    }

    // 비밀번호 정규식
    if (($(pwd1).val() == $(pwd2).val())
        && pwJ.test($(pwd1).val())) {
        valid_Arr[2] = true;
    }
    // 맞지 않을 경우
    else {
        valid_Arr[2] = false;
    }

    // 핸드폰 정규식
    if (phoneJ.test($(phnum).val())) {
        console.log(phoneJ.test($(phnum).val()));
        valid_Arr[3] = true;
    }
    // 맞지 않을 경우
    else {
        valid_Arr[3] = false;
    }

    // 주소
    // 주소란이 입력되지 않았을 경우
    if ($(uaddr).val() == "") {
        console.log($(uaddr).val());
        valid_arr[4] = false;
    }
    // 주소란에 주소가 입력되었을 경우
    else {
        valie_arr[4] = true;
    }

    var validAll = true;
    for (var i=0; i<valid_Arr.length; i++) {

        if (valid_Arr[i] == false) {
            validAll = false;
        }
    }

    if (validAll) {
        console.log("유효성 모두 통과");
    } else {
        console.log("유효성 미 통과");
        alert("입력한 정보를 다시 한 번 확인해 주세요:)");
    }

    */

}

function doEditUser() {

    console.log("이메일 : " + $(umail).val());
    console.log("이름 : " + $(uname).val());

    if (emailJ.test($(umail).val()) == false || nameJ.test($(uname).val()) == false || phoneJ.test($(phnum).val()) == false ||
        ($(pwd1).val() != $(pwd2).val()) || pwJ.test($(pwd1).val()) == false || pwJ.test($(pwd2).val()) == false || ($("#sample5_address").val() == "")) {

        Swal.fire('입력한 정보를 다시 한 번 확인해 주세요.','','info');
        return false;
    }
}