const express = require('express');
const createError = require('http-errors');
const router = express.Router();
const passport = require('passport');
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const utils = require('../utils/utilsFunction');

// Xem sản phẩm trong danh mục
router.get('/:id', async (req, res, next) => {
    try {
        // ID sai hoặc page sai
        if (isNaN(req.params.id) || isNaN(req.query.page || 1)) return next(createError(404));

        // ID và page
        const id = parseInt(req.params.id);
        const page = parseInt(req.query.page) || 1;
        const cat = await categoryM.getByID(id); // Lấy danh mục hiện tại
        if (typeof cat === "undefined")
            return next(createError(404));

        // Lấy sản phẩm về
        const rs = await productM.allByCatIDPaging(id, page);
        let ps = rs.products; // Danh sách sản phẩm
        const cats = await categoryM.all(); // Danh sách danh mục
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

        for (var i = 0; i < parseInt(ps.length); i++) {
            ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
        }

        const parentCat = await categoryM.allParentCats();
        for(var i = 0; i < parseInt(parentCat.length); i++){
            parentCat[i].children = await categoryM.getChildren(parentCat[i].ID);
        }

        res.render('home/category', {
            layout: 'home',
            user: req.user,
            cats: cats,
            cat: cat.CAT_NAME,
            ps: ps,
            pages: pages,
            navs: navs,
            title: cat.CAT_NAME,
            parentCat: parentCat,
        });
    }
    catch (err) {
        console.log(err);
        next(createError(500));
    }
});



module.exports = router;