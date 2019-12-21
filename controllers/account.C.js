const express = require('express');
const router = express.Router();
const accountM = require('../models/account.M');
const hash = require("../utils/hash");
//const passport = require('passport');
const Recaptcha = require('recaptcha').Recaptcha;

var PUBLIC_KEY  = 'YOUR_PUBLIC_KEY',
    PRIVATE_KEY = 'YOUR_PRIVATE_KEY';


router.get('/login', async (req, res) => {
    var recaptcha = new Recaptcha(PUBLIC_KEY, PRIVATE_KEY);
    req.session.destroy();
    res.render('login', { 
        layout: 'login',
        recaptcha_form: recaptcha.toHTML(),     
     });
});

router.get('/register', async (req, res) => {
    req.session.destroy(); 
    res.render('register', { layout: 'login' });
});

router.post('/login', async (req, res) => {
    const username = req.body.username.toString();
    const password = req.body.password.toString();

    // không có username
    if (username === "") {
        res.render('login', {  
            layout: 'login',       
            error: '(*) Username is null',
        });
        return;
    }

    // không có password
    if (password === "") {
        res.render('login', {   
            layout: 'login',        
            error: '(*) Password is null',
        });
        return;
    }

    const user = await accountM.getByUserName(username);

    // không tồn tại user name
    if (user === null) {
        res.render('login', { 
            layout: 'login',           
            error: '(*) Username is not exist !',
        });
        return;
    }

    const CHash = await hash.comparePassword(password,user.f_Password);

    if (CHash) {
        req.session.User = {
            id: user.f_ID,
        };
        res.redirect('/home')
        return;
    }

    res.render('login', {     
        layout: 'login',   
        error: '(*) The wrong password !',
    });
    return;
});

router.post('/createAccount', async (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const email = req.body.email;
    const confirm_password = req.body.confirm_password;

    // password null
    if (password === "") {
        res.render('register', {    
            layout: 'login',        
            error: '(*) Your password is null !'
        })
        return;
    }

    // pass word - confirm password are different
    if (password !== confirm_password) {
        res.render('register', {  
            layout: 'login',          
            error: '(*) Password and Confirm-Password are different!'
        })
        return;
    }

    const user_DB = await accountM.getByUserName(username);
    const email_DB = await accountM.getByEmail(email);

    // username is already existed
    if (user_DB !== null) {
        res.render('register', {  
            layout: 'login',         
            error: '(*) Username is already existed!'
        });
        return;
    }
    // email is already used
    else if(email_DB !== null){
        res.render('register', {  
            layout: 'login',           
            error: '(*) Email is already used!'
        });
        return;
    }   
    else {

        var pwHash = await hash.getHashPassword(password);

        const user = {
            f_Username: username,
            f_Password: pwHash,
            f_Name: 'Name',
            f_Email: email,
            f_DOB: '2000-01-01',
            f_Permission: 0,
        };
        const uId = await accountM.add(user);

        req.session.User = {
            id: uId,
            user: user,
        };
        
        res.redirect('/account/profile');
        return;
    }

});

router.get('/profile', async (req, res) => {
    if(typeof req.session.User === "undefined"){
        res.redirect('/account/login');
        return;
    }

    const user = await accountM.getByID(req.session.User.id);

    res.render('profile', {
        layout: 'login',
        disabled: 'disabled',
        user: user,
    });
});


router.post('/profile', async (req, res) => {
    if(typeof req.session.User === "undefined"){
        res.render('profile',{
            layout: 'login',
            disabled: 'disabled',
            user: null,
        });
        return;
    }

    const id = req.session.User.id;
    let user = await accountM.getByID(id);

    const n_name = req.body.fullname;
    const n_password = req.body.password;
    const n_email = req.body.email;
    const n_dob = req.body.dob  || '2000-01-01';


    if(user.f_Name !== n_name){
        req.session.User.fullname = n_name;
        var changedRows = await accountM.update('f_Name',n_name,id);
    }

    if(user.f_Email !== n_email){
        req.session.User.email = n_email;
        var changedRows = await accountM.update('f_Email',n_email,id);
    }

    if(user.f_DOB !== n_dob){
        req.session.User.dob = n_dob;
        var changedRows = await accountM.update('f_DOB',n_dob,id);
    }

    if(user.f_Password !== n_password){
        const pwH = await hash.getHashPassword(n_password);
        req.session.User.password = pwH;
        var changedRows = await accountM.update('f_Password',pwH,id);
    }

    user = await accountM.getByID(id);

    res.render('profile', {
        layout: 'login',
        disabled: 'disabled',
        user: user,
    });
    return;
});


module.exports = router;