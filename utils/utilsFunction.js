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
        var tzoffset = (new Date()).getTimezoneOffset() * 60000; //offset in milliseconds
        return new Date(Date.parse(time) - tzoffset).toISOString().slice(0, 19).replace('T', ' ');
    },

    formatDate: (time) => {
        return time.getDate() + '/' + (time.getMonth() + 1) + '/' + time.getFullYear();
    },

    formatDate2: (time) => {
        return (time.getMonth() + 1) + '/' + time.getDate() + '/' + time.getFullYear();
    },

    formatDateTime: (time) => {
        return time.getDate() + '/' + (time.getMonth() + 1) + '/' + time.getFullYear() + ' ' + (time.getHours() < 10 ? '0' : '') + time.getHours() + ':' + (time.getMinutes() < 10 ? '0' : '') + time.getMinutes() + ':' + (time.getSeconds() < 10 ? '0' : '') + time.getSeconds();
    },

    getRemainTime: (end) => {
        var today = new Date();
        var temp1 = end;
        var a = parseInt(temp1.getTime() / 1000 - today.getTime() / 1000);
        var HOURS = parseInt(a / 3600);
        var MINUTES = parseInt((a - HOURS * 3600) / 60);
        var SECONDS = a - HOURS * 3600 - MINUTES * 60;
        var DAYS = Math.floor(HOURS / 24);
        HOURS = Math.abs(HOURS) % 24 * (HOURS < 0 ? -1 : 1);
        var str, negative = 0;
        if (DAYS >= 0 && HOURS >= 0 && MINUTES >= 0 && SECONDS >= 0) {
            str = DAYS + ' ngày ' + HOURS + ' giờ'

            if (DAYS == 0) {
                str = HOURS + ' giờ ' + MINUTES + ' phút'
                if (HOURS == 0)
                    str = (MINUTES > 0 ? (MINUTES + ' phút ') : '') + SECONDS + ' giây'

            }
        }
        else {
            negative = 1;
            DAYS = Math.abs(DAYS);
            HOURS = Math.abs(HOURS);
            MINUTES = Math.abs(MINUTES);
            SECONDS = Math.abs(SECONDS);

            str = DAYS + ' ngày ' + HOURS + ' giờ'
            if (DAYS == 0) {
                str = HOURS + ' giờ ' + MINUTES + ' phút'
                if (HOURS == 0)
                    str = (MINUTES > 0 ? (MINUTES + ' phút ') : '') + SECONDS + ' giây'

            }
            str = 'Kết thúc ' + str;
        }

        return [str, DAYS, HOURS, MINUTES, SECONDS, negative];
    }
};