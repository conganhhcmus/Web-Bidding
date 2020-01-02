const express = require('express');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const hash = require("../utils/hash");
const passport = require('passport');
const watchListM = require('../models/watchList.M');
const utils = require('../utils/utilsFunction');
const createError = require('http-errors');

// Đăng nhập dùng passport
router.post('/login', function (req, res, next) {
    passport.authenticate('local', function (err, user, info) {
        if (err) { return next(err); }
        if (!user) {
            return res.render('login', {
                layout: 'login',
                error: 'Thông tin đăng nhập chưa chính xác.',
                title: 'Đăng nhập'
            });
        }
        req.logIn(user, function (err) {
            if (err) { return next(err); }
            return res.redirect('/');
        });
    })(req, res, next);
});

router.get('/login', async (req, res) => {
    res.render('login', {
        layout: 'login',
        title: 'Đăng nhập',
    });
});

router.get('/register', async (req, res) => {
    res.render('register', {
        layout: 'login',
        title: 'Đăng ký',
    });
});

router.post('/register', async (req, res) => {
    const username = req.body.username;
    const password = req.body.password;
    const email = req.body.email;
    const fullname = req.body.name;
    const confirm_password = req.body.confirm_password;
    const dob = req.body.dob;

    // password null
    if (password === "") {
        res.render('register', {
            layout: 'login',
            error: 'Mật khẩu không được bỏ trống.',
            title: 'Đăng ký'
        })
        return;
    }

    // pass word - confirm password are different
    if (password !== confirm_password) {
        res.render('register', {
            layout: 'login',
            error: 'Mật khẩu đã nhập không khớp.',
            title: 'Đăng ký'
        })
        return;
    }

    const user_DB = await accountM.getByUserName(username);
    const email_DB = await accountM.getByEmail(email);

    // username is already existed
    if (user_DB !== null) {
        res.render('register', {
            layout: 'login',
            error: 'Tên đăng nhập đã được sử dụng.',
            title: 'Đăng ký'
        });
        return;
    }
    // email is already used
    else if (email_DB !== null) {
        res.render('register', {
            layout: 'login',
            error: 'Email đã được dùng để đăng ký trước đó.',
            title: 'Đăng ký'
        });
        return;
    }
    else {

        var pwHash = await hash.getHashPassword(password);

        const user = {
            USERNAME: username,
            PASSWORD: pwHash,
            FULL_NAME: fullname,
            EMAIL: email,
            DOB: utils.parseTime(dob),
            PERMISSION: 0,
            TIME: utils.getTimeNow()
        };
    
        const uId = await accountM.add(user);
        console.log("id : ", uId);

        req.logIn({ ID: uId }, function (err) {
            if (err) { return next(err); }
            return res.redirect('/');
        });

        return;
    }

});

// Đăng xuất
router.get('/logout', function (req, res) {
    req.logout();
    res.redirect('/');
});


// Xem thông tin cá nhân
router.use('/:id', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        // ID sai
        if (isNaN(req.params.id) || isNaN(req.query.page || 1)) return next(createError(404));
        const acc = await accountM.getByID(id);
        // ID không tồn tại
        if (!acc) return next(createError(404));
        next();
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

router.get('/:id/profile/edit', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);

        if (!req.user || req.user.ID !== id)
        return next(createError(403));

        res.render('account/profile_edit', {
            layout: 'account',
            user: req.user,
            user_id: id,
            account: {
                ...acc,
                DOB_format: utils.formatDate2(acc.DOB),
            },
            title: 'Chỉnh sửa hồ sơ',
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

router.post('/:id/profile/edit', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        let acc = await accountM.getByID(id);

        if (!req.user || req.user.ID !== id)
        return next(createError(403));

        let rows = await accountM.update({
            FULL_NAME: req.body.name,
            EMAIL: req.body.email,
            DOB: utils.parseTime(req.body.dob),
        }, id);

        acc = await accountM.getByID(id);

        res.render('account/profile_edit', {
            layout: 'account',
            user: acc,
            user_id: id,
            account: {
                ...acc,
                DOB_format: utils.formatDate2(acc.DOB),
            },
            title: 'Chỉnh sửa hồ sơ',
            msg: rows ? 'Cập nhật thành công!' : null
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

router.get('/:id/profile', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);

        let editProfile = false;
        if (req.user && req.user.ID === id)
        editProfile = true;

        res.render('account/profile', {
            layout: 'account',
            user: req.user,
            user_id: id,
            account: {
                ...acc,
                DOB_format: utils.formatDate(acc.DOB),
                TIME_format: utils.formatDate(acc.TIME),
            },
            title: 'Hồ sơ của ' + acc.FULL_NAME,
            editProfile
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/:id/rating', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);

        res.render('account/account_rating', {
            layout: 'account',
            user: req.user,
            user_id: id,
            title: 'Thông tin đánh giá của ' + acc.FULL_NAME,
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/:id/watch_list', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);
        const page = parseInt(req.query.page) || 1;

        // get - convert watch list to product
        const rs = await watchListM.allByUserIDPaging(id, page);
        pss = rs.products; // cái này mới là danh sách favorite list
        let ps = []; // lấy chi tiết sản phẩm
        for (var i = 0; i < parseInt(pss.length); i++) {
            ps[i] = (await productM.getByID(pss[i].PRODUCT_ID))[0];
        }

        // cái này dùng cho header thôi
        const cats = await categoryM.all();

        // set product
        var today = new Date();
        for (var i = 0; i < parseInt(ps.length); i++) {
            ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
            var temp = new Date(ps[i].END_TIME);
            var a = parseInt(temp.getTime() / 1000 - today.getTime() / 1000);
            ps[i].HOURS = parseInt(a / 3600);
            ps[i].MINUTES = parseInt((a - ps[i].HOURS * 3600) / 60);
            ps[i].SECONDS = a - ps[i].HOURS * 3600 - ps[i].MINUTES * 60;

            // set vnd money
            ps[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(ps[i].CURRENT_PRICE);
            ps[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(ps[i].BUYNOW_PRICE);
        }

        // set page
        const pages = [];
        for (var i = 0; i < rs.pageTotal; i++) {
            pages[i] = { value: i + 1, active: (i + 1) === page };
        }
        const navs = {};
        if (page > 1) {
            navs.prev = page - 1;
        }
        if (page < rs.pageTotal) {
            navs.next = page + 1;
        }

        // set main image
        for (var i = 0; i < parseInt(ps.length); i++) {
            ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
        }


        res.render('account/watch_list', {
            layout: 'account',
            user: req.user,
            user_id: id,
            title: 'Sản phẩm yêu thích của ' + acc.FULL_NAME,
            cats: cats,
            ps: ps,
            pages: pages,
            navs: navs,
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/:id', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);

        res.redirect('/account/' + id + '/rating');
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

module.exports = router;