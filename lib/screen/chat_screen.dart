import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/cubit/id_jwt_cubit.dart';
import 'package:lottie/lottie.dart';

const apiKey = "AIzaSyBs3wnrJ_pUjvAok0QvJCViMKG4OOiwAnA";

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = false;
  List textChat = [];
  List textWithImageChat = [];

  late String name;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<IdJwtCubit>(context);
    name = bloc.state.idJwt.name!;
  }

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  // Text only input
  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": name,
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": '짹짹이',
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": '짹짹이',
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챗봇'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Lottie.asset(
              loading
                  ? 'assets/lotties/kkachiMotionQ.json'
                  : 'assets/lotties/kkachiLottie.json',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: textChat.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        child: textChat[index]['role'] == '짹짹이'
                            ? Image.asset(
                                'assets/images/character.jpg',
                                fit: BoxFit.cover,
                              )
                            : Text(name.substring(0, 1)),
                      ),
                      title: Text(textChat[index]["role"]),
                      subtitle: Text(textChat[index]["text"]),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: "질문을 입력해주세요!",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          fillColor: Colors.transparent,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    IconButton(
                      icon: loading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.send),
                      onPressed: () {
                        fromText(query: _textController.text);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 0,
      ),
    );
  }
}
