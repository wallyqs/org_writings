
var Text = require('../models/text.js');

exports.create = function(req, res){
  var t = new Text({ page_title: "Example"
                   , content: "Lorem ipsum dolor..." 
                  });

  t.save(function(err){
    if (err) console.log('Something went wrong:' + err);
  });

  res.send('Created a new text.');
};
