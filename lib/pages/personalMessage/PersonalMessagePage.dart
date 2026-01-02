import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/RecordQueryButton.dart';
import '../../../components/StickyExpandableTable.dart';
import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

// 信息數據類
class Message {
  final String id;
  final String subject;
  final String content;
  final DateTime date;
  final bool isRead;

  Message({
    required this.id,
    required this.subject,
    required this.content,
    required this.date,
    this.isRead = false,
  });
}

class PersonalMessagePage extends ConsumerStatefulWidget {
  const PersonalMessagePage({super.key});
  @override
  ConsumerState<PersonalMessagePage> createState() => _PersonalMessagePageState();
}

class _PersonalMessagePageState extends ConsumerState<PersonalMessagePage> {
  // 5筆假資料
  final List<Message> messages = [
    Message(
      id: '1',
      subject: '系統維護通知',
      content: '親愛的用戶您好，我們將於2025年1月5日凌晨2:00-4:00進行系統維護，屆時服務將暫時中斷，造成不便敬請見諒。',
      date: DateTime(2025, 1, 2, 10, 30),
      isRead: false,
    ),
    Message(
      id: '2',
      subject: '新功能上線',
      content: '我們很高興地宣布，新版本已經上線！本次更新包含多項功能優化，包括更快的加載速度、更美觀的界面設計，以及全新的數據分析功能。',
      date: DateTime(2024, 12, 28, 15, 20),
      isRead: true,
    ),
    Message(
      id: '3',
      subject: '您的反饋已收到',
      content: '感謝您提交的寶貴意見。我們已經收到您關於界面優化的建議，開發團隊正在評估並將在下一版本中考慮實施。',
      date: DateTime(2024, 12, 25, 9, 15),
      isRead: true,
    ),
    Message(
      id: '4',
      subject: '安全提醒',
      content: '為了保障您的帳號安全，請定期更換密碼，並避免在公共場所使用本服務。如發現異常登錄行為，請立即聯繫客服。',
      date: DateTime(2024, 12, 20, 14, 45),
      isRead: true,
    ),
    Message(
      id: '5',
      subject: '節日問候',
      content: '祝您新年快樂！感謝您一直以來的支持與信任。在新的一年裡，我們將持續為您提供更優質的服務。',
      date: DateTime(2024, 12, 31, 23, 59),
      isRead: false,
    ),
  ];

  // 顯示發信 Dialog
  void _showSendMessageDialog(Color primaryColor) {
    final subjectController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.email, color: primaryColor, size: 30).mr(5),
            Text('發送訊息'),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 主旨框
                TextFormField(
                  controller: subjectController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: '主旨',
                    border: OutlineInputBorder(),
                    helperText: '主旨的字数上限为50字',
                    helperStyle: TextStyle(color: Colors.grey.shade600),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入主旨';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 內容框
                TextFormField(
                  controller: contentController,
                  maxLength: 300,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: '內容',
                    border: OutlineInputBorder(),
                    helperText: '内容的字数上限为300字',
                    helperStyle: TextStyle(color: Colors.grey.shade600),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入內容';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // 提示文字
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.lighten(0.4),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: primaryColor.darken(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: primaryColor.darken(0.2), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '任何网站功能或建议反馈可以发信至线上客服回报问题',
                          style: TextStyle(
                            fontSize: 13,
                            color: primaryColor.darken(0.2),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('返回'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // 提交成功
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('訊息已送出，我們會盡快回覆您'),
                    backgroundColor: primaryColor.lighten(0.2),
                  ),
                );
              }
            },
            child: Text('提交'),
          ),
        ],
      ),
    );
  }

  // 顯示訊息詳細內容 Dialog
  void _showMessageDetailDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message.subject,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 日期
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(message.date),
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Divider(height: 24),
              // 內容
              Text(
                message.content,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('關閉'),
          ),
        ],
      ),
    );

    // 標記為已讀
    setState(() {
      final index = messages.indexWhere((m) => m.id == message.id);
      if (index != -1) {
        messages[index] = Message(
          id: message.id,
          subject: message.subject,
          content: message.content,
          date: message.date,
          isRead: true,
        );
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '個人信息',
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10),
            alignment: Alignment.centerRight, // 置右
            child: TextButton.icon(
              onPressed: () => _showSendMessageDialog(primaryColor),
              icon: Icon(Icons.email, size: 24),
              label: Text(
                '發信',
                style: TextStyle(fontSize: 20),
              ),
              style: TextButton.styleFrom(
                minimumSize: Size(150, 50),
              ),
            ),
          ),
          messages.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  '暫無訊息',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: messages.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              print(index);
              final message = messages[index];
              return Card(
                elevation: message.isRead ? 1 : 3,
                color: message.isRead ? Colors.white : primaryColor.lighten(0.4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    message.isRead ? Colors.grey : primaryColor,
                    child: Icon(
                      message.isRead ? Icons.mail_outline : Icons.mail,
                      color: Colors.white,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.subject,
                          style: TextStyle(
                            fontWeight: message.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!message.isRead)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '新',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        message.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatDate(message.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => _showMessageDetailDialog(message),
                ),
              );
            },
          ).flex()
        ],
      )
    );
  }
}