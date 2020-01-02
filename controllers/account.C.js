const express = require('express');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const auctionHistoryM = require('../models/auctionHistory.M');
const imageM = require('../models/image.M');
const hash = require("../utils/hash");
const passport = require('passport');
const utils = require('../utils/utilsFunction');
const createError = require('http-errors');
const watchlistM = require('../models/watchList.M');

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

router.post('/:id/watch_list', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        if (!req.user || req.user.ID !== id)
            return next(createError(403));
        let page = 1;
        const acc = await accountM.getByID(id);
        // get element  
        const proID = parseInt(req.body.proID);
        const element = {
            TIME: utils.getTimeNow(),
            USER_ID: req.user.ID,
            PRODUCT_ID: proID,
        };

        // check product is already exist ??
        const check_wl = await watchlistM.getByUserAndProductID(req.user.ID, proID);
        if (check_wl === null) {
            const uId = await watchlistM.add(element);
        }
        else {
            const affectRows = await watchlistM.delete(req.user.ID, proID);
        }
        // get - convert watch list to product
        const rs = await watchlistM.allByUserIDPaging(id, page);
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

        let totalWatchList = 0;
        if (typeof req.user !== "undefined") {
            totalWatchList = await watchlistM.countProductByUserID(req.user.ID);
        }

        res.render('account/watch_list', {
            layout: 'account',
            user: req.user,
            totalWatchList: totalWatchList,
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

router.get('/:id/watch_list', async (req, res, next) => {
    try {
        if (typeof req.user === "undefined" || req.params.id === "0") {
            res.redirect("account/login");
            return;
        }
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);
        const page = parseInt(req.query.page) || 1;

        // get - convert watch list to product
        const rs = await watchlistM.allByUserIDPaging(id, page);
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

        let totalWatchList = 0;
        if (typeof req.user !== "undefined") {
            totalWatchList = await watchlistM.countProductByUserID(req.user.ID);
        }

        res.render('account/watch_list', {
            layout: 'account',
            user: req.user,
            totalWatchList: totalWatchList,
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

router.get('/:id/password/edit', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);

        if (!req.user || req.user.ID !== id)
        return next(createError(403));

        res.render('account/password_edit', {
            layout: 'account',
            user: req.user,
            user_id: id,
            account: {
                ...acc,
                DOB_format: utils.formatDate2(acc.DOB),
            },
            title: 'Chỉnh sửa mật khẩu',
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});
router.post('/:id/password/edit', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        let acc = await accountM.getByID(id);

        if (!req.user || req.user.ID !== id)
        return next(createError(403));

        const npw = req.body.new_password.toString();
        const confirm_npw = req.body.confirm_new_password.toString();
        const opw = req.body.old_password.toString();

        if(npw !== confirm_npw){
            res.render('account/password_edit', {
                layout: 'account',
                user: req.user,
                user_id: id,
                error: "Mật khẩu không trùng khớp!",
                account: {
                    ...acc,
                },
                title: 'Chỉnh sửa mật khẩu',
            });
            return;
        }

        if(!(await hash.comparePassword(opw,acc.PASSWORD))){
            res.render('account/password_edit', {
                layout: 'account',
                user: req.user,
                user_id: id,
                error: "Mật khẩu cũ không đúng!",
                account: {
                    ...acc,
                },
                title: 'Chỉnh sửa mật khẩu',
            });
            return;
        }

        let rows = await accountM.update({
            PASSWORD: await hash.getHashPassword(npw),
        }, id);

        acc = await accountM.getByID(id);

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
            editProfile,
            msg: "Cập nhập mật khẩu thành công!",
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/:id/won_list', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        const acc = await accountM.getByID(id);
        const page = parseInt(req.query.page) || 1;

        const wls = await auctionHistoryM.getWonList(id);
        wl = wls.wonl; // list history chi co iduser va id product va time

        let wonList = []; // chi tiet dau gia 
        let stt = 0
        for (var i = 0; i < parseInt(wl.length); i++) {

            const producti = await productM.getByID(wl[i].PRODUCT_ID);
            const imgSrc = await imageM.getByID(producti[0].MAIN_IMAGE);
            const seller = await accountM.getByID(producti[0].SELLER_ID);

            if (Date.parse(producti[0].END_TIME) <= Date.now()) {
                stt++;
                wonList.push({
                    sttWL: stt,
                    proIDWL: wl[i].PRODUCT_ID,
                    priceWL: wl[i].PRICE,
                    sellerIDWL: seller.FULL_NAME,
                    mainImgWL : imgSrc[0],
                    proNameWL: producti[0].PRODUCT_NAME,
                    startTimeWL : await utils.parseTime(producti[0].START_TIME),
                    endTimeWL : await utils.parseTime(producti[0].END_TIME),
                    startPriceWL :producti[0].STARTING_PRICE      
                });
            }

        }

        // cái này dùng cho header thôi
        const cats = await categoryM.all();
 

        res.render('account/won_list', {
            layout: 'account',
            user: req.user,
            user_id: id,
            title: acc.FULL_NAME,
            cats: cats,
            wonList: wonList,
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

router.get('/:id/bidding_list', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);

        const bls = await auctionHistoryM.getAllByUserID(id); // bls là list product đã đấu giá

        let bidList = [];
        var stt = 0
        for (var i = 0; i < parseInt(bls.length); i++) {
            const proB = await productM.allByProIDBidding(bls[i].PRODUCT_ID)
            if (proB.length > 0) {
                const imgSrc = await imageM.getByID(proB[0].MAIN_IMAGE);
                const seller = await accountM.getByID(proB[0].SELLER_ID);
                stt ++;
                bidList.push({
                    sttBL: stt,
                    proIDBL: proB[0].ID,
                    mainImgBL: imgSrc[0],
                    proNameBL: proB[0].PRODUCT_NAME,
                    startPriceBL: proB[0].STARTING_PRICE,
                    nowPriceBL: proB[0].CURRENT_PRICE,
                    yourPriceBL: bls[i].PRICE,
                    sellerIDBL: seller.FULL_NAME,
                    endTimeBL : await utils.parseTime(proB[0].END_TIME),
                    isEqualYourPriceBL: proB[0].CURRENT_PRICE != bls[i].PRICE,
                })
            }
        }
        
        // cái này dùng cho header thôi
        const cats = await categoryM.all();

        res.render('account/bidding_list', {
            layout: 'account',
            user: req.user,
            user_id: id,
            bidList: bidList,
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