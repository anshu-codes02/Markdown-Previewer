

  import 'package:flutter/material.dart';
  import 'package:flutter_markdown/flutter_markdown.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
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
      _controller.text = '# Hello\n\n## Hello World\n\n### Hello World\n\n- List 1\n- List 2\n- List 3\n\n```javascript\nconsole.log("Hello World")\n```\n\n[Google](https://google.com)\n\n# Hello This is Vrushab\n\n- list 1\n- list 2';
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
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
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
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                Row(
                  children: [
                    
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF232B39),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.settings, color: Colors.white, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF232B39),
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
                                  onChanged: (_) => setState(() {}),
                                  maxLines: null,
                                  expands: true,
                                  style: const TextStyle(color: Colors.white, fontFamily: 'Fira Mono'),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFF151C26),
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
                            color: const Color(0xFF232B39),
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
                                  child: Markdown(
                                    data: _controller.text,
                                    styleSheet: MarkdownStyleSheet(
                                      h1: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                      h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                      h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                      p: const TextStyle(fontSize: 15, color: Colors.white),
                                      code: const TextStyle(fontFamily: 'Fira Mono', color: Colors.white, backgroundColor: Color(0xFF232B39)),
                                      codeblockDecoration: BoxDecoration(
                                        color: const Color(0xFF232B39),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      blockquote: const TextStyle(color: Colors.grey),
                                      listBullet: const TextStyle(color: Colors.white),
                                      a: const TextStyle(color: Color(0xFF2563EB), decoration: TextDecoration.underline),
                                    ),
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
