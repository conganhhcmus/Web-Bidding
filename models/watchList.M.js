const db = require('../utils/db');
const tbName = 'watch_list';
const pageSize = 4;


module.exports = {
    add: async element => {
        const id = await db.add(tbName,element);
        return id;
    },

    allByUserIDPaging: async (id, page) => {
        let sql = `SELECT COUNT(*) as total FROM ${tbName} WHERE USER_ID=${id}`;
        const rs = await db.load(sql);
        const totalP = parseInt(rs[0].total);
        const pageTotal = Math.floor(totalP / pageSize) + 1;
        const offset = (page - 1) * pageSize;
        sql = `SELECT * FROM ${tbName} WHERE USER_ID=${id} LIMIT ${pageSize} OFFSET ${offset}`;
        const rows = await db.load(sql);
        return {
            pageTotal: pageTotal,
            products: rows,
        }
    },

    getByUserAndProductID: async (user_id, pro_id) => {
        const sql = `SELECT * FROM ${tbName} WHERE USER_ID=${user_id} AND PRODUCT_ID=${pro_id}`;
        const rows = await db.load(sql);
        if(parseInt(rows.length) > 0){
            return rows[0];
        }
        return null;
    },

    delete: async (userid, proid) => {
        const affectedRows = await db.deleteFL(tbName,userid,proid);
        return affectedRows;
    },
};