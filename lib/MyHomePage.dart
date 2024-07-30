import 'package:chat_with_gemini/message.dart';
import 'package:chat_with_gemini/themeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  final List<Message> _message = [
/*    Message(text: "Hii", isUser: true),
    Message(text: "Hello, what's up ?", isUser: false),
    Message(text: "Great and you ? ", isUser: true),
    Message(text: "I'm Excellent", isUser: false)*/
  ];

  bool isLoading = false;
  final _scrollController = ScrollController();

  ThemeMode currentTheme = ThemeMode.light;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGeminiModel(true);
  }

  void callGeminiModel(bool callAuto) async {
    isLoading = true;
    _message.add(Message(text: "Loading", isUser: false));
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeOut,
      );
    });

    try {
      final model = GenerativeModel(
          model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
      final prompt =
          (callAuto == true) ? "Say only Hello Pratham!! How can I help you" : _controller.text.trim();
      final content = [Content.text(prompt)];
      _controller.clear();
      final response = await model.generateContent(content);

      isLoading = false;
      setState(() {
        _message.removeLast();
        _message.add(Message(text: response.text!.toString(), isUser: false));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          // Adjust the duration as needed
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentTheme = ref.read(themeProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/robot.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Hello, Pratham",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))
              ],
            ),
            InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("onBoarding", false);
                  if (!mounted) return;
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                child: (currentTheme == ThemeMode.light)
                    ? Visibility(
                  visible: false,
                      child: const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.white,
                        ),
                    )
                    : Visibility(
                  visible: true,
                      child: const Icon(
                          Icons.light_mode_outlined,
                          color: Colors.white,
                        ),
                    ))
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _message.length,
                itemBuilder: (context, index) {
                  final message = _message[index];
                  return ListTile(
                    title: Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),

                                    blurRadius: 7,
                                    offset: const Offset(0, 3))
                              ],
                              color: message.isUser
                                  ? Colors.blue
                                  : Colors.grey[300],
                              borderRadius: message.isUser
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                          child: isLoading
                              ? (index == _message.length - 1)
                                  ? const SizedBox(
                                      width: 70,
                                      height: 20, child: SpinKitThreeBounce(
                                        size: 20,
                                        color: Colors.blue,
                                      ))
                                  : SelectableLinkify(onOpen: (link) async {
                            if (!await launchUrl(Uri.parse(link.url))) {
                              throw Exception('Could not launch ${link.url}');
                            }
                          }, text:message.text, style: TextStyle(color: message.isUser ? Colors.white : Colors.black,), linkStyle: message.isUser ? TextStyle(color: Colors.white,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid,decorationColor: Colors.white) :TextStyle(color: Colors.blue,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid,decorationColor: Colors.blue),)
                              : SelectableLinkify(onOpen: (link) async {
                              if (!await launchUrl(Uri.parse(link.url))) {
                                throw Exception('Could not launch ${link.url}');
                              }
                            }, text:message.text, style: TextStyle(color: message.isUser ? Colors.white : Colors.black,), linkStyle: message.isUser ? TextStyle(color: Colors.white,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid,decorationColor: Colors.white) :TextStyle(color: Colors.blue,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid,decorationColor: Colors.blue),),)),
                    //  leading:  !message.isUser ? CircleAvatar(child: Image.asset('assets/robot.png',width: 20,height: 20,)) : SizedBox(),
                  );
                }),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32.0, top: 16.0, right: 16.0, left: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3))
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Ask your question...",
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _message.add(Message(
                                text: _controller.text.toString(),
                                isUser: true));
                            setState(() {});
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                // Adjust the duration as needed
                                curve: Curves.easeOut,
                              );
                            });
                            callGeminiModel(false);
                          }
                        },
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.blue,
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
