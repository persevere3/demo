import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog 狀態類別
class DialogState {
  final bool isShowLoginForm;
  final bool isShowCustomerServiceList;

  const DialogState({
    this.isShowLoginForm = false,
    this.isShowCustomerServiceList = false,
  });

  DialogState copyWith({
    bool? isShowLoginForm,
    bool? isShowCustomerServiceList,
  }) {
    return DialogState(
      isShowLoginForm: isShowLoginForm ?? this.isShowLoginForm,
      isShowCustomerServiceList: isShowCustomerServiceList ?? this.isShowCustomerServiceList,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DialogState &&
        other.isShowLoginForm == isShowLoginForm &&
        other.isShowCustomerServiceList == isShowCustomerServiceList;
  }

  @override
  int get hashCode => isShowLoginForm.hashCode ^ isShowCustomerServiceList.hashCode;

  @override
  String toString() {
    return 'DialogState(login: $isShowLoginForm, service: $isShowCustomerServiceList)';
  }
}

/// Dialog StateNotifier
class DialogNotifier extends StateNotifier<DialogState> {
  DialogNotifier() : super(const DialogState());

  void showLoginForm() {
    print('🔵 DialogNotifier: 顯示登入表單');
    state = state.copyWith(isShowLoginForm: true);
  }

  void hideLoginForm() {
    print('🔴 DialogNotifier: 隱藏登入表單');
    state = state.copyWith(isShowLoginForm: false);
  }

  void showCustomerServiceList() {
    print('🔵 DialogNotifier: 顯示客服列表');
    state = state.copyWith(isShowCustomerServiceList: true);
  }

  void hideCustomerServiceList() {
    print('🔴 DialogNotifier: 隱藏客服列表');
    state = state.copyWith(isShowCustomerServiceList: false);
  }
}

/// Dialog Provider
final dialogProvider = StateNotifierProvider<DialogNotifier, DialogState>(
      (ref) => DialogNotifier(),
);




