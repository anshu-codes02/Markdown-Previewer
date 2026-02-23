import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        cardColor: const Color(0xFF1E293B),
      ),
      debugShowCheckedModeBanner: false,
      home: MarkDownScreen()
    );
  }
}

class MarkDownScreen extends StatefulWidget{

  const MarkDownScreen({super.key});
  
  @override
  _MarkDownScreenState createState()=> _MarkDownScreenState();

}

class _MarkDownScreenState extends State<MarkDownScreen>{
  String renderHTML="";

  final TextEditingController controller= TextEditingController();

  Future<void> renderMarkDown(String markdown) async{
    final response= await http.post(
      Uri.parse("http://localhost:8000/render"),
      headers:{
        "Content-Type":"application/json",
      },
      body: jsonEncode({"markdown":markdown})
    );
    
    print(jsonDecode(response.body));
    if(response.statusCode==200)
    {
      final data=jsonDecode(response.body);
      setState(() {
        renderHTML=data['data'];
      });
    }
  }


  Widget build(BuildContext context)
  {
    return Scaffold(
       body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write markdown',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value){
                  renderMarkDown(value);
                }
              )
              )
               ),
               Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Html(data: renderHTML),
                  ) )
        ],)
    );
  }
}
