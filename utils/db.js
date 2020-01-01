const mysql = require('mysql');

function createConnnection() {
    return mysql.createConnection({
        host: 'localhost',
        port: '3306',
        user: 'root',
        password: '123456',
        database: 'AUCTION',
    });
};

exports.load = sql => {
    return new Promise((resole, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if (err) {
                reject(err);              
            }
        });

        con.query(sql, (error, results, fields) => {
            if(error){
                reject(error);
            }
            resole(results);
        });
        con.end();
    });
};

exports.add = (tbName, entity) => {
    return new Promise((resolve, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err) {
                reject(err);
            }
        });

        const sql = `INSERT INTO ${tbName} SET ?`;
        con.query(sql, entity, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resolve(results.insertId);       
        });

        con.end();
    });
};

exports.update = (tbName, entity, name, value) => {
    return new Promise((resolve, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `UPDATE ${tbName} SET ? WHERE ${name} = ?`;
        con.query(sql, [entity, value], (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resolve(results.changedRows);
        });

        con.end();
    });
};


exports.updateV = (tbName, tbName1, value, id) => {
    return new Promise((resole, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `UPDATE ${tbName} SET ${tbName1}='${value}' WHERE ID = ${id} `;
        con.query(sql, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resole(results.changedRows);
        });

        con.end();
    });
};

exports.updateNull = (tbName, nullField, idField, id) => {
    return new Promise((resolve, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if (err) {
                reject(err);
            }
        });

        const sql = `UPDATE ${tbName} SET ${nullField} = NULL WHERE ${idField} = ${id}`;
        con.query(sql, (error, results, fields) => {
            if (error) {
                reject(error);
            }
            resolve(results.changedRows);
        });
        con.end();
    });
};


exports.delete = (tbName, name, value) => {
    return new Promise((resolve, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `DELETE FROM ${tbName} WHERE ${name} = ?`;
        con.query(sql, value, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resolve(results.changedRows);
        });

        con.end();
    });
};

exports.deleteFL = (tbName, userid, proid) => {
    return new Promise((resolve, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `DELETE FROM ${tbName} WHERE USER_ID = ${userid} AND PRODUCT_ID = ${proid}`;
        con.query(sql, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resolve(results.changedRows);
        });

        con.end();
    });
};


exports.errorHandle = promise => {
    return promise.then(data => [data,undefined])
    .catch(err => [undefined,err]);
}