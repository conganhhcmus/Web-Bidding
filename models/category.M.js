const db = require('../utils/db');
const run = require('../utils/extensionFunc').errorHandle;
const tbName = "CATEGORY";

module.exports = {
    all: async (offset, limit) => {
        const sql = `SELECT * FROM ${tbName} ${limit ? 'LIMIT ' + limit : ''} ${offset ? 'OFFSET ' + offset : ''}`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows;
    },

    allParentCats: async () => {
        const sql = `SELECT * FROM ${tbName} WHERE PARENT_ID IS NULL`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows;
    },

    toTalCats: async () => {
        const sql =`SELECT COUNT(*) as total FROM ${tbName}`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows[0].total;
    },

    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID='${id}'`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows[0];
    },

    getChildren: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE PARENT_ID='${id}'`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows;
    },


    getNameByID: async id => {
        const sql = `SELECT CAT_NAME FROM ${tbName} WHERE ID='${id}'`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows[0] ? rows[0].CAT_NAME : null;
    },

    updateCategory: async (id, pID, name) => {
        let rows = await db.update(tbName, {PARENT_ID: pID, CAT_NAME: name}, "ID", id);
        return rows;
    },

    updateNullCategory: async (id, name) => {
        let rows1 = await db.update(tbName, {CAT_NAME: name}, "ID", id);
        let rows2 = await db.updateNull(tbName, "PARENT_ID", "ID", id);
        return rows1 || rows2; 
    },

    createCategory: async (pid, name) => {
        let id = await db.add(tbName, {CAT_NAME: name, PARENT_ID: pid});
        return id; 
    },

    createParentCategory: async (name) => {
        let id = await db.add(tbName, {CAT_NAME: name});
        return id;
    },

    deleteCategory: async (id) => {
        let rows = await db.delete(tbName, "ID", id);
        return rows; 
    },
};

