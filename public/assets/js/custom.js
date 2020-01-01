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


// change wish icon when click on
$('#likebutton').on('click', function() {
    alert("click");
    $("i", this).toggleClass("fa fa-heart fa fa-heart-o");
 });


 $(document).ready(function () {
    $('input[type=radio][name=typeDG]').change(function () {
        if ($("input[name='typeDG']:checked").val() === '1') {
            $("#inputMoney").val($("#giahethong").val());
            $("#inputMoney").prop('disabled', true);
        }
        if ($("input[name='typeDG']:checked").val() === '2') {
            $("#inputMoney").prop('disabled', false);
            $("#inputMoney").val("");
        }
    });
});

function checkGia(){
    const gia_nguoi_dung =  parseInt($("#inputMoney").val());
    const gia_he_thong = parseInt($("#giahethong").val());
    const gia_hien_tai = parseInt($("#current_price").val());
    const bidding = parseInt($("#bidding_increment").val());

    if(gia_nguoi_dung < gia_hien_tai){
        alert("Giá nhập phải lớn hơn giá hiện tại!");
        return false;
    }

    let temp = gia_nguoi_dung - gia_hien_tai;
    let temp1 = temp%bidding;
    if(temp1 !== 0){
        alert("Giá tiền nhập = Giá hiện tại + n * bước giá\n Vui lòng nhập lại!");
        return false;
    }
    else{
        alert("dung roi");
    }
}

 