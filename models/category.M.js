const db = require('../utils/db');
const tbName = "CATEGORY";

module.exports = {
    all: async () => {
        const sql = `SELECT * FROM ${tbName}`;
        const rows = await db.load(sql);
        return rows;
    },

    toTalCats: async () => {
        const sql =`SELECT COUNT(*) as total FROM ${tbName}`;
        const rows = await db.load(sql);
        return rows[0].total;
    },

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID='${id}'`;
        const rows = await db.load(sql);
        return rows;
    },
};

