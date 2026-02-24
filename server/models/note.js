const mongoose = require("mongoose");

const NoteSchema = new mongoose.Schema({
  key: {
    type: String, 
    required: true, 
    unique: true 
},
  markdown: { 
    type: String, 
    required: true 
}
});

module.exports = mongoose.model("Note", NoteSchema);