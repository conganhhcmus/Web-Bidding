const mysql = require('mysql');

function createConnnection() {
    return mysql.createConnection({
        host: 'localhost',
        port: '3306',
        user: 'root',
        password: 'vansenha11',
        database: 'mydb',
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
    return new Promise((resole, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `INSERT INTO ${tbName} SET ?`;
        con.query(sql, entity, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resole(results.insertId);       
        });

        con.end();
    });
}

exports.update = (tbName, tbName1, value, id) => {
    return new Promise((resole, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `UPDATE ${tbName} SET ${tbName1}='${value}' WHERE f_ID = ${id} `;
        con.query(sql, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            console.log(results);
            resole(results);
        });

        con.end();
    });
};


exports.delete = (tbName, username) => {
    return new Promise((resole, reject) => {
        const con = createConnnection();
        con.connect(err => {
            if(err){
                reject(err);
            }
        });

        const sql = `DELETE FROM ${tbName} WHERE f_Username = '${username}'`;
        con.query(sql, (error, results, fields) => {
            if(error) {
                reject(error);
            }
            resole(results);
        });

        con.end();
    });
};

exports.errorHandle = promise => {
    return promise.then(data => [data,undefined])
    .catch(err => [undefined,err]);
}