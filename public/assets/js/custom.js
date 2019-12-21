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
        document.getElementById('error').innerHTML = '(*) Captcha is required.';
        return false;
    }
    return true;
}

function verifyCaptcha() {
    document.getElementById('error').innerHTML = '';
}