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

var phoneNum = document.getElementById("inputPhone");

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
            dataType: "json",
            data: {
                "phone_no": $(phoneNum).val()
            },
            success: function (result) {

                console.log(result);

                var emailMsg = "";
                emailMsg += "회원님의 이메일은 : " + result + " 입니다.";
+
                console.log(emailMsg);
                $(".modal-body").text(emailMsg);
                $(".modal-title").text("Around-Sell 이메일 찾기");
                $(".modal").fadeIn();

            }
        })
    }
}