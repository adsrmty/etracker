const express = require('express');
const app = express();
const morgan = require('morgan');
const bodyParser = require('body-parser');

//settings
app.set('port', process.env.PORT || 3000);

//middlewares
app.use(morgan('dev'));
app.use(express.urlencoded({extended: false}));
app.use(express.text());

//routes
app.get('/', (req, res) => {
    res.send('Hello World!!');
    console.log(req.body);
})

app.post('/', (req, res) => {
    console.log('POST');
    const {action, input1, input2} = req.body;
    console.log('got action:', action);
    console.log('got input1:', input1);
    console.log('got input2:', input2);
    switch(action){
        case 'getUserStatus': 
            console.log('getUserStatus');
            res.send('getUserStatus,invalid');
            break;
        case 'getUserInfo':
            if(input1 == 'AAAA-AAAA' && input2 == '0000-0000-0000'){
                console.log('getUserInfo');
                res.send('getUserInfo,Isabela,Parra,sedan,red,AT-12345-ET,Active');
            }
            break;
    }
});


app.listen(app.get('port'), () =>{
    console.log(`Server on port ${app.get('port')}`);
});