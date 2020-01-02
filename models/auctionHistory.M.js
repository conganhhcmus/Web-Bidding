const db = require('../utils/db');
const tbName = 'auction_history';
const pageSize = 4;

module.exports = {
    add: async element => {
        const id = await db.add(tbName, element);
        return id;
    },
    getByID: async id => {
        const sql = `SELECT * FROM ${tbName} WHERE ID=${id}`;
        const rows = await db.load(sql);
        return rows;
    },


    getByUserAndProductID: async (user_id, pro_id) => {
        const sql = `SELECT * FROM ${tbName} WHERE USER_ID=${user_id} AND PRODUCT_ID=${pro_id}`;
        const rows = await db.load(sql);
        if (parseInt(rows.length) > 0) {
            return rows[0];
        }
        return null;
    },

    allByProductIDPaging: async (id) => {
        //let sql = SELECT COUNT(*) as total FROM ${tbName} WHERE PRODUCT_ID=${id};
        //const rs = await db.load(sql);
        //const totalU = parseInt(rs[0].total)
        // const pageTotal = Math.floor(totalU / pageSize) + 1;
        //const offset = (page - 1) * pageSize;
        //sql = SELECT * FROM ${tbName} WHERE PRODUCT_ID=${id} LIMIT ${pageSize} OFFSET ${offset};
        let sql = `SELECT * FROM ${tbName} WHERE PRODUCT_ID=${id}`;
        const rows = await db.load(sql);
        return {
            historys: rows,
        }
    },
    getWonList: async (user_id) => {
        const sql = `SELECT tb3.PRODUCT_ID,tb3.PRICE FROM (
                                                SELECT tb2.* FROM (
                                                    SELECT PRODUCT_ID, MAX(PRICE) AS MAXP FROM ${tbName}  GROUP BY PRODUCT_ID
                                                    )
                                                AS tb1 INNER JOIN ${tbName} AS tb2 ON tb1.PRODUCT_ID = tb2.PRODUCT_ID AND tb1.MAXP = tb2.PRICE
                                                ) as tb3 WHERE tb3.USER_ID = ${user_id}`

        const rows = await db.load(sql);
        return {
            wonl: rows,
        }
    },

    getAllByUserID: async (user_id) => {
        const sql = `SELECT * FROM ${tbName} WHERE USER_ID = ${user_id}`
        const rows = await db.load(sql);
        return rows
    },

    getNguoiGiuGiaCaoNhat: async proid => {
        const sql = `SELECT USER_ID FROM ${tbName}
                                     WHERE PRODUCT_ID = ${proid} AND
                                        PRICE = (SELECT 
                                            MAX(PRICE)
                                        FROM
                                         ${tbName} WHERE PRODUCT_ID = ${proid});`;
        const rows = await db.load(sql);

        if (parseInt(rows.length) > 0) {
            return rows[0];
        }
        return null;
    }
};