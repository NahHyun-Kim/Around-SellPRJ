//이메일 형식 저장
var emailJ = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
//비밀번호 형식 저장 8글자 이상 16자 이하 영어,숫자, 특수문자 1글자이상 포함해야됨
var passwordJ = /(?=.*\d{1,18})(?=.*[~`!@#$%\^&*()-+=]{1,18})(?=.*[a-zA-Z]{1,18}).{12,20}$/;
var nameJ = /^[가-힣]{2,6}$/;
function emailCheck() {
    if (emailJ.test($("#user_email").val()) == false) {
        alert("올바른 이메일 형식으로 입력해 주세요.");
        return false;
    } else {
        //ajax 호출
        $.ajax({
            //function을 실행할 url
            url : "/signup/emailCheck.do",
            type : "post",
            dataType : "json",
            data : {
                "user_email" : $("#user_email").val()
            },
            success : function(data) {
                if (data == 1) { // 이미 존재하여 1을 반환하면
                    alert("이미 가입된 이메일입니다.");
                    return false;
                } else if (data == 0) { // 존재하지 않아 0을 반환하면
                    alert("사용 가능한 이메일입니다.");
                }
            }
        })
    }
}

// 이름에 특수문자가 들어가지 않도록 설정
$("#user_name").blur(function() {
    if (nameJ.test($("#user_name").val())) {
        console.log(nameJ.test($("#user_name").val()));
        $("#name_check").text('');
    } else {
        $('#name_check').text('이름을 확인해주세요');
        $('#name_check').css('color', 'red');
    }
});


// if ($("#user_name").val() == "") {
// 				alert("성명를 입력해주세요.");
// 				$("#user_name").focus();
// 				return false;
