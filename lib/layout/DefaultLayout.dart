// lib/layout/DefaultLayout.dart
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';
import '../modules/dialog_module/services/dialog_service.dart';

import '../components/MenuDrawer.dart';
import '../components/RightDrawer.dart';
import '../components/BottomNav.dart';

class DefaultLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String? title;
  final bool hasMenuDrawer;
  final bool hasLoginForm;
  final bool hasCustomerServiceList;
  final bool hasRightDrawer;
  final bool hasBottomNav;

  const DefaultLayout({
    Key? key,
    required this.child,
    this.title,
    this.hasMenuDrawer = true,
    this.hasLoginForm = true,
    this.hasCustomerServiceList = true,
    this.hasRightDrawer = true,
    this.hasBottomNav = true,
  }) : super(key: key);

  @override
  ConsumerState<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends ConsumerState<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final dialogService = ref.read(dialogServiceProvider); // 取得服務

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title ?? config.appName)),
        backgroundColor: config.primaryColor.toColor().lighten(),
        actions: widget.hasLoginForm
            ? [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              dialogService.showLoginDialog();
            },
          ),
        ]
            : null,
      ),
      drawer: widget.hasMenuDrawer ? MenuDrawer() : null,
      body: Stack(
        children: [
          widget.child,
          if (widget.hasRightDrawer) RightDrawer(),
        ],
      ),
      bottomNavigationBar: widget.hasBottomNav ? BottomNav() : null,
    );
  }
}