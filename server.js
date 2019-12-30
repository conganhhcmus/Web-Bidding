const express = require("express");
const exphbs = require('express-handlebars');
const session = require('express-session');
const bodyParser = require('body-parser');
const passport = require('passport');
const port = 3000;
const LocalStrategy = require('passport-local').Strategy
const run = require('./utils/extensionFunc').errorHandle;
const hash = require('./utils/hash');
const accountM = require('./models/account.M');

const app = express();

// set handle-bar
const hbs = exphbs.create({
    defaultLayout: 'home',
    extname: 'hbs',
});

// set body-parser
app.use(bodyParser.urlencoded({extended:false}));
app.use(bodyParser.json());

// set session
app.use(session({
    resave: true, 
    saveUninitialized: true, 
    secret: '123456', 
    cookie: { maxAge: 60000 }
}));

// Passport
app.use(passport.initialize());
app.use(passport.session());


// set engine
app.engine('hbs', hbs.engine);
app.set('view engine','hbs');

app.use(express.static(__dirname + "/public"));

passport.serializeUser(function (user, done) {
    done(null, user.ID);
});

passport.deserializeUser(async function (id, done) {
    const [user, err] = await run(accountM.getByID(id));
    done(err, user);
});

passport.use(new LocalStrategy(
    async function (username, password, done) {
        const [user, err] = await run(accountM.getByUserName(username));
        if (err) { return done(err); }
        if (!user) {
            return done(null, false, { message: 'Incorrect username.' });
        }
        const CHash = await hash.comparePassword(password, user.PASSWORD);
        if (!CHash) {
            return done(null, false, { message: 'Incorrect password.' });
        }
        return done(null, user);
    }
));
// account
app.use('/account',require('./controllers/account.C'));
// product
app.use('/product',require('./controllers/product.C'));
// cate
app.use('/category',require('./controllers/category.C'));
// admin page
app.use('/admin',require('./controllers/admin.C'));

// home
app.use('/',require('./controllers/home.C'));

//app.use('/cat', require('./controllers/category'));

// error
require('./middleware/error')(app);


// run app
app.listen(port,function(){
    console.log(`Server is running on port ${port}`);
});