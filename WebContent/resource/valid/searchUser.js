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
                    } else if (data == 0) {
                        $(pw1chk).text('비밀번호가 입력 되었습니다 :)');
                        $(pw1chk).css('color', 'green');
                    }
                },
            error:function(request, status, error){

                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);

            }

        })

    }
});

$(pw2).on("change keyup paste", function() {
    if ($(pw1).val() != $(pw2).val()) {
        $(pw2chk).text('비밀번호가 일치하지 않습니다.');
        $(pw2chk).css('color', 'red');
        return false;
    } else { //비밀번호 확인이 일치한다면
        $(pw2chk).text('비밀번호가 일치합니다:)');
        $(pw2chk).css('color', 'green');
        console.log($(pw1).val() == $(pw2).val());
    }
});

/*
function emailSearch() {
    if ($(phoneNum).val() == "") {
        $(".modal-body").text("핸드폰 번호를 입력해 주세요.");
        $(".modal-title").text("Around-Sell 이메일 찾기");
        $(".modal").fadeIn();
    } else {
        //ajax 호출
        $.ajax({
            //function을 실행할 url
            url: "/findEmailUser.do",
            type: "post",
            data : {
                inputPhone : $(phoneNum).val()
            },
            dataType: "text",
            success: function (data) {

                console.log(data);

                if (data == 0) {
                    $(".modal-body").text("회원 정보를 확인해 주세요");
                } else {


                var emailMsg = "";
                emailMsg += "회원님의 이메일은 : " + result + " 입니다.";
+
                console.log(emailMsg);
                $(".modal-body").text(emailMsg);
                $(".modal-title").text("Around-Sell 이메일 찾기");
                $(".modal").fadeIn();
                }
            }
        })
    }
} */