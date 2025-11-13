import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dialog_providers.dart';
import '../services/dialog_service.dart';
import '../../../components/RightDialog.dart';
import '../../../components/LoginForm.dart';
import '../../../components/CustomerServiceList.dart';
import '../../../core/services/navigation_service.dart';

/// Dialog 模組的全局監聽器
class DialogModuleListener extends ConsumerStatefulWidget {
  const DialogModuleListener({Key? key}) : super(key: key);

  @override
  ConsumerState<DialogModuleListener> createState() => _DialogModuleListenerState();
}

class _DialogModuleListenerState extends ConsumerState<DialogModuleListener> {
  bool _isShowingDialog = false; // 防止重複顯示

  @override
  Widget build(BuildContext context) {
    // 監聽 Dialog 狀態變化
    ref.listen<DialogState>(dialogProvider, (previous, current) async {
      print('👂 DialogModuleListener: 狀態變化 $previous -> $current');

      // 處理登入表單
      if (_shouldShowLoginDialog(previous, current)) {
        await _handleShowLoginDialog();
      }

      // 處理客服列表
      if (_shouldShowCustomerServiceDialog(previous, current)) {
        await _handleShowCustomerServiceDialog();
      }
    });

    return const SizedBox.shrink(); // 不顯示 UI
  }

  /// 判斷是否應該顯示登入 Dialog
  bool _shouldShowLoginDialog(DialogState? previous, DialogState current) {
    return previous?.isShowLoginForm != current.isShowLoginForm &&
        current.isShowLoginForm &&
        !_isShowingDialog;
  }

  /// 判斷是否應該顯示客服 Dialog
  bool _shouldShowCustomerServiceDialog(DialogState? previous, DialogState current) {
    return previous?.isShowCustomerServiceList != current.isShowCustomerServiceList &&
        current.isShowCustomerServiceList &&
        !_isShowingDialog;
  }

  /// 處理顯示登入 Dialog
  Future<void> _handleShowLoginDialog() async {
    final context = NavigationService.currentContext;
    if (context == null) {
      print('❌ DialogModuleListener: Context 不可用');
      return;
    }

    print('🚀 DialogModuleListener: 顯示登入 Dialog');
    _isShowingDialog = true;

    try {
      await RightDialog.show(context, LoginForm());
      print('✅ DialogModuleListener: 登入 Dialog 已關閉');
    } catch (e) {
      print('❌ DialogModuleListener: 顯示登入 Dialog 錯誤: $e');
    } finally {
      if (mounted) {
        ref.read(dialogServiceProvider).hideLoginDialog();
        _isShowingDialog = false;
      }
    }
  }

  /// 處理顯示客服 Dialog
  Future<void> _handleShowCustomerServiceDialog() async {
    final context = NavigationService.currentContext;
    if (context == null) {
      print('❌ DialogModuleListener: Context 不可用');
      return;
    }

    print('🚀 DialogModuleListener: 顯示客服 Dialog');
    _isShowingDialog = true;

    try {
      await RightDialog.show(context, CustomerServiceList());
      print('✅ DialogModuleListener: 客服 Dialog 已關閉');
    } catch (e) {
      print('❌ DialogModuleListener: 顯示客服 Dialog 錯誤: $e');
    } finally {
      if (mounted) {
        ref.read(dialogServiceProvider).hideCustomerServiceDialog();
        _isShowingDialog = false;
      }
    }
  }
}