const createError = require('http-errors');

module.exports = app => {
    app.use((req,res,next) => {
        next(createError(404));
    });

    app.use((err,req,res,next) => {
        let status = err.status || 500;
        let errorCode = status.toString();

        let errMsg = err.message;
        res.render(`errors/${status}`,{
            layout:false,
            errorCode,
            errMsg,
            error: err,
        });
        // res.status(status);
        // res.end();
    });
};