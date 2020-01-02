const express = require('express');
const passport = require('passport');
const createError = require('http-errors');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const auctionHistoryM = require('../models/auctionHistory.M');
const imageM = require('../models/image.M');
const path = require("path");
const multiUpload = require('../middleware/upload');
const utils = require('../utils/utilsFunction');
const sort = require('../utils/sort');


// Tạo sản phẩm mới - GET
router.get('/create', (req, res, next) => {
    if (!req.isAuthenticated() || req.user.PERMISSION == -1) {
        return next(createError(403));
    }
    next();
},
    async (req, res, next) => {
        try {
            // Lấy các danh mục
            let categories = await categoryM.all();
            // get all parent
            const parentCat = await categoryM.allParentCats();
            for (var i = 0; i < parseInt(parentCat.length); i++) {
                parentCat[i].children = await categoryM.getChildren(parentCat[i].ID);
            }

            // Render
            res.render('product/product_create', {
                layout: 'product',
                categories,
                user: req.user,
                cats: categories,
                title: 'Thêm sản phẩm',
                parentCat,
            });
        }
        catch (err) {
            console.log(err);
            next(createError(500));
        }
    });

// TODO: 
// Tạo sản phẩm mới - POST
router.post('/create', (req, res, next) => {
    if (!req.isAuthenticated() || req.user.PERMISSION == -1) {
        return next(createError(403));
    }
    next();
});

router.post('/create', multiUpload, async function (req, res, next) {
    try {
        // Validation
        if (req.files.length <= 0) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Bạn chưa chọn đủ số ảnh minh họa.", layout: 'home' });
        }
        if (req.body.name.length == 0) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Tên sản phẩm không được bỏ trống.", layout: 'home' });
        }
        if (req.body.starting_price.length === 0 || isNaN(req.body.starting_price)) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Giá khởi điểm phải là số nguyên.", layout: 'home' });
        }
        if (req.body.bidding_increment.length === 0 || isNaN(req.body.bidding_increment)) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Bước giá phải là số nguyên.", layout: 'home' });
        }
        if (req.body.buynow_price.length > 0 && isNaN(req.body.buynow_price)) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Giá mua ngay phải là số nguyên.", layout: 'home' });
        }
        if (isNaN(Date.parse(req.body.start_time)) || isNaN(Date.parse(req.body.end_time))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Ngày giờ sai định dạng. Ngày giờ phải ở dạng: 12/31/2019 13:50.", layout: 'home' });
        }
        if ((Date.parse(req.body.start_time)) > (Date.parse(req.body.end_time))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Thời gian kết thúc phải đi sau thời gian bắt đầu.", layout: 'home' });
        }

        // Thêm sản phẩm
        let productId = await productM.createProduct(req.body.name,
            req.body.category,
            req.user.ID,
            req.body.starting_price,
            req.body.bidding_increment,
            utils.parseTime(req.body.start_time),
            utils.parseTime(req.body.end_time),
            req.body.editor,
            req.body.extension == "true" ? true : false,
            req.body.buynow_price.length > 0 ? req.body.buynow_price : null,
            utils.getTimeNow()
        );
        // Thêm hình ảnh
        let imgId = null;
        for (let img of req.files) {
            let id = await imageM.createImg(img.originalname, img.filename, productId);
            if (!imgId) imgId = id;
        }

        // Cập nhật ảnh chính
        await productM.updateProductImg(productId, imgId);
        // Chuyển về sản phẩm
        return res.redirect('/product/' + productId)
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

// TODO:
// Tìm sản phẩm
router.get('/search', async (req, res, next) => {
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
        cat = (await categoryM.getByID(option)).CAT_NAME + " > " + name;
    }

    let pro = rs.products;
    const cats = await categoryM.all();

    // set product
    var today = new Date();
    for (var i = 0; i < parseInt(pro.length); i++) {
        pro[i].imgSrc = (await imageM.allByProID(pro[i].ID))[0];
        var temp = new Date(pro[i].END_TIME);
        var a = parseInt(temp.getTime() / 1000 - today.getTime() / 1000);
        pro[i].HOURS = parseInt(a / 3600);
        pro[i].MINUTES = parseInt((a - pro[i].HOURS * 3600) / 60);
        pro[i].SECONDS = a - pro[i].HOURS * 3600 - pro[i].MINUTES * 60;

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

// TODO:
// Xem chi tiết sản phẩm
router.get('/:id', async (req, res, next) => {
    try {
        const id = parseInt(req.params.id);
        // ID sai
        if (isNaN(req.params.id)) return next(createError(404));
        const pro = await productM.getByID(id);
        // ID không tồn tại
        if (pro.length == 0) return next(createError(404));
        // get all parent
        const parentCat = await categoryM.allParentCats();
        for (var i = 0; i < parseInt(parentCat.length); i++) {
            parentCat[i].children = await categoryM.getChildren(parentCat[i].ID);
        }
        
        const img = await imageM.allByProID(pro[0].ID);
        const ps = await productM.allByCatID(pro[0].CAT_ID);
        if(ps.length > 4) ps.splice(4);

        await ps.forEach(async p => {
            p.imgSrc = (await imageM.allByProID(p.ID))[0];
            p.CURRENT_PRICE_VND = await utils.getMoneyVNDString(p.CURRENT_PRICE);
            var temp1 = new Date(p.END_TIME);
            var temp2 = utils.getRemainTime(temp1);
            p.remain = temp2[0];
            var temp1 = new Date(p.START_TIME);
            var temp2 = utils.getRemainTime(temp1);
            p.isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 1;
        });

        // set date time
        var temp1 = new Date(pro[0].END_TIME);
        var temp2 = utils.getRemainTime(temp1);
        pro[0].remain = temp2[0];
        var temp1 = new Date(pro[0].START_TIME);
        var temp2 = utils.getRemainTime(temp1);
        pro[0].isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 1;
        pro[0].start_format = utils.formatDateTime(new Date(pro[0].START_TIME));
        pro[0].end_format = utils.formatDateTime(new Date(pro[0].END_TIME));
        pro[0].post_format = utils.formatDateTime(new Date(pro[0].TIME));
        
        // set vnd money
        pro[0].CURRENT_PRICE_VND = await utils.getMoneyVNDString(pro[0].CURRENT_PRICE);
        pro[0].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(pro[0].BUYNOW_PRICE);
        pro[0].START_PRICE_VND = await utils.getMoneyVNDString(pro[0].STARTING_PRICE);
        pro[0].BIDDING_PRICE_VND = await utils.getMoneyVNDString(pro[0].BIDDING_INCREMENT);

        for (var i = 0; i < parseInt(ps.length); i++) {
            ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
            ps[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(ps[i].CURRENT_PRICE);
            ps[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(ps[i].BUYNOW_PRICE);
        }

        const SELLER_ID = pro[0].SELLER_ID;
        const seller = await accountM.getByID(SELLER_ID);

        //history

        const us = await auctionHistoryM.allByProductIDPaging(id);
        pss = us.historys; // list history chi co iduser va id product va time
        let ph = []; // chi tiet dau gia 
        for (var i = 0; i < parseInt(pss.length); i++) {
            let timeTmp = new Date(pss[i].TIME);
            ph.push({
                    time: `${timeTmp.getDate()}/${timeTmp.getMonth()+1}/${timeTmp.getFullYear()} ${timeTmp.getHours()}:${timeTmp.getMinutes()}`,
                    bidderName: "****" + ((await accountM.getByID(pss[i].USER_ID)).FULL_NAME.split(" ")).pop(), 
                    price: await utils.getMoneyVNDString(pss[i].PRICE)
            });
        }


        // tim gia he thong
        const GiaHeThong = pro[0].CURRENT_PRICE + pro[0].BIDDING_INCREMENT;

        //

        res.render('product/product_detail', {
            layout: 'product',
            user: req.user,
            seller: seller,
            pro: pro[0],
            img: img,
            ps: ps,
            GiaHeThong: GiaHeThong,
            disabled: "disabled",
            parentCat,
            ph: ph,
        });
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});

module.exports = router;