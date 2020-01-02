const db = require('../utils/db');
const utils = require('../utils/utilsFunction');
const tbName = 'PRODUCT';
const pageSize = 8;

module.exports = {
    all: async (offset, limit) => {
        const sql = `SELECT * FROM ${tbName} ${limit ? 'LIMIT ' + limit : ''} ${offset ? 'OFFSET ' + offset : ''}`;
        const rows = await db.load(sql);
        return rows;
    },

    top5Price: async () => {
        const sql = `SELECT * FROM ${tbName} WHERE END_TIME > '${utils.getTimeNow()}' ORDER BY CURRENT_PRICE DESC LIMIT 4 `;
        const rows = await db.load(sql);
        return rows;
    },

    top5End: async () => {
        const sql = `SELECT * FROM ${tbName} WHERE END_TIME > '${utils.getTimeNow()}' ORDER BY END_TIME ASC LIMIT 4 `;
        const rows = await db.load(sql);
        return rows;
    },

    allByCatID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE CAT_ID=${id}`;
        const rows = db.load(sql);
        return rows;
    }, 

    allByCatIDPaging: async (id, page) => {
        let sql = `SELECT COUNT(*) as total FROM ${tbName} WHERE CAT_ID=${id}`;
        const rs = await db.load(sql);
        const totalP = parseInt(rs[0].total);
        const pageTotal = Math.floor(totalP / pageSize) + 1;
        const offset = (page - 1) * pageSize;
        sql = `SELECT * FROM ${tbName} WHERE CAT_ID=${id} LIMIT ${pageSize} OFFSET ${offset}`;
        const rows = await db.load(sql);
        return {
            pageTotal: pageTotal,
            products: rows,
        }
    },

    allBySearchNamePaging: async (name,page) => {
        let sql = `SELECT * FROM ${tbName} WHERE MATCH(PRODUCT_NAME) AGAINST ('${name}' IN NATURAL LANGUAGE MODE)`;
        const rs =await db.load(sql);
        const totalPro = parseInt(rs.length);
        const pageTotal = Math.floor(totalPro / pageSize) + 1;
        const offset = (page - 1) * pageSize;
        sql = `SELECT * FROM ${tbName} WHERE MATCH(PRODUCT_NAME) AGAINST ('${name}' IN NATURAL LANGUAGE MODE) LIMIT ${pageSize} OFFSET ${offset}`;
        const rows = await db.load(sql);
        return {
            pageTotal: pageTotal,
            products: rows,
        }
    },

    allBySearchNamePagingCat: async (name,page,catid) => {
        let sql = `SELECT * FROM ${tbName} WHERE CAT_ID=${catid} AND MATCH(PRODUCT_NAME) AGAINST ('${name}' IN NATURAL LANGUAGE MODE)`;
        const rs =await db.load(sql);
        const totalPro = parseInt(rs.length);
        const pageTotal = Math.floor(totalPro / pageSize) + 1;
        const offset = (page - 1) * pageSize;
        sql = `SELECT * FROM ${tbName} WHERE CAT_ID=${catid} AND MATCH(PRODUCT_NAME) AGAINST ('${name}' IN NATURAL LANGUAGE MODE) LIMIT ${pageSize} OFFSET ${offset}`;
        const rows = await db.load(sql);
        return {
            pageTotal: pageTotal,
            products: rows,
        }
    },

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = await db.load(sql);
        return rows;
    },

    createProduct: async (name, cat_id, seller_id, starting_price, bidding_increment, start_time, end_time, description, extension, buynow_price, time) => {
        let obj = {
            CAT_ID: cat_id,
            SELLER_ID: seller_id,
            PRODUCT_NAME: name,
            CURRENT_PRICE: starting_price,
            START_TIME: start_time,
            END_TIME: end_time,
            DESCRIPTION: description,
            BUYNOW_FLAG: buynow_price ? 1 : 0,
            STARTING_PRICE: starting_price,
            BIDDING_INCREMENT: bidding_increment,
            EXTENSION_FLAG: extension ? 1 : 0,
            TIME: time
        };
        if (buynow_price)
        obj.BUYNOW_PRICE = buynow_price;
        let id = await db.add(tbName, obj);
        return id;
    },

    updateProductImg: async (id, main_img) => {
        let rows = await db.update(tbName, {MAIN_IMAGE: main_img}, "ID", id);
        return rows;
    },

    getAuthor: async id => {
        const sql = `SELECT * FROM ${tbName} JOIN user on user.ID = ${tbName}.SELLER_ID WHERE ${tbName}.ID = ${id}`;
        const rows = await db.load(sql);
        return rows;
    }, 

    updateCurrentPrice: async (id,price) => {
        const changedRows = await db.updateV(tbName,'CURRENT_PRICE',price,id);
        return changedRows;
    }
}