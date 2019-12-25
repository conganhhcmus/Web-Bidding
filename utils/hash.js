const bcrypt = require('bcrypt');

module.exports = {
    getHashPassword: async password => {
        const saltRounds = 10;
        var salt = bcrypt.genSaltSync(saltRounds);
        var pwHash = bcrypt.hashSync(password, salt);

        return pwHash;
    },

    comparePassword: async (password,pwH) => {
        const hash = await bcrypt.compareSync(password, pwH);
        if(hash){
            return true;
        }
        return false;
    }
}