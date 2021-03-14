const port = process.env.PORT || 4000;

const express = require('express');
const app = express();
const cors = require("cors");
// const debug = require('debug')('server');

app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use('/*', function(req, res, next) {
    // do your filtering here, call a `res` method if you want to stop progress or call `next` to proceed
    let ip = req.ip || 
                req.headers['x-forwarded-for'] || 
                req.connection.remoteAddress || 
                req.socket.remoteAddress ||
                req.connection.socket.remoteAddress;

    console.log('Request ip:', ip);
    next();
});

app.get('/', (req, res) => res.send('Test server is running'));

app.get('/hello', (req, res) => {
    // console.log('Request:', req);
    // console.log('Request headers:', req.headers);
    console.log('Request headers user agent:', req.headers["user-agent"]);
    res.send('Helloooo');
});

app.get('/mt/api/users/posts', (req, res) => {
    var file = require("./resources/response1.json");
    res.json(file);
});

app.listen(port, () => console.log(`Test server is listening on port ${port}!`));