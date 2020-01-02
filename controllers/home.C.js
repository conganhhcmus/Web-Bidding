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

    // get all parent
    const parentCat = await categoryM.allParentCats();
    for(var i = 0; i < parseInt(parentCat.length); i++){
        parentCat[i].children = await categoryM.getChildren(parentCat[i].ID);
    }

    var top5Price = await top5.top5Price();
    var top5End = await top5.top5End();

    const cats = await categoryM.all();

    res.render('home/homepage', {
        layout: 'home',
        user: req.user,
        parentCat: parentCat,
        cats: cats,
        top5End: top5End,
        top5Price: top5Price,
    });
    return;
});




module.exports = router;