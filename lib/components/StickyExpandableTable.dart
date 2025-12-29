import 'package:flutter/material.dart';
import '../extensions/widget.dart';

// ==================== 数据模型 ====================

/// 表格列定义：标题 + flex 权重 + 对齐方式
class StickyTableColumn {
  final String title;
  final int flex;
  final TextAlign align;

  const StickyTableColumn({
    required this.title,
    this.flex = 1,
    this.align = TextAlign.left,
  });
}

/// 展开详情项：标题 + 值
class DetailItem {
  final String title;
  final String value;

  const DetailItem({required this.title, required this.value});
}

/// 可展开行数据：主列单元格 + 展开详情列表
class StickyExpandableRow {
  final List<Widget> cells;
  final List<DetailItem> details;

  const StickyExpandableRow({
    required this.cells,
    this.details = const [],
  });
}

// ==================== 主组件 ====================

/// 固定表头 + 可展开行 + 网格线表格组件
///
/// 特性：
/// - 表头固定在顶部（滚动时不消失）
/// - 支持行展开/收起，显示详细信息
/// - 完整的网格线边框
/// - 支持单行/多行展开模式
class StickyExpandableTable extends StatefulWidget {
  const StickyExpandableTable({
    super.key,
    required this.columns,
    required this.rows,
    this.headerHeight = 40,
    this.rowHeight = 50,
    this.headerBackground,
    this.headerTextStyle,
    this.rowBackground,
    this.gridColor,
    this.gridWidth = 1,
    this.trailingWidth = 15,
    this.showTrailingArrow = true,
    this.singleExpanded = true,
    this.initialExpandedIndex,
    this.detailTitleWidth = 90,
    this.detailRowSpacing = 8,
    this.detailColSpacing = 16,
    this.detailPadding = const EdgeInsets.fromLTRB(12, 10, 12, 10),
    this.onRowTap,
  });

  final List<StickyTableColumn> columns;
  final List<StickyExpandableRow> rows;

  // 样式配置
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackground;
  final TextStyle? headerTextStyle;
  final Color? rowBackground;
  final Color? gridColor;
  final double gridWidth;

  // 展开箭头配置
  final double trailingWidth;
  final bool showTrailingArrow;

  // 展开行为配置
  final bool singleExpanded; // true: 同时只能展开一行
  final int? initialExpandedIndex;

  // 展开详情样式配置
  final double detailTitleWidth;
  final double detailRowSpacing;
  final double detailColSpacing;
  final EdgeInsets detailPadding;

  // 回调
  final void Function(int index, StickyExpandableRow row)? onRowTap;

  @override
  State<StickyExpandableTable> createState() => _StickyExpandableTableState();
}

class _StickyExpandableTableState extends State<StickyExpandableTable> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _expandedIndex = widget.initialExpandedIndex;
  }

  @override
  void didUpdateWidget(covariant StickyExpandableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 数据更新后，确保展开索引不越界
    if (_expandedIndex != null && _expandedIndex! >= widget.rows.length) {
      _expandedIndex = null;
    }
  }

  /// 切换行展开状态
  void _toggleRow(int index) {
    setState(() {
      final isCurrentlyExpanded = _expandedIndex == index;
      _expandedIndex = widget.singleExpanded
          ? (isCurrentlyExpanded ? null : index) // 单行模式：展开/收起切换
          : (isCurrentlyExpanded ? null : index); // 多行模式需改用 Set<int>
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerBg = widget.headerBackground ?? theme.colorScheme.surface;
    final rowBg = widget.rowBackground ?? theme.colorScheme.surface;
    final gridSide = BorderSide(
      color: widget.gridColor ?? theme.dividerColor,
      width: widget.gridWidth,
    );
    final headerStyle = widget.headerTextStyle ??
        (theme.textTheme.titleSmall ?? const TextStyle());

    return CustomScrollView(
      slivers: [
        // 固定表头（使用 pinned 保持在顶部）
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(
            height: widget.headerHeight,
            child: Material(
              elevation: 0, // 陰影
              color: headerBg,
              child: _buildHeaderRow(gridSide, headerStyle)
                  .h(widget.headerHeight),
            ),
          ),
        ),

        // 数据行列表
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) => _buildDataRow(context, index, rowBg, gridSide),
            childCount: widget.rows.length,
          ),
        ),
      ],
    );
  }

  /// 构建 header
  Widget _buildHeaderRow(BorderSide gridSide, TextStyle headerStyle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 第一列：箭头占位 + 内容
        Expanded(
          flex: widget.columns[0].flex,
          child: _GridCell(
            side: gridSide,
            drawLeft: true,      // 第一列畫左邊框
            drawRight: true,
            drawTop: true,
            drawBottom: true,
            alignment: _alignFromTextAlign(widget.columns[0].align),
            child: Row(           // 第一列內部用 Row 放箭头占位
              children: [
                // 箭头占位（和数据行對齊）
                if (widget.showTrailingArrow)
                  SizedBox(width: widget.trailingWidth),
                // 实际文字內容
                Expanded(
                  child: Text(
                    widget.columns[0].title,
                    textAlign: widget.columns[0].align,
                    overflow: TextOverflow.ellipsis,
                    style: headerStyle,
                  ).px(8),
                ),
              ],
            ),
          ),
        ),

        // 其他列（從第二列開始）
        ...List.generate(widget.columns.length - 1, (i) {
          final colIndex = i + 1;  // 實際列索引
          final col = widget.columns[colIndex];
          return Expanded(
            flex: col.flex,
            child: _GridCell(
              side: gridSide,
              drawLeft: false,
              drawRight: true,
              drawTop: true,
              drawBottom: true,
              alignment: _alignFromTextAlign(col.align),
              child: Text(
                col.title,
                textAlign: col.align,
                overflow: TextOverflow.ellipsis,
                style: headerStyle,
              ).px(8),
            ),
          );
        }),
      ],
    );
  }

  /// 构建 row（包含展开内容）
  Widget _buildDataRow(
      BuildContext context,
      int index,
      Color rowBg,
      BorderSide gridSide,
  ) {
    final row = widget.rows[index];
    assert(row.cells.length == widget.columns.length, '单元格数量必须与列数一致');

    final isExpanded = _expandedIndex == index;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 主行（可点击）
        _buildMainRow(index, row, rowBg, gridSide, isExpanded),

        // 展开详情（带动画）
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildDetailSection(row, gridSide),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  /// 构建 row (表格主要內容)
  Widget _buildMainRow(
      int index,
      StickyExpandableRow row,
      Color rowBg,
      BorderSide gridSide,
      bool isExpanded,
      ) {
    return InkWell(
      onTap: () {
        widget.onRowTap?.call(index, row);
        _toggleRow(index);
      },
      child: Container(
        color: rowBg,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 第一列：箭头 + 内容
            Expanded(
              flex: widget.columns[0].flex,
              child: _GridCell(
                side: gridSide,
                drawLeft: true,
                drawRight: true,
                drawTop: false,
                drawBottom: !isExpanded,
                alignment: _alignFromTextAlign(widget.columns[0].align),
                child: Row(
                  children: [
                    // 實際箭头圖示
                    if (widget.showTrailingArrow)
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 18,
                        color: Theme.of(context).hintColor,
                      ).w(widget.trailingWidth),

                    // 第一列內容
                    Expanded(child: row.cells[0].px(8)),
                  ],
                ),
              ),
            ),

            // 其他列內容
            ...List.generate(widget.columns.length - 1, (i) {
              final colIndex = i + 1;
              return Expanded(
                flex: widget.columns[colIndex].flex,
                child: _GridCell(
                  side: gridSide,
                  drawLeft: false,
                  drawRight: true,
                  drawTop: false,
                  drawBottom: !isExpanded,
                  alignment: _alignFromTextAlign(widget.columns[colIndex].align),
                  child: row.cells[colIndex].px(8),
                ),
              );
            }),
          ],
        ).h(widget.rowHeight),
      ),
    );
  }

  /// 构建 row (展开的详情区域)
  Widget _buildDetailSection(StickyExpandableRow row, BorderSide gridSide) {
    if (row.details.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: gridSide,
          right: gridSide,
          top: gridSide, // 与主行分隔线
          bottom: gridSide, // 表格底边框
        ),
      ),
      padding: widget.detailPadding,
      child: _DetailGrid(
        details: row.details,
        titleWidth: widget.detailTitleWidth,
        rowSpacing: widget.detailRowSpacing,
        colSpacing: widget.detailColSpacing,
      ),
    );
  }

  /// TextAlign 转 Alignment
  static Alignment _alignFromTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}

// ==================== 辅助组件 ====================

/// 网格单元格（负责绘制边框的四条边）
/// 通过控制每条边的显示/隐藏，实现完整的表格边框效果
class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.child,
    required this.side,
    required this.drawLeft,
    required this.drawRight,
    required this.drawTop,
    required this.drawBottom,
    required this.alignment,
  });

  final Widget child;
  final BorderSide side;
  final bool drawLeft;
  final bool drawRight;
  final bool drawTop;
  final bool drawBottom;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border(
          left: drawLeft ? side : BorderSide.none,
          right: drawRight ? side : BorderSide.none,
          top: drawTop ? side : BorderSide.none,
          bottom: drawBottom ? side : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}

/// 详情网格（四列布局：标题-值 标题-值）
/// 自动处理奇数项，最后一行只显示一对
class _DetailGrid extends StatelessWidget {
  const _DetailGrid({
    required this.details,
    required this.titleWidth,
    required this.rowSpacing,
    required this.colSpacing,
  });

  final List<DetailItem> details;
  final double titleWidth;
  final double rowSpacing;
  final double colSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 每次处理两个 DetailItem（一行）
        for (int i = 0; i < details.length; i += 2) ...[
          Row(
            children: [
              // 左侧：第 i 个详情项
              _buildDetailPair(theme, details[i]).flex(),

              SizedBox(width: colSpacing),

              // 右侧：第 i+1 个详情项（如果存在）
              (i + 1 < details.length
                  ? _buildDetailPair(theme, details[i + 1])
                  : const SizedBox.shrink()
              ).flex(),
            ],
          ),

          // 行间距（最后一行不加）
          if (i + 2 < details.length) SizedBox(height: rowSpacing),
        ],
      ],
    );
  }

  /// 构建单个详情对（标题 + 值）
  Widget _buildDetailPair(ThemeData theme, DetailItem item) {
    return Row(
      children: [
        // 标题（固定宽度）
        Text(
          item.title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
          overflow: TextOverflow.ellipsis,
        ).w(titleWidth),

        const SizedBox(width: 8),

        // 值（自适应宽度）
        Text(
          item.value,
          style: theme.textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ).flex(),
      ],
    );
  }
}

/// 固定表头代理（用于 SliverPersistentHeader）
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) => child;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) =>
      height != oldDelegate.height || child != oldDelegate.child;
}