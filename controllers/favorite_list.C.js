const express = require('express');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/products.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const favoriteM = require('../models/watchList.M');
const utils = require('../utils/utilsFunction');


router.get('/:id', async (req, res) => {
    // check user
    if (typeof req.session.User === "undefined") {
        res.redirect('/account/login');
        return;
    }

    // get element
    if(typeof req.query.proID !== "undefined" && typeof req.query.userID !== "undefined"){
        const proID = parseInt(req.query.proID);
        const userID = parseInt(req.query.userID);
    
        const element = {
            TIME: '2000-01-01 00:00:00',
            USER_ID: userID,
            PRODUCT_ID: proID,
        };
     
        // check product is already exist ??
        const check_wl = await favoriteM.getByUserAndProductID(userID, proID);
        if (check_wl === null) {
            const uId = await favoriteM.add(element);
        }
        else{
            const affectRows = await favoriteM.delete(userID, proID);
        }
    }
   
    // get user
    const id = parseInt(req.params.id); // user id đó
    const page = parseInt(req.query.page) || 1;
    let user = null;

    if (typeof req.session.User !== "undefined") {
        let idd = req.session.User.id;
        user = await accountM.getByID(idd);
    }


    // get - convert watch list to product
    const rs = await favoriteM.allByUserIDPaging(id, page);
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


    res.render('home/favorite_list', {
        layout: 'home',
        user: user,
        cats: cats,
        cat: 'Your Favorite List Product',
        ps: ps,
        pages: pages,
        navs: navs,
    });
});

module.exports = router;