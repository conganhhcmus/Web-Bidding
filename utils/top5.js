const productM = require('../models/product.M');
const imageM = require('../models/image.M')
const utils = require('./utilsFunction');


module.exports = {
    top5Price: async () => {
        let temp = await productM.top5Price();

        for (var i = 0; i < temp.length; i++) {
            temp[i].imgSrc = (await imageM.allByProID(temp[i].ID))[0];
            var temp1 = new Date(temp[i].END_TIME);
            var temp2 = utils.getRemainTime(temp1);
            temp[i].remain = temp2[0];
            var temp1 = new Date(temp[i].START_TIME);
            var temp2 = utils.getRemainTime(temp1);
            temp[i].isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 1;

            temp[i].isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 0;
            temp[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(temp[i].CURRENT_PRICE);
            temp[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(temp[i].BUYNOW_PRICE);
        }

        return temp;
    },

    top5End: async () => {
        let temp = await productM.top5End();

        for (var i = 0; i < temp.length; i++) {
            temp[i].imgSrc = (await imageM.allByProID(temp[i].ID))[0];
            var temp1 = new Date(temp[i].END_TIME);
            temp[i].remain = utils.getRemainTime(temp1)[0];
            var temp1 = new Date(temp[i].START_TIME);
            var temp2 = utils.getRemainTime(temp1);
            temp[i].isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 1;
    
            temp[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(temp[i].CURRENT_PRICE);
            temp[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(temp[i].BUYNOW_PRICE);

        }

        return temp;
    },

    top5DG: async () => {
        let temp = await productM.top5DauGia();

        for (var i = 0; i < temp.length; i++) {
            temp[i].imgSrc = (await imageM.allByProID(temp[i].ID))[0];
            var temp1 = new Date(temp[i].END_TIME);
            temp[i].remain = utils.getRemainTime(temp1)[0];
            var temp1 = new Date(temp[i].START_TIME);
            var temp2 = utils.getRemainTime(temp1);
            temp[i].isNew = temp2[1] == 0 && temp2[2] == 0 && temp2[3] <= 30 && temp2[5] == 1;
    
            temp[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(temp[i].CURRENT_PRICE);
            temp[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(temp[i].BUYNOW_PRICE);

        }

        return temp;
    },
}