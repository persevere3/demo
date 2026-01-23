import 'package:flutter/material.dart';

/// 日期時間選擇工具集
///
/// 使用範例：
/// ```dart
/// // 選擇日期時間
/// final dt = await DateTimePickerUtils.pickDateTime(context);
///
/// // 快捷時間範圍
/// final today = DateTimePickerUtils.todayRange();
///
/// // 格式化顯示
/// Text(DateTimePickerUtils.format(DateTime.now()))
/// ```
class DateTimePickerUtils {
  DateTimePickerUtils._();

  // ==================== 格式化 ====================

  /// YYYY-MM-DD HH:mm
  static String format(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  /// YYYY-MM-DD
  static String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// HH:mm
  static String formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  // ==================== 選擇器 ====================

  /// 選擇日期+時間（連續彈出兩個對話框）
  static Future<DateTime?> pickDateTime(
      BuildContext context, {
        DateTime? initial,
      }) async {
    final initDt = initial ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initDt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      useRootNavigator: false,
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initDt),
      useRootNavigator: false,
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// 只選擇日期
  static Future<DateTime?> pickDate(
      BuildContext context, {
        DateTime? initial,
      }) async {
    return await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  /// 只選擇時間
  static Future<TimeOfDay?> pickTime(
      BuildContext context, {
        TimeOfDay? initial,
      }) async {
    return await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
  }

  // ==================== 快捷時間範圍 ====================

  /// 當天 00:00:00
  static DateTime startOfDay([DateTime? d]) {
    final date = d ?? DateTime.now();
    return DateTime(date.year, date.month, date.day);
  }

  /// 當天 23:59:59
  static DateTime endOfDay([DateTime? d]) {
    final date = d ?? DateTime.now();
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// 今天範圍（00:00 ~ 現在）
  static DateTimeRange todayRange() {
    final now = DateTime.now();
    return DateTimeRange(start: startOfDay(now), end: now);
  }

  /// 昨天範圍（昨天 00:00 ~ 23:59）
  static DateTimeRange yesterdayRange() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateTimeRange(
      start: startOfDay(yesterday),
      end: endOfDay(yesterday),
    );
  }

  /// 本週範圍（週一 00:00 ~ 現在）
  static DateTimeRange thisWeekRange() {
    final now = DateTime.now();
    final monday = startOfDay(now).subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(start: monday, end: now);
  }

  /// 上週範圍（上週一 00:00 ~ 上週日 23:59）
  static DateTimeRange lastWeekRange() {
    final now = DateTime.now();
    final thisMonday = startOfDay(now).subtract(Duration(days: now.weekday - 1));
    final lastSunday = thisMonday.subtract(const Duration(seconds: 1));
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    return DateTimeRange(start: lastMonday, end: lastSunday);
  }

  /// 本月範圍（1號 00:00 ~ 現在）
  static DateTimeRange thisMonthRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
  }

  /// 上月範圍（上月1號 00:00 ~ 上月最後一天 23:59）
  static DateTimeRange lastMonthRange() {
    final now = DateTime.now();
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
    return DateTimeRange(start: lastMonthStart, end: lastMonthEnd);
  }

  /// 最近N天（N天前 00:00 ~ 現在）
  static DateTimeRange lastNDaysRange(int days) {
    final now = DateTime.now();
    final start = startOfDay(now.subtract(Duration(days: days - 1)));
    return DateTimeRange(start: start, end: now);
  }
}

// ==================== 可選：快捷時間按鈕 Widget ====================

/// 快捷時間按鈕（可選）
///
/// 使用範例：
/// ```dart
/// QuickTimeButtons(
///   primaryColor: Colors.blue,
///   onRangeSelected: (range) {
///     setState(() {
///       startTime = range.start;
///       endTime = range.end;
///     });
///   },
/// )
/// ```
class QuickTimeButtons extends StatelessWidget {
  final Color primaryColor;
  final void Function(DateTimeRange range) onRangeSelected;
  final List<String>? labels; // null = 使用預設['今天','昨天','本週','上週']

  const QuickTimeButtons({
    super.key,
    required this.primaryColor,
    required this.onRangeSelected,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final quickRanges = {
      '今天': DateTimePickerUtils.todayRange,
      '昨天': DateTimePickerUtils.yesterdayRange,
      '本週': DateTimePickerUtils.thisWeekRange,
      '上週': DateTimePickerUtils.lastWeekRange,
    };

    final displayLabels = labels ?? quickRanges.keys.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: displayLabels.map((label) {
        return TextButton(
          onPressed: () {
            final range = quickRanges[label]?.call();
            if (range != null) onRangeSelected(range);
          },
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
          ),
          child: Text(
            label,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}