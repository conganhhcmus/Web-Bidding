const db = require('../utils/db');
const run = db.errorHandle;
const tbName = 'user';

module.exports = {
    all: async (offset, limit) => {
        const sql = `SELECT * FROM ${tbName} ${limit ? 'LIMIT ' + limit : ''} ${offset ? 'OFFSET ' + offset : ''}`;
        const [rows, err] = await run(db.load(sql));
        if (err) throw err;
        return rows;
    },


    add: async user => {
        const id = await db.add(tbName,user);
        return id;
    },

    delete: async username => {
        const affectedRows = awaitdb.delete(tbName,username);
        return affectedRows;
    },

    update: async (tbName1, value, id) => {
        const changedRows = await db.updateV(tbName,tbName1,value,id);
        return changedRows;
    },

    getByUserName: async username => {
        let sql = `SELECT * FROM ${tbName} WHERE USERNAME = '${username}'`;
        const rs = await db.load(sql);
        if(rs.length > 0){
            return rs[0];
        }
        return null;
    },

    getByEmail: async email => {
        let sql = `SELECT * FROM ${tbName} WHERE EMAIL = '${email}'`;
        const rs= await db.load(sql);
        if(rs.length > 0){
            return rs[0];
        }
        return null;
    },


    getByID: async id => {
        let sql = `SELECT * FROM ${tbName} WHERE ID = '${id}'`;
        const rs= await db.load(sql);
        if(rs.length > 0){
            return rs[0];
        }
        return null;
    },

    
};
