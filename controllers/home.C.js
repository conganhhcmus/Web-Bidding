const express = require('express');
const router = express.Router();
const passport = require('passport');
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const sort = require('../utils/sort');
const top5 = require('../utils/top5')
const utils = require('../utils/utilsFunction');

router.get('/', async (req, res) => {
    let user = null;
    // Tat ca category
    const cats = await categoryM.all();

    var top5Price = await top5.top5Price();
    var top5End = await top5.top5End();

    const totalCat = cats.length;
    const ps = [];
    const img1 = [];
    // Lay anh chinh cua san pham
    for(var i = 0; i < totalCat; i++) {
        // San pham cua category i
        ps[i] = await productM.allByCatID(cats[i].ID);
        // Duyet tren cac san pham cua category i
        for(var j = 0; j < parseInt(ps[i].length); j++) {
            ps[i][j].imgSrc = ps[i][j].MAIN_IMAGE;
        }
    }

    if (typeof req.session.User !== "undefined") {
        let id = req.session.User.id;
        const user = await accountM.getByID(id);      
    }

    res.render('home/homepage', {
        layout: 'home',
        user: req.user,
        cats: cats,
        top5End: top5End,
        top5Price: top5Price,
    });
    return;
});


router.get('/product/:id/', async (req, res) => {
    const id = parseInt(req.params.id);
    const pro = await productM.getByID(id);
    const img = await imageM.allByProID(pro[0].ID);
    const ps = await productM.allByCatID(pro[0].CAT_ID);
    let user = null;

    // set date time
    var today = new Date();
    let temp = new Date(pro[0].START_TIME);
    var start_date = temp.getFullYear() + "/" + (temp.getMonth() + 1) + "/" + temp.getDate();
    pro[0].start_date = start_date.toString();

    var temp1 = new Date(pro[0].END_TIME);
    var a = parseInt(temp1.getTime()/1000 - today.getTime()/1000);
    pro[0].HOURS = parseInt(a/3600);
    pro[0].MINUTES = parseInt((a - pro[0].HOURS*3600)/60);
    pro[0].SECONDS = a - pro[0].HOURS*3600 - pro[0].MINUTES*60;
    pro[0].time_left = pro[0].HOURS + ':' + pro[0].MINUTES + ':' + pro[0].SECONDS;

    // set vnd money
    pro[0].CURRENT_PRICE_VND = await utils.getMoneyVNDString(pro[0].CURRENT_PRICE);
    pro[0].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(pro[0].BUYNOW_PRICE);


    if (typeof req.session.User !== "undefined") {
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }

    for (var i = 0; i < parseInt(ps.length); i++) {
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
        ps[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(ps[i].CURRENT_PRICE);
        ps[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(ps[i].BUYNOW_PRICE);
    }

    res.render('home/detail_product', {
        layout: 'home',
        user: user,
        pro: pro,
        img: img,
        ps: ps,
    });
});

// xem theo danh mục sản phẩm
router.get('/category/:id', async (req, res) => {
    // get user
    const id = parseInt(req.params.id);
    const page = parseInt(req.query.page) || 1;
    let user = null;

    if (typeof req.session.User !== "undefined") {
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }


    // get
    const rs = await productM.allByCatIDPaging(id, page);
    let ps = rs.products;
    const cats = await categoryM.all();
    const cat = await categoryM.getByID(id);
    // set product
     var today = new Date();
     for (var i = 0; i < parseInt(ps.length); i++) {
         ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
         var temp = new Date(ps[i].END_TIME);
         var a = parseInt(temp.getTime()/1000 - today.getTime()/1000);
         ps[i].HOURS = parseInt(a/3600);
         ps[i].MINUTES = parseInt((a - ps[i].HOURS*3600)/60);
         ps[i].SECONDS = a - ps[i].HOURS*3600 - ps[i].MINUTES*60;

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

    for (var i = 0; i < parseInt(ps.length); i++) {
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
    }


    res.render('home/category', {
        layout: 'home',
        user: user,
        cats: cats,
        cat: cat.CAT_NAME,
        ps: ps,
        pages: pages,
        navs: navs,
    });
});

// search sản phẩm
router.get('/product/search', async (req, res) => {
    // get style input
    if (req.query.name_search) {
        req.session.search_key = req.query.name_search.toString();
    }

    if (req.query.selected_option) {
        req.session.option = parseInt(req.query.selected_option);
    }

    // check user
    let user = null;
    if (typeof req.session.User !== "undefined") {
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }

    const option = parseInt(req.query.selected_option || req.session.option);
    const name = req.query.name_search || req.session.search_key;
    const page = parseInt(req.query.page) || 1;

    let rs;
    let cat;

    // get category
    if (option === 0) {
        rs = await productM.allBySearchNamePaging(name, page);
        cat = "All Category > " + name;
    }
    else {
        rs = await productM.allBySearchNamePagingCat(name, page, option);
        cat = (await categoryM.getByID(option))[0].CAT_NAME + " > " + name;
    }

    let pro = rs.products;
    const cats = await categoryM.all();

    // set product
    var today = new Date();
    for (var i = 0; i < parseInt(pro.length); i++) {
        pro[i].imgSrc = (await imageM.allByProID(pro[i].ID))[0];
        var temp = new Date(pro[i].END_TIME);
        var a = parseInt(temp.getTime()/1000 - today.getTime()/1000);
        pro[i].HOURS = parseInt(a/3600);
        pro[i].MINUTES = parseInt((a - pro[i].HOURS*3600)/60);
        pro[i].SECONDS = a - pro[i].HOURS*3600 - pro[i].MINUTES*60;

        // set vnd money
        pro[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(pro[i].CURRENT_PRICE);
        pro[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(pro[i].BUYNOW_PRICE);
    }

    // type sort
    let type_sort = parseInt(req.query.style_sort);
    if (type_sort == 1) {
        pro = await sort.sortByIncreasingPrice(pro);
    }
    else {
        pro = await sort.sortByDecreasingEndTime(pro);
    }

    //set page
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
    // end

    res.render('home/category', {
        layout: 'home',
        user: user,
        cats: cats,
        ps: pro,
        cat: cat,
        pages: pages,
        navs: navs,
    });
});


module.exports = router;