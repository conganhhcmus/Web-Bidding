const express = require('express');
const router = express.Router();
const hash = require("../utils/hash");
const accountM = require('../models/account.M');

router.get('/',async (req,res) =>{
    let user = null;

    if(typeof req.session.User !== "undefined"){
        let id = req.session.User.id;
        const user = await accountM.getByID(id);
        res.render('home/homepage',{
            layout: false,
            user: user,          
        });
        return;
    }

    res.render('home/homepage',{
        layout: false,
        user: null,
    });
    return;
});


module.exports = router;