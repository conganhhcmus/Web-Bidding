const express = require("express");
const exphbs = require('express-handlebars');
const session = require('express-session');
const bodyParser = require('body-parser');
const passport = require('passport');
const port = 3000;

const app = express();

// set handle-bar
const hbs = exphbs.create({
    defaultLayout: 'main',
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

//

// set engine
app.engine('hbs', hbs.engine);
app.set('view engine','hbs');
app.use(express.static(__dirname + "/public"));


// account
app.use('/account',require('./controllers/account.C'));
// home
app.use('/home',require('./controllers/home.C'));


//app.use('/cat', require('./controllers/category'));

app.get('/',function(req,res){
    res.redirect('/home');
});

// error
require('./middleware/error')(app);

// passport
// app.use(passport.initialize());
// app.use(passport.session());
// app.use((res,req,next) => {
//         res.locals.user = req.user;
//         next();
// })

// run app
app.listen(port,function(){
    console.log(`Server is running on port ${port}`);
});