import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/ProductApi.dart';

import '../../../layout/DefaultLayout.dart';

import './components/HomeBanner.dart';
import './components/HomeNews.dart';
import './components/HomeHot.dart';
import './components/HomeProduct.dart';

class HomePage extends ConsumerWidget {
  final productApi = ProductApi();
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      child: Column(
        children: <Widget>[
          HomeBanner(),
          HomeNews(),
          HomeHot(),
          HomeProduct(),
        ],
      ),
    );
  }
}