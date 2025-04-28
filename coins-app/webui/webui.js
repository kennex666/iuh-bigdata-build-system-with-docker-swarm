var express = require('express');
var app = express();
var redis = require('redis');

var client = redis.createClient({url: 'redis://redis:6379'});

client.on("error", function (err) {
    console.error("Redis error", err);
});


app.get('/', function (req, res) {
    res.redirect('/index.html');
});



app.get('/json', function (req, res) {
    client.hlen('wallet', function (err, coins) {
        client.get('hashes', function (err, hashes) {
            var now = Date.now() / 1000;
            res.json( {
                coins: coins,
                hashes: hashes,
                now: now
            });
        });
    });
});


app.use(express.static('files'));

var PORT = 80;

var server = app.listen(PORT, function (err) {
    if (err) console.log(err);
    console.log('WEBUI running on PORT',PORT);
});
