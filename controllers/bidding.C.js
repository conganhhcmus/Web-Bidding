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

    //let win_id;

    const bidder_win = await bidding.getNguoiWinner(proID);

    let win_id = userID;
    let check = true;

    if (bidder_win) {
        if(bid_price < parseInt(bidder_win.MAX_PRICE)) {
            win_id = parseInt(bidder_win.USER_ID);
            //to do something
            check = false;
        }
    }

    const element = {
        PRODUCT_ID: proID,
        USER_ID: userID,
        TIME: time,
        PRICE: bid_price,
        MAX_PRICE: bid_price,
        WIN_ID: win_id,
    }

    const result =  await bidding.add(element);
    const changedRows = await productM.updateCurrentPrice(proID,bid_price);

    // add auto bid

    if(!check) {
        const auto = await bidding.getByUserAndProductID(win_id,proID);
        const new_price = bid_price + parseInt(req.body.buocgia);
        const element_auto = {
            PRODUCT_ID: proID,
            USER_ID: win_id,
            TIME: utils.getTimeNow(),
            PRICE: new_price, //update price
            MAX_PRICE: parseInt(auto.MAX_PRICE),
            WIN_ID: win_id,
        }

        await bidding.add(element_auto);
        await productM.updateCurrentPrice(proID,new_price);
    }
    

    // xu ly
    res.redirect(req.get('referer'));
    return;
});


router.post('/auto/:id', async (req, res) => {

    // check user
    if (typeof req.user === "undefined") {
        res.redirect('/account/login');
        return;
    }

    const userID = parseInt(req.body.userid);
    const proID = parseInt(req.body.proid);
    const max_price = parseInt(req.body.inputMoneyAuto);
    let time = utils.getTimeNow();

    let bid_price = parseInt(req.body.giahethong);
    const bidder_win = await bidding.getNguoiWinner(proID);


    let check = true;

    let win_id = userID;

    if (bidder_win) {
        if(max_price < parseInt(bidder_win.MAX_PRICE)) {
            win_id = parseInt(bidder_win.USER_ID);
            //to do something
            // nho hon van dau gia 
            check = false;
            bid_price = max_price;
        } else {
            bid_price = parseInt(bidder_win.MAX_PRICE) + parseInt(req.body.buocgia);
        }
    }

    console.log(win_id);
    console.log(bid_price);
    console.log(check);

    const element = {
        PRODUCT_ID: proID,
        USER_ID: userID,
        TIME: time,
        PRICE: bid_price,
        MAX_PRICE: max_price,
        WIN_ID: win_id,
    }

    const result =  await bidding.add(element);
    const changedRows = await productM.updateCurrentPrice(proID,bid_price);


    if(!check) {
        const auto = await bidding.getByUserAndProductID(win_id,proID);
        const new_price = bid_price + parseInt(req.body.buocgia);
        const element_auto = {
            PRODUCT_ID: proID,
            USER_ID: win_id,
            TIME: utils.getTimeNow(),
            PRICE: new_price, //update price
            MAX_PRICE: parseInt(auto.MAX_PRICE),
            WIN_ID: win_id,
        }

        await bidding.add(element_auto);
        await productM.updateCurrentPrice(proID,new_price);
    }

    // xu ly
    res.redirect(req.get('referer'));
    return;
});

module.exports = router;