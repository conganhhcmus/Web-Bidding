const passport = require('passport');
const localStategy = require('passport-local').Strategy;
const accountM = require('../models/account.M');
const hash = require('../utils/hash');

passport.serializeUser(function(user, done){
    done(null,user.f_ID);
});

passport.deserializeUser(async (id,done) => {
    const user = await accountM.getByID(id);
    done(null,user);
});

passport.use(new LocalStrategy(
    async (username, password, done) => {
        const user = await accountM.getByUserName(username);
        if(user === null){
            return done(null, false, {message: 'Incorrect username.'});
        }
        if(!hash.comparePassword(password, user.f_Password)){
            return(null, false, {message: 'Incorrect password.'});
        }
        return done(null,user);
    }
));

