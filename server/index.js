const express= require("express");
const app=express();
const cors=require("cors");
const mongoose=require("mongoose");
require("dotenv").config();

app.use(cors());
app.use(express.json());

app.use('/markdown', require("./routes/api"));

mongoose.connect(process.env.MONGO_URI)
  .then(()=>{ 
    console.log("MongoDB connected");

    app.listen(process.env.PORT, ()=>{
     console.log("listening");
    });
   }).catch(err => console.error("MongoDB error", err));






















/*
Headings: Render headings using # (e.g., # Heading 1, ## Heading 2).

Bold and Italics: Support bold (**bold**) and italic (*italic*) text.

Lists: Render bullet points (- or *) and numbered lists (1.).

Links and Images: Display links ([text](url)) and images (![alt text](url)).

Code Blocks: Support inline code and code blocks (e.g., backticks).

Blockquotes: Render blockquotes using >.
*/