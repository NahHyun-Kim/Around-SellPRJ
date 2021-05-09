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

    function emailSearch() {
    if ($("#inputPhone").val() == "") {
        $(".modal-body").text("핸드폰 번호를 입력해 주세요.");
        $(".modal-title").text("Around-Sell 이메일 찾기");
        $(".modal").fadeIn();
        return false;
    } /* else { // 값이 존재하는 경우
        $(".modal-body").text("회원님의 이메일은 : " );
        $(".modal-title").text("Around-Sell 이메일 찾기");
        $(".modal").fadeIn();
    } */
    }

// 비밀번호 변경 시(임시 비밀번호 -> 비밀번호 변경) 유효성 체크
var pw1 = document.getElementById("password1");
var pw2 = document.getElementById("password2");

var pwJ = /^[a-zA-Z0-9]{4,20}$/;

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