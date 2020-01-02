const express = require('express');
const router = express.Router();
const categoryM = require('../models/category.M');
const top5 = require('../utils/top5');
const watchlistM = require("../models/watchList.M");

router.get('/', async (req, res) => {
    let user = null;

    // get all parent
    const parentCat = await categoryM.allParentCats();
    for(var i = 0; i < parseInt(parentCat.length); i++){
        parentCat[i].children = await categoryM.getChildren(parentCat[i].ID);
    }

    var top5Price = await top5.top5Price();
    var top5End = await top5.top5End();
    var top5DG = await top5.top5DG();

    const cats = await categoryM.all();

    let totalWatchList = 0;
    if(typeof req.user !== "undefined"){
        totalWatchList = await watchlistM.countProductByUserID(req.user.ID);
    }

    res.render('home/homepage', {
        layout: 'home',
        user: req.user,
        totalWatchList: totalWatchList,
        parentCat: parentCat,
        cats: cats,
        top5End: top5End,
        top5Price: top5Price,
        top5DG: top5DG,
    });
    return;
});




module.exports = router;