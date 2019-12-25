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
    const user = null;

    for(var i = 0; i < parseInt(ps.length); i++){
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
    }

    res.render('home/detail_product',{
        layout: 'home',
        user: null,
        pro: pro,
        img: img,
        ps: ps,
    });
});

router.get('/:id/categories', async (req, res) => {
    const id = parseInt(req.params.id);
    const ps = await productM.allByCatID(id);
    const cats = await categoryM.all();
    const cat = await categoryM.getByID(id);


    for(var i = 0; i < parseInt(ps.length); i++){
        ps[i].imgSrc = (await imageM.allByProID(ps[i].ID))[0];
    }

    res.render('home/category',{
        layout: 'home',
        user: null,
        cats: cats,
        cat: cat,
        ps: ps,
    });
})


module.exports = router;