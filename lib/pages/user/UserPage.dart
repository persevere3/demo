import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';

class Item extends StatelessWidget {
  final String name;
  final IconData icon;
  final String routerName;

  const Item({
    required this.name,
    required this.icon,
    required this.routerName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8F0FE),
            ),
            child: Icon(icon, size: 28, color: Colors.blue).mb(6),
          ),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    ).flex(1);
  }
}

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});
  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  final List<Map<String, dynamic>> avatarList =  List.generate( 9,
    (index) => {
      'id': index,
      'url':  'https://i.pravatar.cc/150?img=${index}'
    },
  );

  int activeAvatarId = 1;

  Timer? _timer;
  int _remain = 0;
  int seconds = 5;

  void _openSelectAvatarDialog() async  {
    await showDialog(
      context: context,
      builder: (context) {
        int selectedAvatarId = activeAvatarId;
        return AlertDialog(
          title: const Text('編輯頭像'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: StatefulBuilder(builder: (context, setState) {
              return GridView.builder(
                itemCount: avatarList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAvatarId = avatarList[index]['id'];
                        });
                      },
                      child: AnimatedContainer (
                          duration: const Duration(milliseconds: 300),
                          padding: avatarList[index]['id'] == selectedAvatarId ? const EdgeInsets.all(4) : EdgeInsets.zero,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: avatarList[index]['id'] == selectedAvatarId ? Colors.blue : Colors.transparent, width: 3)
                          ),
                          child: ClipOval(
                              child: Image.network(
                                  avatarList[index]['url'],
                                  width: avatarList[index]['id'] == selectedAvatarId ? 70 : 60,
                                  height: avatarList[index]['id'] == selectedAvatarId ? 70 : 60,
                                  fit: BoxFit.cover
                              )
                          )
                      )
                  );
                },
              );
            })
          ),

          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  activeAvatarId = selectedAvatarId;
                });
                Navigator.pop(context);
              },
              child: Text('確定')
            )
          ]
        );
      }
    );
  }

  void _startCountdown() {
    if (_timer != null) return; // 已在倒數就不重啟
    setState(() => _remain = seconds);

    // 先立即更新一次也可以（若需要「按下就顯示秒數」的即時感）
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        _remain--;
        if (_remain <= 0) {
          t.cancel();
          _timer = null;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    final double adaptorSize = _width * 0.245;

    final Color amountColor = Colors.blue;

    final bool counting = _timer != null;

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _openSelectAvatarDialog,
                child: SizedBox(
                  width: adaptorSize,
                  height: adaptorSize,
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                          avatarList[activeAvatarId].isNotEmpty ? NetworkImage(avatarList[activeAvatarId]['url']) : null,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 28,
                            color: Colors.black45,
                            alignment: Alignment.center,
                            child: const Text(
                              '編輯',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).mb(_height * 0.01),
              Text('Test', style: TextStyle(
                  color: '#666666'.toColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700
              )).mb(_height * 0.01),

              Container(
                  width: double.infinity,
                  height: _height * 0.12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: '#ffffff'.toColor()
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('帳戶餘額', style: TextStyle(
                            fontSize: 18
                        )).mb(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('0¥', style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: amountColor
                            )).mr(10),
                            IconButton(
                              tooltip: counting ? '$_remain 秒' : '開始倒數',
                              // 倒數中禁止點擊
                              onPressed: counting ? null : _startCountdown,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: counting
                                    ? Text(
                                  '$_remain',
                                  key: ValueKey('count_$_remain'),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: amountColor),
                                )
                                    : Icon(Icons.refresh, color: amountColor, key: ValueKey('icon_timer')),
                              ),
                              // 可依需求微調命中區大小與回饋半徑
                              splashRadius: 24,
                            )
                          ],
                        )
                      ]

                  )
              ).mb(_height * 0.01),
              Container(
                  width: double.infinity,
                  height: _height * 0.08,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: '#ffffff'.toColor()
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward_rounded, color: amountColor).mr(5),
                          Text('我要存款', style: TextStyle(
                              fontSize: 16
                          ))
                        ],
                      ).flex(1),
                      Container(
                        width: 1,
                        height: _height * 0.065,
                        color: '#cccccc'.toColor(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward_rounded, color: Colors.purple).mr(5),
                          Text('我要取款', style: TextStyle(
                              fontSize: 16
                          ))
                        ],
                      ).flex(1)
                    ],
                  )
              ).mb(_height * 0.01),
              Container(
                  width: double.infinity,
                  height: _height * 0.20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: '#ffffff'.toColor()
                  ),
                  child: Column(
                    children: [
                      Text('帳戶專區', style: TextStyle(
                          fontSize: 16
                      )).p(20).w(double.infinity),
                      Container(
                        width:  _width * 0.85,
                        height: 1,
                        color: '#cccccc'.toColor(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var i = 0; i < 4; i++)
                            Item(name: '項目 $i', icon: Icons.apps, routerName: '')
                        ],
                      ).flex(),
                    ],
                  )
              ).mb(_height * 0.01),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: '#ffffff'.toColor()
                ),
                child: Column(
                  children: [
                    Text('活動專區', style: TextStyle(
                        fontSize: 16
                    )).p(20).w(double.infinity),
                    Container(
                      width:  _width * 0.85,
                      height: 1,
                      color: '#cccccc'.toColor(),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // 禁用滾動
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,        // 4排
                        mainAxisSpacing: 4,      // 水平間距（主軸為水平）
                        crossAxisSpacing: 4, // 垂直間距
                        // 或改用 childAspectRatio 依內容比例控制寬高
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        return Item(name: '活動$index', icon: Icons.notifications_active_sharp , routerName: '');
                      },
                    ),
                  ],
                )
              ).mb(_height * 0.01),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: '#ffffff'.toColor()
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('登出', style: TextStyle(
                              fontSize: 16
                          )).p(20),
                          Icon(Icons.chevron_right, size: 30, color: amountColor).mr(10),
                        ]
                    )
                  )
              )
            ],
          ).px(_width * 0.03).py(_height *0.05)
              .bg(Color.fromRGBO(235, 240, 243, 0.95))
      )
    );
  }
}




