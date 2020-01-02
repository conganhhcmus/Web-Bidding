const express = require('express');
const router = express.Router();

//import models
const bidding = require('./../models/auctionHistory.M');
const productM = require('./../models/product.M');
const utils = require("../utils/utilsFunction");

router.post('/:id', async (req, res) => {

    // check user
    if (typeof req.user === "undefined") {
        res.redirect('/account/login');
        return;
    }

    const userID = parseInt(req.body.userid);
    const proID = parseInt(req.body.proid);
    const bid_price = parseInt(req.body.inputMoney);
    let time = utils.getTimeNow();

    const element = {
        PRODUCT_ID: proID,
        USER_ID: userID,
        TIME: time,
        PRICE: bid_price,
    }

    const result =  await bidding.add(element);
    const changedRows = await productM.updateCurrentPrice(proID,bid_price);

    // xu ly
    res.redirect(req.get('referer'));
    return;
});

module.exports = router;