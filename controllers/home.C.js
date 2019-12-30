const express = require('express');
const router = express.Router();
const passport = require('passport');
const categoryM = require('../models/category.M');
const productM = require('../models/product.M');
const accountM = require('../models/account.M');
const imageM = require('../models/image.M');
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




module.exports = router;