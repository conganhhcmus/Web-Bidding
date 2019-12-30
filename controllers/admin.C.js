const express = require('express');
const passport = require('passport');
const createError = require('http-errors');
const db = require('../utils/db');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');

router.get('/', (req, res, next) =>{
    if (req.isAuthenticated() && req.user.PERMISSION == 1){
        res.redirect('/admin/category');
    } else {
        res.redirect('/admin/category');

//        next(createError(403));
    }
    next();
});


router.get('/category', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let categories = await categoryM.all((page - 1) * 10, 10);
        // Lấy tên thư mục cha
        for (let category of categories) {
            category.parent_name = await categoryM.getNameByID(category.PARENT_ID);
        }
        // Render
        res.render('admin/category', {layout: 'admin', categories: categories});
    }
    catch(err) {
        next(createError(500));
    }
});

router.all('/category/:id/edit', async (req, res, next) => {
    try {
        let id = parseInt(req.params.id);
        let pid = parseInt(req.body.cat_id);
        let name = req.body.cat_name;
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
        res.render('admin/category_edit', {layout: 'admin', category, pCategories, isSuccessful: isSuccessful > 0});
    }
    catch(err) {
        next(createError(500));
    }
});


router.get('/category/create', async (req, res, next) => {
    try {
        // Lấy tên các danh mục mục cha khác
        let pCategories = await categoryM.allParentCats();
        // Render
        res.render('admin/category_create', {layout: 'admin', pCategories});
    }
    catch(err) {
        next(createError(500));
    }
});

router.post('/category/create', async (req, res, next) => {
    try {

        let pid = parseInt(req.body.cat_id);
        let name = req.body.cat_name;
        if (pid > 0) await categoryM.createCategory(pid, name);
        else await categoryM.createParentCategory(name);

        // Render
        res.redirect('/admin/category');
    }
    catch(err) {
        next(createError(500));
    }
});

router.get('/category/:id/delete', async (req, res, next) => {
    try {
    }
    catch(err) {
        next(createError(500));
    }
});


router.get('/user', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let users = await accountM.all((page - 1) * 10, 10);

        // Render
        res.render('admin/user', {layout: 'admin', users});
    }
    catch(err) {
        next(createError(500));
    }
});

router.get('/product', async (req, res, next) => {
    try {
        let page = parseInt(req.query.page || 1);
        let products = await productM.all((page - 1) * 10, 10);
        for (let product of products) {
            let author = await productM.getAuthor(product.ID);
            product.author = author[0].USERNAME;
        }
        // Render
        res.render('admin/product', {layout: 'admin', products});
    }
    catch(err) {
        console.log(err);
        next(createError(500));
    }
});

module.exports = router;