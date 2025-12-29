import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

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

class RecordRebateNowPage extends ConsumerStatefulWidget {
  const RecordRebateNowPage({super.key});
  @override
  ConsumerState<RecordRebateNowPage> createState() => _RecordRebateNowPageState();
}

class _RecordRebateNowPageState extends ConsumerState<RecordRebateNowPage> {

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
        title: '即時返水',
        child: Text('即時返水')
    );
  }
}
