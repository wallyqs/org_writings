
var Text = require('../models/text.js');

exports.index = function(req, res){
  Text.find({}, function(err, texts){    
    res.render('home/index', { page_title: 'Texts', texts: texts });
  });
};
