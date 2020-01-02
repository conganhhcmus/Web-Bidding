function changeData() {
    $('#fullname').prop("disabled", false);
    $('#dob ').prop("disabled", false);
    $('#email').prop("disabled", false);
    $('#password').prop("disabled", false);
    $('#saveBtn').prop("disabled", false);
    $('#changeBtn').prop("disabled", true);
}




function submitUserForm() {
    let response = grecaptcha.getResponse();
    if (response.length == 0) {
        alert("Vui lòng xác nhận bằng captcha.")
        return false;
    }
    return true;
}

function verifyCaptcha() {
}


// // change wish icon when click on
// $('#likebutton').on('click', function () {
//     alert("click");
//     $("i", this).toggleClass("fa fa-heart fa fa-heart-o");
// });


$(document).ready(function () {
});

function checkGia() {
    if ($("#inputMoney").val().length == 0 || isNaN($("#inputMoney").val())) {
        alert("Giá nhập phải là số nguyên!");
        return false;
    }
    const gia_nguoi_dung = parseInt($("#inputMoney").val());
    const gia_he_thong = parseInt($("#giahethong").val());
    const gia_hien_tai = parseInt($("#current_price").val());
    const bidding = parseInt($("#bidding_increment").val());
    if (gia_nguoi_dung < gia_hien_tai) {
        alert("Giá nhập phải lớn hơn giá hiện tại!");
        return false;
    }

    let temp = gia_nguoi_dung - gia_hien_tai;
    let temp1 = temp % bidding;
    if (temp1 !== 0) {
        alert("Giá tiền nhập = Giá hiện tại + n * bước giá\n Vui lòng nhập lại!");
        return false;
    }
}
function checkAccount(){
     const flag = parseInt($("#checkAccount").text());
     if(flag === 0){
         alert("Hãy đăng nhập trước khi xem sản phẩm yêu thích cá nhân!");
         return false;
     }
     return true;
}