import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown_fl/services/markdown_service.dart';
import 'package:markdown_fl/widgets/key_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

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
        fontFamily: null,
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
  final ScrollController _previewScrollController = ScrollController();
  String _notification = '';

  @override
  void initState() {
    super.initState();
    _controller.text ='';
        }

  // notification logic for save and retrieve actions, shows a message for 2 seconds
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
      _notification = 'Successfully retrieved markdown';
      });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _notification = '';
      });
    });
  }

  String renderHTML = "";

// shows a dialog to enter a key for saving markdown

  void _showSaveDialog() {
  showDialog(
    context: context,
    builder: (_) => KeyDialog(
      title: "Save Markdown",
      hintText: "Enter key name",
      onSubmit: (key) async {
        final success = await MarkdownService.saveMarkdown(
          key,
          _controller.text,
        );

        if (success) _save();
      },
    ),
  );
}

// shows a dialog to enter a key for retrieving markdown
void _showRetrieveDialog() {
  showDialog(
    context: context,
    builder: (_) => KeyDialog(
      title: "Retrieve Markdown",
      hintText: "Enter key to load",
      onSubmit: (key) async {
        final markdown = await MarkdownService.retrieveMarkdown(key);

        if (markdown != null) {
          _controller.value = TextEditingValue(
            text: markdown,
            selection: TextSelection.collapsed(offset: markdown.length),
          );

          final html = await MarkdownService.renderMarkdown(markdown);
          if (html != null) {
            setState(() => renderHTML = html);
          }

          _retrieve();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            
            const SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
              content: Text("Key not found ")),
          );
        }
      },
    ),
  );
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
                  // save button
                  ElevatedButton(
                    onPressed: _showSaveDialog,
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
                  // retrieve button
                  ElevatedButton(
                    onPressed: _showRetrieveDialog,
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
              // notification banner
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
                      // markdown input area

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
                                onChanged: (_) async {
                                  final html = await MarkdownService.renderMarkdown(_controller.text );
                                  setState((){
                                  if (html != null) {
                                    renderHTML = html;
                                  }
                                  else {
                                    renderHTML = "";
                                  }
                                });
                                },
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
                    
                    // preview area

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
                                child: Scrollbar(
                                  controller: _previewScrollController,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _previewScrollController,
                                    padding: const EdgeInsets.all(12),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                     minWidth: MediaQuery.of(context).size.width,
                                       ),
                                      
                                      child: Html(
                                        data: renderHTML,
                                        extensions: [
                                          const TableHtmlExtension(),
                                        ],
                                        onLinkTap: (url, attributes, element) async {
                                          if (url != null) {
                                          final uri = Uri.parse(url);
                                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                                           }
                                        },
                                        style: {
                                            "h1": Style(fontSize: FontSize(28), fontWeight: FontWeight.bold, color: Colors.white),
                                            "h2": Style(fontSize: FontSize(22), fontWeight: FontWeight.bold, color: Colors.white),
                                            "h3": Style(fontSize: FontSize(18), fontWeight: FontWeight.bold, color: Colors.white),
                                            "p": Style(fontSize: FontSize(15), color: Colors.white),
                                            "code": Style(fontFamily: 'Fira Mono', color: Colors.white, backgroundColor: Color(0xFF232B39)),
                                            "pre": Style(backgroundColor: Color(0xFF232B39)),
                                            "blockquote": Style(color: Colors.grey),
                                            "ul": Style(color: Colors.white),
                                            "a": Style(color: Color(0xFF2563EB), textDecoration: TextDecoration.underline),
                                            "table": Style(backgroundColor: const Color(0xFF151C26),),
                                            "th": Style(padding: HtmlPaddings.all(8),backgroundColor: const Color(0xFF1E293B),fontWeight: FontWeight.bold,),
                                           "td": Style(
                                                padding: HtmlPaddings.all(8),
                                               ),
                                        },
                                      ),
                                    ),
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
