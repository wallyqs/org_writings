
var express     = require('express')
  , fs          = require('fs')
  , swig        = require('swig')
  , cons        = require('consolidate')
  , mongoose    = require('mongoose')
  , http        = require('http')
  , app         = express();

if(process.env.VCAP_SERVICES){
  var env = JSON.parse(process.env.VCAP_SERVICES);
  var mongo = env['mongodb-1.8'][0]['credentials'];
} else {
  var mongo = {
    "hostname":"localhost",
    "port":27017,
    "username":"",
    "password":"",
    "name":"",
    "db":"simple_express_app"
  }
}

var mongo_url = function(obj){
  obj.hostname = (obj.hostname || 'localhost');
  obj.port = (obj.port || 27017);
  obj.db = (obj.db || 'test');

  if(obj.username && obj.password){
    return "mongodb://" + obj.username + ":" + obj.password + "@" + obj.hostname + ":" + obj.port + "/" + obj.db;
  }
  else{
    return "mongodb://" + obj.hostname + ":" + obj.port + "/" + obj.db;
  }
}

mongoose.connect(mongo_url(mongo));

swig.init({
    root: __dirname + '/views',
    allowErrors: true,
    autoescape: true,
    encoding: 'utf8'
});

app.engine('html', cons.swig);

app.configure(function(){
  app.set('port', process.env.VCAP_PORT || 3000);
  app.set('views', swig.root);
  app.set('view engine', 'html');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

var Controllers = {};
fs.readdirSync(__dirname + '/controllers').forEach(function(filename){
  var name = filename.split('.')[0];
  Controllers[name] = require(__dirname + '/controllers/' + filename);
});

app.get('/'             , Controllers.home.index);
app.get('/texts/create' , Controllers.texts.create);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
