import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markdown Previewer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151C26),
        fontFamily: 'Fira Mono',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MarkdownPreviewer(),
    );
  }
}

class MarkdownPreviewer extends StatefulWidget {
  const MarkdownPreviewer({super.key});

  @override
  State<MarkdownPreviewer> createState() => _MarkdownPreviewerState();
}

class _MarkdownPreviewerState extends State<MarkdownPreviewer> {
  final TextEditingController _controller = TextEditingController();
  String _notification = '';

  @override
  void initState() {
    super.initState();
    _controller.text ='';
        }

  void _save() {
    setState(() {
      _notification = 'Successfully saved markdown!';
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _notification = '';
      });
    });
  }

  void _retrieve() {
    setState(() {
      _notification = 'Successfully retrieved markdown for key: test1';
      });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _notification = '';
      });
    });
  }

  String renderHTML = "";

  Future<void> renderMarkDown(String markdown) async {
    final response = await http.post(
      Uri.parse("http://localhost:8000/render"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"markdown": markdown}),
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        renderHTML = data['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Markdown Previewer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _retrieve,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Retrieve'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_notification.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _notification,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),

              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Markdown Input',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const Text(
                                  'Auto-updates preview as you type',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                onChanged: (_) => setState(() {
                                  renderMarkDown(_controller.text);
                                }),
                                maxLines: null,
                                expands: true,
                                textAlignVertical: TextAlignVertical.top,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Fira Mono',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF232B39),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          //  color: const Color(0xFF232B39),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preview',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF232B39),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Html(
                                  data: renderHTML,
                                  style: {
                                      "h1": Style(fontSize: FontSize(28), fontWeight: FontWeight.bold, color: Colors.white),
                                      "h2": Style(fontSize: FontSize(22), fontWeight: FontWeight.bold, color: Colors.white),
                                      "h3": Style(fontSize: FontSize(18), fontWeight: FontWeight.bold, color: Colors.white),
                                      "p": Style(fontSize: FontSize(15), color: Colors.white),
                                      "code": Style(fontFamily: 'Fira Mono', color: Colors.white, backgroundColor: Color(0xFF232B39)),
                                      "pre": Style(backgroundColor: Color(0xFF232B39)),
                                      "blockquote": Style(color: Colors.grey),
                                      "ul": Style(color: Colors.white),
                                      "a": Style(color: Color(0xFF2563EB), textDecoration: TextDecoration.underline
                                    ),
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
