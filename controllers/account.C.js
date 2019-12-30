const express = require('express');
const router = express.Router();
const accountM = require('../models/account.M');
const hash = require("../utils/hash");
const passport = require('passport');

// Đăng nhập dùng passport
router.post('/login', function (req, res, next) {
    passport.authenticate('local', function (err, user, info) {
        if (err) { return next(err); }
        if (!user) {
            return res.render('login', {
                layout: 'login',
                error: 'Thông tin đăng nhập chưa chính xác',
                title: 'Đăng nhập'
            });
        }
        req.logIn(user, function (err) {
            if (err) { return next(err); }
            return res.redirect('/');
        });
    })(req, res, next);
}
);

router.get('/login', async (req, res) => {
    res.render('login', {
        layout: 'login',
        title: 'Đăng nhập',
    });
});

router.get('/register', async (req, res) => {
    res.render('register', {
        layout: 'login',
        title: 'Register',
    });
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
    else if (email_DB !== null) {
        res.render('register', {
            layout: 'login',
            error: '(*) Email is already used!'
        });
        return;
    }
    else {

        var pwHash = await hash.getHashPassword(password);

        const user = {
            USERNAME: username,
            PASSWORD: pwHash,
            FULL_NAME: 'Name',
            EMAIL: email,
            DOB: '2000-01-01',
            PERMISSION: 0,
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
    if (typeof req.session.User === "undefined") {
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
    if (typeof req.session.User === "undefined") {
        res.render('profile', {
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
    const n_dob = req.body.dob || '2000-01-01';


    if (user.FULL_NAME !== n_name) {
        var changedRows = await accountM.update('FULL_NAME', n_name, id);
    }

    if (user.EMAIL !== n_email) {
        var changedRows = await accountM.update('EMAIL', n_email, id);
    }

    if (user.DOB !== n_dob) {
        var changedRows = await accountM.update('DOB', n_dob, id);
    }

    if (user.PASSWORD !== n_password) {
        const pwH = await hash.getHashPassword(n_password);
        var changedRows = await accountM.update('PASSWORD', pwH, id);
    }

    user = await accountM.getByID(id);

    res.render('profile', {
        layout: 'login',
        disabled: 'disabled',
        user: user,
    });
    return;
});

router.get('/logout', function (req, res) {
    req.logout();
    res.redirect('/');
});

module.exports = router;