import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/error_providers.dart';
import '../services/error_service.dart';
import '../models/error_model.dart';

/// 錯誤彈窗
class ErrorDialog extends ConsumerWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorState = ref.watch(errorProvider);
    final errorService = ref.read(errorServiceProvider);
    final latestError = errorState.latestError;

    if (latestError == null) {
      Navigator.of(context).pop();
      return const SizedBox.shrink();
    }

    return AlertDialog(
      title: Row(
        children: [
          _getErrorIcon(latestError.severity),
          const SizedBox(width: 8),
          Expanded(child: Text(latestError.title)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(latestError.message),
            if (latestError.details != null) ...[
              const SizedBox(height: 16),
              const Text(
                '詳細資訊:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                latestError.details!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              '錯誤類型: ${_getErrorTypeText(latestError.type)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            errorService.showErrorHistory();
          },
          child: const Text('查看歷史'),
        ),
        if (!latestError.isReported)
          TextButton(
            onPressed: () async {
              await errorService.reportError(latestError.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('錯誤已回報')),
                );
              }
            },
            child: const Text('回報問題'),
          ),
        TextButton(
          onPressed: () {
            ref.read(errorProvider.notifier).dismissErrorDialog();
            Navigator.of(context).pop();
          },
          child: const Text('確定'),
        ),
      ],
    );
  }

  Widget _getErrorIcon(ErrorSeverity severity) {
    IconData icon;
    Color color;

    switch (severity) {
      case ErrorSeverity.info:
        icon = Icons.info_outline;
        color = Colors.blue;
        break;
      case ErrorSeverity.warning:
        icon = Icons.warning_amber;
        color = Colors.orange;
        break;
      case ErrorSeverity.error:
        icon = Icons.error_outline;
        color = Colors.red;
        break;
      case ErrorSeverity.fatal:
        icon = Icons.dangerous;
        color = Colors.red[900]!;
        break;
    }

    return Icon(icon, color: color);
  }

  String _getErrorTypeText(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return '網路錯誤';
      case ErrorType.business:
        return '業務錯誤';
      case ErrorType.system:
        return '系統錯誤';
      case ErrorType.permission:
        return '權限錯誤';
      case ErrorType.validation:
        return '驗證錯誤';
      case ErrorType.unknown:
        return '未知錯誤';
    }
  }
}

/// 錯誤歷史彈窗
class ErrorHistoryDialog extends ConsumerWidget {
  const ErrorHistoryDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorState = ref.watch(errorProvider);
    final errorService = ref.read(errorServiceProvider);

    return AlertDialog(
      title: Text('錯誤記錄 (${errorState.errors.length})'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: errorState.errors.isEmpty
            ? const Center(child: Text('目前沒有錯誤記錄'))
            : ListView.separated(
          itemCount: errorState.errors.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final error = errorState.errors[index];
            return ListTile(
              leading: _getSeverityIcon(error.severity),
              title: Text(error.title),
              subtitle: Text(
                '${error.message}\n${_formatTime(error.timestamp)}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  ref.read(errorProvider.notifier).deleteError(error.id);
                },
              ),
              onTap: () => _showErrorDetail(context, error),
            );
          },
        ),
      ),
      actions: [
        if (errorState.errors.isNotEmpty)
          TextButton(
            onPressed: () {
              // ✅ 先清空數據
              errorService.clearErrors();
              // ✅ 然後關閉對話框
              Navigator.of(context).pop();
            },
            child: const Text('清空全部'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('關閉'),
        ),
      ],
    );
  }

  Widget _getSeverityIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return const Icon(Icons.info_outline, color: Colors.blue);
      case ErrorSeverity.warning:
        return const Icon(Icons.warning_amber, color: Colors.orange);
      case ErrorSeverity.error:
        return const Icon(Icons.error_outline, color: Colors.red);
      case ErrorSeverity.fatal:
        return const Icon(Icons.dangerous, color: Colors.red);
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return '剛剛';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 分鐘前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 小時前';
    } else {
      return '${difference.inDays} 天前';
    }
  }

  void _showErrorDetail(BuildContext context, ErrorModel error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(error.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('訊息: ${error.message}'),
              if (error.details != null) ...[
                const SizedBox(height: 8),
                Text('詳情: ${error.details}'),
              ],
              const SizedBox(height: 8),
              Text('類型: ${error.type}'),
              Text('嚴重程度: ${error.severity}'),
              Text('時間: ${error.timestamp}'),
              Text('已上報: ${error.isReported ? "是" : "否"}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }
}