import 'package:collab/collab.dart';
import 'package:collab/src/data/mail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:messages/messages.dart';
import 'message_card.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(12.0),
              color: colors.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.goNamed('home');
                        // Navigator.of(context).pop();
                      });
                    },
                    icon: Icon(Icons.arrow_back, size: 40.0),
                  ),
                  Text('Hey', style: TextStyle(fontSize: 36.0)),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final syncData = ref.watch(
                    syncedStreamProvider(widget.roomId),
                  );
                  return syncData.when(
                    data: (sync) {
                      // if (sync.objects.length != )
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   _scrollToBottom();
                      // });

                      return FutureBuilder(
                        future: getCurrrentUser(ref),
                        builder: (context, currentUser) {
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              // final user = await getUser(ref, sync.objects[index].userId);
                              return FutureBuilder(
                                future: getUser(
                                  ref,
                                  sync.objects[index].userId,
                                ),
                                builder: (context, user) {
                                  return MessageCard(
                                    message: sync.objects[index].message,
                                    isMe:
                                        currentUser.data!.uid ==
                                        sync.objects[index].userId,
                                    userName: sync.objects[index].userName,
                                    userId: sync.objects[index].userId,
                                    timestamp: sync.objects[index].timestamp,
                                    imageUrl: user.data?.imageUrl ?? '',
                                  );
                                },
                              );
                            },
                            itemCount: sync.objects.length,
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, st) => Center(child: Text(error.toString())),
                  );
                  // ListView(
                  //   controller: _scrollController,
                  //   padding: const EdgeInsets.all(16),
                  //   // children: [
                  //   //   MessageCard(
                  //   //     message: "Salut, comment ça va ?",
                  //   //     isMe: false,
                  //   //     userName: "Leo",
                  //   //     userId: "692db3f611833316441edc73",
                  //   //     timestamp: "12:40",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Super et toi !",
                  //   //     isMe: true,
                  //   //     userName: "Ryan",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:41",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Yo les gens",
                  //   //     isMe: false,
                  //   //     userName: "Dragon",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:43",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message:
                  //   //         "Tu n'étais pas sensé faire ta présentation sur l'étude de marché pour demain Dragon ?",
                  //   //     isMe: false,
                  //   //     userName: "Leo",
                  //   //     userId: "692db3f611833316441edc73",
                  //   //     timestamp: "12:45",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Si mais j'ai trop la flemme : (",
                  //   //     isMe: false,
                  //   //     userName: "Dragon",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:45",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "On a une présentation demain ?",
                  //   //     isMe: true,
                  //   //     userName: "Ryan",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:46",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Oui, le prof en à parlé mercredi passé",
                  //   //     isMe: false,
                  //   //     userName: "Volcano",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:48",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message:
                  //   //         "Mais je n'étais pas là ce jour là, j'avais un cours de Piano",
                  //   //     isMe: true,
                  //   //     userName: "Ryan",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:46",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Personne ne t'as prévenu ?",
                  //   //     isMe: false,
                  //   //     userName: "Leo",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:49",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "C'étais à qui de le prévenir ?",
                  //   //     isMe: false,
                  //   //     userName: "Dragon",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:49",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message: "Toi non ?",
                  //   //     isMe: false,
                  //   //     userName: "Leo",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:50",
                  //   //   ),
                  //   //   MessageCard(
                  //   //     message:
                  //   //         "Me***, c'est fort possible. J'étais mort se jour là",
                  //   //     isMe: false,
                  //   //     userName: "Dragon",
                  //   //     userId: "myUserId",
                  //   //     timestamp: "12:55",
                  //   //   ),
                  //   // ],
                  //   children: [],
                  // );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child:
            // Container(
            // height: 64,
            // color: colors.surface,
            // child:
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(color: colors.onSurface),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: colors.onSurface.withAlpha(153),
                          ),
                          filled: true,
                          fillColor: colors.secondary.withAlpha(51),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Container(
                      decoration: BoxDecoration(
                        // color: colors.primary,
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Consumer(
                        builder: (context, ref, child) {
                          return IconButton(
                            icon: const Icon(Icons.send_rounded),
                            // color: colors.onPrimary,
                            color: Colors.white,
                            iconSize: 26,
                            onPressed: () async {
                              final user = await getCurrrentUser(ref);

                              ref
                                  .read(messageRepositoryProvider)
                                  .sendThis(
                                    widget.roomId,
                                    Mail(
                                      id: widget.roomId,
                                      message: _controller.text,
                                      userName: user.username,
                                      userId: user.uid,
                                      timestamp: DateFormat(
                                        'HH:mm',
                                      ).format(DateTime.now()),
                                    ),
                                  );
                              setState(() {});
                              _controller.text = '';
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToBottom();
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        // ),
      ),
    );
  }
}
