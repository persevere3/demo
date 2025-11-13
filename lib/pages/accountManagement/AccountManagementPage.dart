import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';

import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

class FrenchStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = '長度最少6個字符';
  @override
  final String uppercaseLetters = '含大寫英文字母';
  @override
  final String lowercaseLetters = '含小寫英文字母';
  @override
  final String numericCharacters = '含數字';

  @override
  final String specialCharacters = '';
  @override
  final String normalLetters = '';
}

class AccountManagementPage extends ConsumerStatefulWidget {
  const AccountManagementPage({super.key});

  @override
  ConsumerState createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends ConsumerState<AccountManagementPage> {
  // 登入密碼
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _loginNewPasswordController = TextEditingController();
  final TextEditingController _loginConfirmPasswordController = TextEditingController();
  final TextEditingController _loginCodeController = TextEditingController();

  // 取款密碼
  final TextEditingController _withdrawPasswordController = TextEditingController();
  final TextEditingController _withdrawNewPasswordController = TextEditingController();
  final TextEditingController _withdrawConfirmPasswordController = TextEditingController();
  final TextEditingController _withdrawCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '帳戶管理',
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                tabs: [
                  Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.vpn_key).mr(5),
                          Text("修改登入密碼"),
                        ],
                      )
                  ),
                  Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.vpn_key).mr(5),
                          Text("修改取款密碼"),
                        ],
                      )
                  ),
                ],
              ),
            ),

            TabBarView(
              children: [
                // 修改登錄密碼
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _loginPasswordController,
                        decoration: InputDecoration(
                          labelText: '舊登入密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請輸入舊登入密碼' : null,
                      ).mb(15),
                      TextFormField(
                        controller: _loginNewPasswordController,
                        decoration: InputDecoration(
                          labelText: '新登入密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請輸入新登入密碼' : null,
                      ),
                      if(true) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   '密碼強度 : ',
                            //   style: TextStyle( color: '#777777'.toColor()),
                            // ).mr(10),
                            FlutterPwValidator(
                              controller: _loginNewPasswordController,
                              minLength: 6,
                              uppercaseCharCount: 1,
                              lowercaseCharCount: 1,
                              numericCharCount: 1,
                              strings: FrenchStrings(),
                              width: _width * 0.8,
                              height: 120,
                              onSuccess: () {
                                setState(() {
                                  // _isPasswordValid = true;
                                });
                              },
                              onFail: () {
                                setState(() {
                                  // _isPasswordValid = false;
                                });
                              },
                            ),
                          ],
                        ).ml(10).mt(5),
                        // Text(
                        //   '【密码长度最少6个字符,且含有大小写英文字母+数字组合】',
                        //   style: TextStyle( color: '#777777'.toColor()),
                        // ).mt(5)
                      ],
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _loginConfirmPasswordController,
                        decoration: InputDecoration(
                          labelText: '確認登入密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請確認登入密碼' : null,
                      ).mb(15),
                      TextFormField(
                        controller: _loginCodeController,
                        decoration: InputDecoration(
                          labelText: '请点击产生验证码',
                          prefixIcon: Icon(Icons.security, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請點擊產生驗證碼' : null,
                      ).mb(15),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text('確定提交')
                      ).w(double.infinity)
                    ],
                  ),
                ).py(5),

                // 修改取款密碼
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _withdrawPasswordController,
                        decoration: InputDecoration(
                          labelText: '舊取款密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請輸入舊取款密碼' : null,
                      ).mb(15),
                      TextFormField(
                        controller: _withdrawNewPasswordController,
                        decoration: InputDecoration(
                          labelText: '新取款密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請輸入新取款密碼' : null,
                      ).mb(15),
                      TextFormField(
                        controller: _withdrawConfirmPasswordController,
                        decoration: InputDecoration(
                          labelText: '確認取款密碼',
                          prefixIcon: Icon(Icons.vpn_key, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請確認取款密碼' : null,
                      ).mb(15),
                      TextFormField(
                        controller: _withdrawCodeController,
                        decoration: InputDecoration(
                          labelText: '请点击产生验证码',
                          prefixIcon: Icon(Icons.security, color: primaryColor),
                        ),
                        validator:
                            (value) => value == null || value.isEmpty ? '請點擊產生驗證碼' : null,
                      ).mb(15),
                      ElevatedButton(
                          onPressed: () {},
                          child: Text('確定提交')
                      ).w(double.infinity)
                    ],
                  ),
                ).py(5),
              ],
            ).flex(),
          ],
        ).px(_width *0.05).py(_height * 0.02),
      )
    );
  }
}
