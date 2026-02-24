const express=require('express');
const router=express.Router();
const {marked}=require("marked");
const Note=require("../models/note");


//api for sending html
router.post("/render", (req, res)=>{
    try{
        console.log("getting request");
    const {markdown}=req.body;
    

    if(!markdown) {
        return res.status(404).json({success: false, message: "value null"});
    }

    const html=marked(markdown);
    return res.status(200).json({success: true, data: html});
}catch(err){
    console.log(err);
    return res.status(500).json({success: false, message: "server error"});
}
});

//api for saving 
router.post("/save", async (req, res) => {
  const { key, markdown } = req.body;

  try {

     if (!key || key.trim() === "") {
    return res.status(400).json({
      success: false,
      message: "Key is required"
    });
  }

  if (!markdown || markdown.trim() === "") {
    return res.status(400).json({
      success: false,
      message: "Markdown content is required"
    });
  }

    //update if keys same
    const note = await Note.findOneAndUpdate(
      {key: key},
      {markdown: markdown},
      {upsert: true, returnDocument: 'after'}
    );

   return  res.json({ success: true, data: note });
  } catch (err) {
    return res.status(500).json({ success: false, message: "some server error" });
  }
});


//api for retrieving
router.get("/note/:key", async (req, res) => {
  try {
    const note = await Note.findOne({ key: req.params.key });

    if (!note) {
      return res.status(404).json({ success: false, message: "Not found" });
    }

    return res.json({ success: true, data: note });
  } catch (err) {
    return res.status(500).json({ success: false, message: "Server error"});
  }
});

module.exports=router;