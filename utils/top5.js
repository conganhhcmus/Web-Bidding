const productM = require('../models/products.M');
const imageM = require('../models/image.M')
const utils = require('./utilsFunction');


module.exports = {
    top5Price: async () => {
        let temp = await productM.all();

        for (let i = 0; i < temp.length - 1; i++) {
            for (let j = i + 1; j < temp.length; j++) {
                if (temp[i].CURRENT_PRICE < temp[j].CURRENT_PRICE) {
                    let t = temp[i];
                    temp[i] = temp[j];
                    temp[j] = t;
                }
            }
        }

        for (var i = 0; i < 4; i++) {
            temp[i].imgSrc = (await imageM.allByProID(temp[i].ID))[0];
            var temp1 = new Date(temp[i].END_TIME);
            var today = new Date();
            var a = parseInt(temp1.getTime() / 1000 - today.getTime() / 1000);
            temp[i].HOURS = parseInt(a / 3600);
            temp[i].MINUTES = parseInt((a - temp[i].HOURS * 3600) / 60);
            temp[i].SECONDS = a - temp[i].HOURS * 3600 - temp[i].MINUTES * 60;

            temp[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(temp[i].CURRENT_PRICE);
            temp[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(temp[i].BUYNOW_PRICE);
        }

        let result= [];
        for (var i = 0; i < 4; i++) {
            result[i] = temp[i];
        }

        return result;
    },

    top5End: async () => {
        let temp = await productM.all();

        for(var i = 0; i < temp.length; i++){
            var temp1 = new Date(temp[i].END_TIME);
            var today = new Date();
            var a = parseInt(temp1.getTime() / 1000 - today.getTime() / 1000);
            temp[i].CountEndTime = a;
        }

        for (let i = 0; i < temp.length - 1; i++) {
            for (let j = i + 1; j < temp.length; j++) {
                if (temp[i].CountEndTime > temp[j].CountEndTime) {
                    let t = temp[i];
                    temp[i] = temp[j];
                    temp[j] = t;
                }
            }
        }

        let result= [];
        for (var i = 0; i < 4; i++) {
            temp[i].imgSrc = (await imageM.allByProID(temp[i].ID))[0];
            var temp1 = new Date(temp[i].END_TIME);
            var today = new Date();
            var a = parseInt(temp1.getTime() / 1000 - today.getTime() / 1000);
            temp[i].HOURS = parseInt(a / 3600);
            temp[i].MINUTES = parseInt((a - temp[i].HOURS * 3600) / 60);
            temp[i].SECONDS = a - temp[i].HOURS * 3600 - temp[i].MINUTES * 60;

            temp[i].CURRENT_PRICE_VND = await utils.getMoneyVNDString(temp[i].CURRENT_PRICE);
            temp[i].BUYNOW_PRICE_VND = await utils.getMoneyVNDString(temp[i].BUYNOW_PRICE);

            result[i] = temp[i];
        }

        return result;
    }
}