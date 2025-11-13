import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dialog_providers.dart';
import '../../../components/RightDialog.dart';
import '../../../components/LoginForm.dart';
import '../../../components/CustomerServiceList.dart';

/// Dialog 服務介面 - 定義 Dialog 操作契約
abstract class IDialogService {
  void showLoginDialog();
  void hideLoginDialog();
  void showCustomerServiceDialog();
  void hideCustomerServiceDialog();
}

/// Dialog 服務實作 - 實際的業務邏輯
class DialogService implements IDialogService {
  final Ref _ref;

  DialogService(this._ref);

  @override
  void showLoginDialog() {
    print('💡 DialogService: 請求顯示登入 Dialog');
    _ref.read(dialogProvider.notifier).showLoginForm();
  }

  @override
  void hideLoginDialog() {
    print('💡 DialogService: 請求隱藏登入 Dialog');
    _ref.read(dialogProvider.notifier).hideLoginForm();
  }

  @override
  void showCustomerServiceDialog() {
    print('💡 DialogService: 請求顯示客服 Dialog');
    _ref.read(dialogProvider.notifier).showCustomerServiceList();
  }

  @override
  void hideCustomerServiceDialog() {
    print('💡 DialogService: 請求隱藏客服 Dialog');
    _ref.read(dialogProvider.notifier).hideCustomerServiceList();
  }
}

/// Dialog 服務 Provider
final dialogServiceProvider = Provider<IDialogService>((ref) => DialogService(ref));