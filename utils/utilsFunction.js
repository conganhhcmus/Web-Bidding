module.exports = {
    getMoneyVNDString: async val => {
        let temp = parseInt(val);
        let result = temp.toLocaleString('it-IT', {style : 'currency', currency : 'VND'});
        result = result.replace("₫","");
        return result;
    }
};