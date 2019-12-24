const db = require('../utils/db');
const tbName = 'PRODUCT';
const pageSize = 4;

module.exports = {
    all: async () => {
        const sql = `SELECT * FROM ${tbName}`;
        const rows = db.load(sql);
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
        const pageTotal = Math.floor(totalP / pageSize);
        const offet = (page - 1) * pageSize;
        sql = `SELECT * FROM ${tbName} WHERE CAT_ID=${id} LIMIT ${pageSize} OFFSET ${offset}`;
        const rows = await db.load(sql);
        return {
            pageTotal: pageTotal,
            products: rows,
        }
    },

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = db.load(sql);
        return rows;
    }
}