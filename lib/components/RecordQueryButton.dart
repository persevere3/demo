import 'package:flutter/material.dart';
import '../extensions/widget.dart';

// 查詢條件：起始時間 + 結束時間 + 自訂參數
class RecordQuery<T> {
  final DateTime start;
  final DateTime end;
  final T? extra;

  const RecordQuery({required this.start, required this.end, this.extra});
}

// 時間快捷選項：標籤 + 動態生成時間範圍的函數
class TimePreset {
  final String label;
  final DateTimeRange Function(DateTime now) buildRange;
  const TimePreset(this.label, this.buildRange);
}

// 美觀的查詢按鈕，點擊彈出時間選擇對話框 + 快捷選項 + 自訂參數
///
/// 功能特色：
/// - 左右圖示 + 標題的 ElevatedButton 外觀
/// - 彈出對話框支援：日期時間選擇器 + 快捷按鈕（今天/昨日/本週等）
/// - 可自訂下方參數區域（例如：狀態下拉選單、金額範圍等）
/// - 回傳完整的 RecordQuery<T> 物件給外部處理
class RecordQueryButton<T> extends StatelessWidget {
  const RecordQueryButton({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onQuery,
    this.radius = 5,
    this.height = 50,
    this.horizontalPadding = 50,
    this.topMargin = 20,
    this.trailingWidth = 50,
    this.trailingIcon = Icons.search,
    this.trailingBackground = Colors.white,
    this.leadingIconSize = 40,
    this.trailingIconSize = 35,
    this.presets,
    this.extraBuilder,
    this.initialRange,

    required this.primaryColor
  });

  /// 按鈕顯示文字
  final String title;

  /// 左側圖示
  final IconData leadingIcon;

  /// 查詢回調：接收完整的 RecordQuery<T> 物件
  final void Function(RecordQuery<T> query) onQuery;

  // === 按鈕外觀配置 ===
  final double radius;              // 圓角半徑
  final double height;              // 按鈕高度
  final double horizontalPadding;   // 左右外邊距
  final double topMargin;           // 上方外邊距

  // === 右側圖示配置 ===
  final double trailingWidth;       // 右側圖示區寬度
  final IconData trailingIcon;      // 右側圖示
  final Color trailingBackground;   // 右側圖示背景色

  // === 圖示尺寸 ===
  final double leadingIconSize;
  final double trailingIconSize;

  // === 對話框功能配置 ===
  final List<TimePreset>? presets;                          // 自訂快捷選項
  final Widget Function(BuildContext, ValueNotifier<T?>)?
  extraBuilder;                                         // 自訂參數區域
  final DateTimeRange? initialRange;                         // 初始時間範圍

  //
  final Color primaryColor;

  /// 當天 00:00:00
  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  /// 本週一 00:00:00
  DateTime _startOfWeekMonday(DateTime d) =>
      _startOfDay(d).subtract(Duration(days: d.weekday - 1));

  /// 格式化顯示：YYYY-MM-DD HH:MM
  static String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}';

  /// 日期+時間選擇器
  Future<DateTime?> _pickDateTime(BuildContext context, DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// 預設快捷選項
  List<TimePreset> _defaultPresets() => [
    TimePreset('今天', (now) => DateTimeRange(
      start: _startOfDay(now),
      end: now,
    )),
    TimePreset('昨天', (now) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTimeRange(
        start: _startOfDay(yesterday),
        end: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
      );
    }),
    TimePreset('本週', (now) => DateTimeRange(
      start: _startOfWeekMonday(now),
      end: now,
    )),
    TimePreset('上週', (now) {
      final thisWeekStart = _startOfWeekMonday(now);
      return DateTimeRange(
        start: thisWeekStart.subtract(const Duration(days: 7)),
        end: thisWeekStart.subtract(const Duration(seconds: 1)),
      );
    }),
  ];

  /// 顯示時間選擇對話框
  Future<void> _showQueryDialog(BuildContext context) async {
    final now = DateTime.now();
    final initRange = initialRange ?? DateTimeRange(
      start: _startOfDay(now),
      end: now,
    );

    var start = initRange.start;
    var end = initRange.end;
    final extraNotifier = ValueNotifier<T?>(null);
    final presetsList = presets ?? _defaultPresets();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 420,
          child: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // === 開始時間 ===
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: const Text('開始時間'),
                  subtitle: Text(_format(start)),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: () async {
                    final picked = await _pickDateTime(dialogContext, start);
                    if (picked == null) return;
                    setDialogState(() {
                      start = picked;
                      if (end.isBefore(start)) end = start;
                    });
                  },
                ).py(4),

                // === 結束時間 ===
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: const Text('結束時間'),
                  subtitle: Text(_format(end)),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: () async {
                    final picked = await _pickDateTime(dialogContext, end);
                    if (picked == null) return;
                    setDialogState(() {
                      end = picked;
                      if (end.isBefore(start)) start = end;
                    });
                  },
                ).py(4),

                // === 快捷選項 ===
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final preset in presetsList)
                        ActionChip(
                          label: Text(preset.label),
                          onPressed: () {
                            final range = preset.buildRange(DateTime.now());
                            setDialogState(() {
                              start = range.start;
                              end = range.end;
                            });
                          },
                        ),
                    ],
                  ),
                ).py(10),

                // === 自訂參數區域 ===
                if (extraBuilder != null) extraBuilder!(dialogContext, extraNotifier),
              ],
            ),
          ),
        ),
        actions: [
          // 取消按鈕
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ).px(8),

          // 查詢按鈕
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onQuery(RecordQuery<T>(
                start: start,
                end: end,
                extra: extraNotifier.value,
              ));
            },
            child: const Text('查詢'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(top: topMargin),
      child: ElevatedButton(
        onPressed: () => _showQueryDialog(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: br),
          padding: EdgeInsets.zero,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        child: Row(
          children: [
            // 左側圖示
            Icon(leadingIcon, size: leadingIconSize).pl(20).pr(10).py(0),

            // 標題文字
            Text(title, style: const TextStyle(fontSize: 16)),

            // 彈性填充
            const Spacer(),

            // 右側圖示區塊（獨立背景色）
            Container(
              width: trailingWidth,
              height: height,
              decoration: BoxDecoration(
                color: trailingBackground,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                ),
              ),
              child: Icon(trailingIcon, size: trailingIconSize, color: primaryColor).center(),
            ),
          ],
        ).h(height),
      ),
    );
  }
}