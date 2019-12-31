const express = require('express');
const passport = require('passport');
const createError = require('http-errors');
const db = require('../utils/db');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
const MAX_ITEMS = 20;

router.use((req, res, next) => {
    if (!req.isAuthenticated() || req.user.PERMISSION < 2) {
        return next(createError(403));
    }
    next();
});

router.get('/', (req, res) => {
    res.redirect('/admin/category');
});
router.get('/category', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let categories = await categoryM.all((page - 1) * MAX_ITEMS, MAX_ITEMS);
        // Lấy tên thư mục cha
        for (let category of categories) {
            category.parent_name = await categoryM.getNameByID(category.PARENT_ID);
        }
        // Render
        res.render('admin/category', {
            layout: 'admin',
            categories: categories,
            title: 'Quản lý danh mục',
            user: req.user
        });
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});

router.all('/category/:id/edit', async (req, res, next) => {
    try {
        let id = parseInt(req.params.id);
        let pid = parseInt(req.body.cat_id);
        let name = req.body.cat_name;
        // ID không tồn tại hoặc sai =>  404
        if (isNaN(req.params.id)) return next(createError(404));

        if (typeof (await categoryM.getByID(id)) === "undefined")
            return next(createError(404));

        // Biến hiển thị thông báo
        let isSuccessful = 0;
        // Nếu là POST thì update data
        if (req.method == "POST") {
            // Update
            if (pid < 0) {
                isSuccessful = await categoryM.updateNullCategory(id, name);
            }
            else {
                isSuccessful = await categoryM.updateCategory(id, pid, name);
            }
        }

        let category = await categoryM.getByID(id);
        // Lấy tên các danh mục mục cha khác
        let pCategories = await categoryM.allParentCats();
        // Select tên danh mục hiện tại
        pCategories.forEach(pCat => {
            if (pCat.ID == category.PARENT_ID) {
                pCat.selected = true;
            }
            else {
                pCat.selected = false;
            }
        });
        // Nếu danh mục hiện tại là danh mục cha thì các danh mục cha khác không bao gồm nó
        let i = 0;
        for (let cat of pCategories) {
            if (!cat.PARENT_ID && cat.ID == id) {
                pCategories.splice(i, 1);
                break;
            }
            i++;
        }
        // Render
        res.render('admin/category_edit', {
            layout: 'admin',
            category,
            pCategories,
            isSuccessful: isSuccessful > 0,
            title: 'Chỉnh sửa danh mục',
            user: req.user
        });
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/category/create', async (req, res, next) => {
    try {
        // Lấy tên các danh mục mục cha khác
        let pCategories = await categoryM.allParentCats();
        // Render
        res.render('admin/category_create', {
            layout: 'admin',
            pCategories,
            title: 'Tạo danh mục',
            user: req.user
        });
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});

router.post('/category/create', async (req, res, next) => {
    try {

        let pid = parseInt(req.body.cat_id);
        let name = req.body.cat_name;
        // Kiểm tra đang tạo thư mục cấp cha hay con
        if (pid > 0) await categoryM.createCategory(pid, name);
        else await categoryM.createParentCategory(name);

        // Render
        res.redirect('/admin/category');
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});

router.get('/category/:id/delete', async (req, res, next) => {
    try {
        if (isNaN(req.params.id)) return next(createError(404));

        let id = parseInt(req.params.id);
        let category = await categoryM.getByID(id);
        let childCats = await categoryM.getChildren(id);
        // ID không tồn tại hoặc sai =>  404
        if (typeof category === "undefined")
            return next(createError(404));
        // Kiểm tra tồn tại thư mục con

        if (!category.PARENT_ID && childCats.length > 0) {
            return res.render('admin/category_delete', {
                layout: 'admin',
                title: 'Xóa danh mục thất bại',
                user: req.user,
                msg: 'Không thể xóa danh mục đang là cha của một số danh mục khác.'
            })
        }
        let products = await productM.allByCatID(id);
        // Kiểm tra tồn tại sản phẩm trong thư mục
        if (products.length > 0) {
            return res.render('admin/category_delete', {
                layout: 'admin',
                title: 'Xóa danh mục thất bại',
                user: req.user,
                msg: 'Không thể xóa danh mục đang chứa sản phẩm.'
            })
        }
        // Xóa
        await categoryM.deleteCategory(id);
        return res.render('admin/category_delete', {
            layout: 'admin',
            title: 'Xóa danh mục thành công',
            user: req.user,
            msg: 'Danh mục xóa thành công'
        })
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});


router.get('/user', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let users = await accountM.all((page - 1) * MAX_ITEMS, MAX_ITEMS);

        // Render
        res.render('admin/user', {
            layout: 'admin',
            users,
            title: 'Thành viên',
            user: req.user,
        });
    }
    catch(err) {
        next(createError(500));
    }
});

router.get('/product', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let products = await productM.all((page - 1) * MAX_ITEMS, MAX_ITEMS);
        for (let product of products) {
            let author = await productM.getAuthor(product.ID);
            product.author = author[0].USERNAME;
        }
        // Render
        res.render('admin/product', {
            layout: 'admin',
            products,
            title: 'Sản phẩm',
            user: req.user,
        });
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});

module.exports = router;