const express = require('express');
const passport = require('passport');
const createError = require('http-errors');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const path = require("path");
const multiUpload = require('../middleware/upload');

router.get('/', (req, res, next) => {
    if (req.isAuthenticated() && req.user.PERMISSION == 1) {
        res.redirect('/admin/category');
    } else {
        res.redirect('/admin/category');

        //        next(createError(403));
    }
    next();
});


router.get('/create', async (req, res, next) => {
    try {
        // Lấy các danh mục
        let categories = await categoryM.all();
        // Render
        res.render('product/product_create', { layout: 'product', categories });
    }
    catch (err) {
        console.log(err);
        next(createError(500));
    }
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
        if (isNaN(parseInt(req.body.starting_price))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Giá khởi điểm phải là số nguyên.", layout: 'home' });
        }
        if (isNaN(parseInt(req.body.bidding_increment))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Bước giá phải là số nguyên.", layout: 'home' });
        }
        if (req.body.buynow_price.length > 0 && isNaN(parseInt(req.body.buynow_price))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Giá mua ngay phải là số nguyên.", layout: 'home' });
        }
        if (isNaN(Date.parse(req.body.start_time)) || isNaN(Date.parse(req.body.end_time))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Ngày giờ sai định dạng. Ví dụ: 12/31/2019 13:50.", layout: 'home' });
        }
        if ((Date.parse(req.body.start_time)) > (Date.parse(req.body.end_time))) {
            return res.render('errors/error', { title: "Dữ liệu không hợp lệ", msg: "Ngày bắt đầu không được sau ngày kết thúc.", layout: 'home' });
        }

        // Thêm sản phẩm
        let productId = await productM.createProduct(req.body.name,
            req.body.category,
            1,
            req.body.starting_price,
            req.body.bidding_increment,
            new Date(Date.parse(req.body.start_time)).toISOString().slice(0, 19).replace('T', ' '),
            new Date(Date.parse(req.body.end_time)).toISOString().slice(0, 19).replace('T', ' '),
            req.body.editor,
            req.body.extension == "true" ? true : false,
            req.body.buynow_price.length > 0 ? req.body.buynow_price : null
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
        return res.redirect('/home/' + productId + '/products')
    } catch (err) {
        console.log(err);
        next(createError(500));
    }
});


module.exports = router;