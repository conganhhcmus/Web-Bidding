const db = require('../utils/db');
const tbName = 'auction_history';
const pageSize = 4;

module.exports = {
    add: async element => {
        const id = await db.add(tbName,element);
        return id;
    },
    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = await db.load(sql);
        return rows;
    },
    
    allByProductIDPaging: async (id) => {
        //let sql = `SELECT COUNT(*) as total FROM ${tbName} WHERE PRODUCT_ID=${id}`;
        //const rs = await db.load(sql);
        //const totalU = parseInt(rs[0].total)
        // const pageTotal = Math.floor(totalU / pageSize) + 1;
        //const offset = (page - 1) * pageSize;
        //sql = `SELECT * FROM ${tbName} WHERE PRODUCT_ID=${id} LIMIT ${pageSize} OFFSET ${offset}`;
        let sql = `SELECT * FROM ${tbName} WHERE PRODUCT_ID=${id}`;
        const rows = await db.load(sql);
        return {
            historys: rows,
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
};