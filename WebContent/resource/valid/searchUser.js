// 체크 버튼에 따라 이메일 찾기/비밀번호 찾기 기능이 달라진다.

// 비밀번호 변경 시(임시 비밀번호 -> 비밀번호 변경) 유효성 체크
var pw1 = document.getElementById("password1");
var pw2 = document.getElementById("password2");

// 비밀번호 변경 시, 유효성 체크를 실시간으로 하도록 표시
var pw1chk = document.getElementById("pwd1_check");
var pw2chk = document.getElementById("pwd2_check");

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

    // 이메일 찾기 시 유효성 검증 함수
    function emailSearch() {
    if ($("#inputPhone").val() == "") {
        Swal.fire('핸드폰 번호를 입력해 주세요!','','info');
        return false;
    }
    }

    // 이메일 유효성 검증 추가(null이 아니고, 이메일 존재하는 경우에만 비밀번호 찾기 진행)
    function pwSearch() {
        console.log("사용자 입력 이메일 : " + $("#inputEmail").val());

        if ($("#inputEmail").val() == "") {
            Swal.fire('이메일을 입력해 주세요!','','info');
            return false;
            // null이 아니라면, 등록된 이메일인 경우에만 비밀번호 찾기 진행
        }
    }


var pwJ = /^[a-zA-Z0-9]{4,20}$/;
// 기존 유효성 + 비밀번호와 같을 경우 경고문구를 계속 띄우기 위한 flag 변수
var flag = true;

$(pw1).on("change keyup paste", function() {
    if (pwJ.test($(pw1).val()) == false) { //유효성에 맞지 않다면 또는 값이 입력되지 않았다면(또한 false)
        if ($(pw1).val() == "") {
            $(pw1chk).text('비밀번호를 입력해 주세요.');
            $(pw1chk).css('color', 'red');

            return false;
        } else { //빈 값도 false로 인식되어, if문 안에서 조건을 따로 줌.
            $(pw1chk).text('비밀번호는 영문, 숫자를 포함한 4~20자로 입력해 주세요.');
            $(pw1chk).css('color', 'red');
            console.log(pwJ.test($(pw1).val()));
            flag = false;

            $(pw2chk).hide();
            return false;
        }

    } else { //유효성에 충족되었다면, 기존 비밀번호와 같은 비밀번호가 입력되었는지 확인 후 유효 여부 표시
        $.ajax({
                url: "/myPwdChk.do",
                type: "post",
                dataType: "JSON",
                data: {
                    "password": $(pw1).val()
                },

                success: function (data) {
                    console.log("받아온 res : " + data);
                    // 기존에 등록된 비밀번호라서 not null값을 반환하면
                    if (data == 1) {
                        $(pw1chk).text('기존 비밀번호와 일치합니다. 변경해 주세요.');
                        $(pw1chk).css('color', 'red');
                        flag = false;
                    } else if (data == 0) {
                        $(pw1chk).text('비밀번호가 입력 되었습니다 :)');
                        $(pw1chk).css('color', 'green');
                        // 유효성 통과 + 기존 비밀번호가 다를 때만 flag 를 true로 준다.
                        flag = true;


                    }
                },
            error:function(request, status, error){

                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

            }

        })

    }

    $(pw2chk).hide();
});

$(pw2).on("change keyup paste", function() {
    console.log("flag : " + flag);
    $(pw2chk).show();

    if (($(pw1).val() != $(pw2).val()) && flag != false) {
        $(pw2chk).text('비밀번호가 일치하지 않습니다.');
        $(pw2chk).css('color', 'red');
        return false;
    } else if (($(pw1).val() == $(pw2).val()) && flag != false && $(pw1).val() != '') { //비밀번호 확인이 일치한다면
        $(pw2chk).text('비밀번호가 일치합니다:)');
        $(pw2chk).css('color', 'green');
        console.log($(pw1).val() == $(pw2).val());
    } else if(flag == false) {
        $(pw2chk).text('비밀번호를 다시 설정해 주세요.');
        $(pw2chk).css('color', 'red');
    }
});

function pwChk() {
    console.log("flag : " + flag);

    if (($(pw1).val() != $(pw2).val()) || pwJ.test($(pw1).val()) == false || pwJ.test($(pw2).val()) == false || flag == false) {
        Swal.fire('Around-Sell','입력한 정보를 다시 한 번 확인해 주세요!','warning');
        return false;
    } else {
        alert("비번 성공! 유효성 안 걸림");
    }
    }