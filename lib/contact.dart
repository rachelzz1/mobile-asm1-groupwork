import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  ContactState createState() => ContactState();
}

class ContactState extends State<Contact> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(text);
    });
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // 顶部标题栏
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, size: 22),
                    ),
                    const SizedBox(width: 29),
                    const Text(
                      "Customer Service",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // 分割线
              Container(height: 2, color: Color(0xFFD9D9D9)),

              // 聊天内容区域
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: _messages.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Center(
                        child: Text(
                          "Today",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB4B4B4),
                          ),
                        ),
                      );
                    } else if (index == 1) {
                      // 客服消息 + 左侧圆形头像
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36, // 比图片稍大，露出背景颜色
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFEFD5), // 米色背景
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/customer_service.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 11),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFFFEFD5),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: const SizedBox(
                                width: 239,
                                child: Text(
                                  "Hello! I am your exclusive customer service, and I am happy to serve you! If you have any questions, you can ask me~",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // 用户消息 + 右侧圆形头像
                      final msg = _messages[index - 2];
                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 240),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F7FA),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                msg,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 36, // 比图片稍大，露出背景颜色
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0F7FA), // 米色背景
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/profile_avatar.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),

              // 底部输入栏
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 13,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEFD4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    // 拍照图标
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 8),
                      child: Image.network(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/wbfPbyq3KV/2tk7jmt3_expires_30_days.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    // 相册图标
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.network(
                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/wbfPbyq3KV/wnygmkq4_expires_30_days.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    // 输入框 + 发送按钮
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCF6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  hintText: "Enter your message",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB4B4B4),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.black),
                              onPressed: _sendMessage,
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
