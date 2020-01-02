const db = require('../utils/db');
const tbName = 'SELLER_REQUEST';

module.exports = {
    all: async () => {
        const sql = `SELECT * FROM ${tbName}`;
        const rows = await db.load(sql);
        return rows;
    },

    count: async () => {
        const sql = `SELECT COUNT(*) as count FROM ${tbName}`;
        const rows = await db.load(sql);
        return rows[0].count;
    },

    allByUserID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE USER_ID=${id}`;
        const rows = await db.load(sql);
        return rows;
    }, 

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = await db.load(sql);
        return rows;
    },

    add: async (entity) => {
        let id = await db.add(tbName, entity);
        return id;
    },

    delete: async (id) => {
        let rows = await db.delete(tbName, "ID", id);
        return rows; 
    },

}