import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

class CustomerServiceList extends ConsumerStatefulWidget {
  @override
  ConsumerState<CustomerServiceList> createState() => _CustomerServiceListState();
}

class _CustomerServiceListState extends ConsumerState<CustomerServiceList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _agreePolicy = false;

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return Padding(
      padding: EdgeInsets.only(top: 100, right: 50, bottom: 50, left: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              '客服列表',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ).center().mb(30),

            // 帳號
            TextFormField(
              controller: _accountController,
              decoration: InputDecoration(
                labelText: '帳號',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value == null || value.isEmpty ? '請輸入帳號' : null,
            ).mb(15),

            // 密碼
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '密碼',
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value == null || value.isEmpty ? '請輸入密碼' : null,
            ).mb(15),

            // 記住帳號密碼 & 同意用戶協議
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (val) {
                    setState(() {
                      _rememberMe = val ?? false;
                    });
                  },
                ),
                Text('記住帳號密碼'),

                Checkbox(
                  value: _agreePolicy,
                  onChanged: (val) {
                    setState(() {
                      _agreePolicy = val ?? false;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // 開啟用戶協議頁面或顯示對話框
                    },
                    child: Text(
                      '同意本站用戶協議',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ).mb(5),

            // 快速註冊與忘記密碼按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('快速註冊'),
                ),

                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text('忘記密碼'),
                ),
              ],
            ).mb(15),

            // 登入按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.lighten(0.3),     // 按鈕背景色
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (!_agreePolicy) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('請同意本站用戶協議')));
                      return;
                    }
                    // 執行登入
                  }
                },
                child: Text('登入'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
