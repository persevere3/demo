import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/error_providers.dart';
import '../services/error_service.dart';

class ErrorModuleListener extends ConsumerStatefulWidget {
  const ErrorModuleListener({Key? key}) : super(key: key);

  @override
  ConsumerState<ErrorModuleListener> createState() => _ErrorModuleListenerState();
}

class _ErrorModuleListenerState extends ConsumerState<ErrorModuleListener> {
  @override
  Widget build(BuildContext context) {
    ref.listen<ErrorState>(errorProvider, (previous, current) {
      // 當有新錯誤且需要顯示彈窗時
      if (current.showErrorDialog && current.latestError != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(errorServiceProvider).showErrorDialog();
        });
      }
    });

    return const SizedBox.shrink();
  }
}