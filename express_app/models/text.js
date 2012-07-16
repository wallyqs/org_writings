
var mongoose = require('mongoose')
  , Schema   = mongoose.Schema;

var textSchema = new Schema({
    title:      { type: String, index: true }
  , content:    { type: String }
  , created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Text', textSchema);
