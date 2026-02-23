const express= require("express");
const app=express();
const cors=require("cors");
const {marked}=require("marked");



app.use(cors());
app.use(express.json());

app.post("/render", (req, res)=>{
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

app.listen(8000, ()=>{
    console.log("listening");
});




















/*
Headings: Render headings using # (e.g., # Heading 1, ## Heading 2).

Bold and Italics: Support bold (**bold**) and italic (*italic*) text.

Lists: Render bullet points (- or *) and numbered lists (1.).

Links and Images: Display links ([text](url)) and images (![alt text](url)).

Code Blocks: Support inline code and code blocks (e.g., backticks).

Blockquotes: Render blockquotes using >.
*/