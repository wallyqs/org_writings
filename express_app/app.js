
var express     = require('express')
  , fs          = require('fs')
  , swig        = require('swig')
  , cons        = require('consolidate')
  , http        = require('http')
  , app         = express();

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
  name = filename.split('.')[0];
  Controllers[name] = require(__dirname + '/controllers/' + filename);
});

app.get('/', Controllers.home.index);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
