const express = require('express');
const router = express.Router();
const categoryM = require('../models/category.M');
const productM = require('../models/products.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');

router.get('/',async (req,res) =>{
    let user = null;
    const cats = await categoryM.all();
    const totalCat = parseInt(await categoryM.toTalCats());

    const ps = [];
    const img1 = [];
    
    for(var i = 0; i < totalCat; i++){
        ps[i] = await productM.allByCatID(cats[i].ID);
        for(var j = 0; j < parseInt(ps[i].length); j++){
            ps[i][j].imgSrc = (await imageM.allByProID(ps[i][j].ID))[0];
        }
    }

    if(typeof req.session.User !== "undefined"){
        let id = req.session.User.id;
        const user = await accountM.getByID(id);
        res.render('home/homepage',{
            layout: 'home',
            user: user, 
            cats: cats,     
            ps: ps,    
            img: img1,
        });
        return;
    }

    res.render('home/homepage',{
        layout: 'home',
        user: null,
        cats: cats,
        ps: ps,
        img: img1,
    });
    return;
});


router.get('/:id/products', async (req,res) => {
    const id = parseInt(req.params.id);
    const pro = await productM.getByID(id);
    const img = await imageM.allByProID(pro[0].ID);
    const ps = await productM.allByCatID(pro[0].CAT_ID);
    let user = null;

    if(typeof req.session.User !== "undefined"){
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }

    for(var i = 0; i < parseInt(ps.length); i++){
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
    }

    res.render('home/detail_product',{
        layout: 'home',
        user: user,
        pro: pro,
        img: img,
        ps: ps,
    });
});

router.get('/:id/categories', async (req, res) => {
    const id = parseInt(req.params.id);
    const page = parseInt(req.query.page) || 1;
    let user = null;

    if(typeof req.session.User !== "undefined"){
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }


    const rs = await productM.allByCatIDPaging(id, page);
    const ps = rs.products;
    const cats = await categoryM.all();
    const cat = await categoryM.getByID(id);

    const pages = [];
    for( var i = 0; i < rs.pageTotal; i++){
        pages[i] = {value: i + 1, active: (i+1) === page };
    }
    const navs = {};
    if(page > 1){
        navs.prev = page - 1;
    }
    if(page < rs.pageTotal){
        navs.next = page + 1;
    }

    for(var i = 0; i < parseInt(ps.length); i++){
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
    }

    res.render('home/category',{
        layout: 'home',
        user: user,
        cats: cats,
        cat: cat[0].CAT_NAME,
        ps: ps,
        pages: pages,
        navs: navs,
    });
});

router.get('/product/search', async (req,res) => {
    if(req.query.name_search){
        req.session.search_key = req.query.name_search.toString();
    }

    if(req.query.selected_option){
        req.session.option = parseInt(req.query.selected_option);
    }

    let user = null;
    if(typeof req.session.User !== "undefined"){
        let id = req.session.User.id;
        user = await accountM.getByID(id);
    }

    const option = parseInt(req.query.selected_option ||  req.session.option);
    const name = req.query.name_search || req.session.search_key;
    const page = parseInt(req.query.page) || 1;

    let rs;
    let cat;
    if(option === 0){
        rs = await productM.allBySearchNamePaging(name, page);
        cat = "All Category > " + name;
    }
    else{
        rs = await productM.allBySearchNamePagingCat(name,page,option);
        cat = (await categoryM.getByID(option))[0].CAT_NAME + " > " + name;
    }

    const pro = rs.products;
    const cats = await categoryM.all();

    for(var i = 0; i < parseInt(pro.length); i++){
        pro[i].imgSrc = (await imageM.allByProID(pro[i].ID))[0];
    }

    //set page
    const pages = [];
    for( var i = 0; i < rs.pageTotal; i++){
        pages[i] = {value: i + 1, active: (i+1) === page };
    }
    const navs = {};
    if(page > 1){
        navs.prev = page - 1;
    }
    if(page < rs.pageTotal){
        navs.next = page + 1;
    }
    // end

    res.render('home/category',{
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