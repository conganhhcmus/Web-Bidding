module.exports = {
    getMoneyVNDString: async val => {
        let temp = parseInt(val);
        let result = temp.toLocaleString('it-IT', {style : 'currency', currency : 'VND'});
        result = result.replace("₫","");
        return result;
    },

    getTimeNow: () => {
        var tzoffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
        return (new Date(Date.now() - tzoffset)).toISOString().slice(0, 19).replace('T', ' ');
    },

    parseTime: (time) => {
        return new Date(Date.parse(time)).toISOString().slice(0, 19).replace('T', ' ');
    },
};