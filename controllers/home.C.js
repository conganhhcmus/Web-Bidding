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

    if (typeof req.user !== "undefined") {
        let id = req.user.ID;
        user = await accountM.getByID(id);      
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