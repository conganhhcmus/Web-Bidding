const db = require('../utils/db');
const tbName = 'IMAGE';

module.exports = {
    all: async () => {
        const sql = `SELECT * FROM ${tbName}`;
        const rows = db.load(sql);
        return rows;
    },

    allByProID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE PRODUCT_ID=${id}`;
        const rows = db.load(sql);
        return rows;
    }, 

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = db.load(sql);
        return rows;
    }
}