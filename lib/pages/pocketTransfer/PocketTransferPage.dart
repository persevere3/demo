import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../layout/DefaultLayout.dart';

import 'package:demo/providers/configProvider.dart';
import 'package:demo/providers/userProvider.dart';

class PocketTransferPage extends ConsumerStatefulWidget {
  const PocketTransferPage({super.key});
  @override
  ConsumerState<PocketTransferPage> createState() => _PocketTransferPageState();
}

class _PocketTransferPageState extends ConsumerState<PocketTransferPage> {
  bool _isMultiWallet = true;

  final List<String> _walletList = [
    '主錢包',
    '錢包 A',
    '錢包 B',
    '錢包 C',
    '錢包 D',
    '錢包 E',
  ];

  String _account = 'Jacob';

  String _fromWallet = '主錢包';
  String _toWallet = '錢包 A';

  double _totalMulti = 12345.67;
  double _totalSingle = 4567.89;

  // 輸入金額
  final TextEditingController _amountController = TextEditingController();
  String? _amountErrorText = null;

  // 刷新冷卻 (共用)
  bool _isRefreshing = false;
  int _refreshCountdown = 0;
  Timer? _refreshTimer;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  //
  void _changeWalletType(bool isMulti) {
    if(isMulti != _isMultiWallet) {
      String wallet = isMulti ? '多' : '單';
      String text = '请确认是否转换成$wallet钱包模式？';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context, false);
            }, child: Text('取消')),
            TextButton(onPressed: (){
              Navigator.pop(context, false);
              setState(() {
                _isMultiWallet = isMulti;
              });
            }, child: Text('確定'))
          ]
        ),
      );
    }
  }

  // 刷新總餘額
  void _refreshTotal() {
    setState(() {
      _isRefreshing = true;
      _refreshCountdown = 5;
    });

    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _refreshCountdown--;
        if (_refreshCountdown <= 0) {
          _isRefreshing = false;
          timer.cancel();
        }
      });
    });

    // TODO: 這裡放實際刷新邏輯，例如呼叫 API
    // _refreshBalance();
  }

  // 互換錢包
  void _swapWallets() {
    setState(() {
      final tmp = _fromWallet;
      _fromWallet = _toWallet;
      _toWallet = tmp;
    });
  }

  // 點擊 MAX
  void _setMaxAmount() {
    setState(() {
      _amountController.text = '1000';
      _amountErrorText = null;
    });
  }

  // 確定轉換
  void _confirmTransfer() {
    final text = _amountController.text;

    _amountErrorText = validateAmount(_amountController.text);
    setState(() {});

    if (_amountErrorText != null) return;

    debugPrint('Transfer ${text} from $_fromWallet to $_toWallet');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '已送出轉換 ${text}，從 $_fromWallet 轉到 $_toWallet',
        ),
      ),
    );
  }

  //
  String? validateAmount(String text) {
    if (text.isEmpty) return '請輸入金額';

    final value = double.tryParse(text);
    if (value == null) return '請輸入有效數字';
    if (value < 0) return '金額不能為負數';

    // 檢查小數位數
    if (text.contains('.') && text.split('.')[1].length > 2) {
      return '小數點後最多2位';
    }

    return null; // 通過驗證
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    return DefaultLayout(
        // title 可選，不傳則使用 config.appName
        title: '我的錢包',
        child: Column(
          children: [
            _buildTabs(primaryColor).mt(30),

            // 共用：帳號 + 總餘額 + 刷新
            _buildWalletHeader(
              accountLabel: _account,
              total: _isMultiWallet ? _totalMulti : _totalSingle,
              isRefreshing: _isRefreshing,
              refreshCountdown: _refreshCountdown,
              onRefresh: _isRefreshing ? null : _refreshTotal,
            ).mt(30),

            Expanded(
              child: _isMultiWallet ? _buildMultiWalletContent() : _buildSingleWalletContent(),
            ).mt(30),
          ],
        ).px(50),
    );
  }

  // 建立 標籤
  Widget _buildTabs(Color primaryColor) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          // 左上角：深色陰影（凹陷的陰暗面）
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            primaryColor: primaryColor,
            label: '多錢包模式',
            selected: _isMultiWallet,
            onTap: () {
              _changeWalletType(true);
            },
          ),
          _buildTab(
            primaryColor: primaryColor,
            label: '單錢包模式',
            selected: !_isMultiWallet,
            onTap: () {
              _changeWalletType(false);
            },
          ),
        ],
      ),
    );
  }
  Widget _buildTab({
    required Color primaryColor,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  // 建立 帳號 + 總餘額
  Widget _buildWalletHeader ({
    required String accountLabel,
    required double total,
    required bool isRefreshing,
    required int refreshCountdown,
    required VoidCallback? onRefresh,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // icon + 帳號
        Row(
          children: [
            const Icon(Icons.account_circle, size: 20),
            const SizedBox(width: 8),
            Text('帳號： ${accountLabel}', style: TextStyle(fontSize: 16)),
          ],
        ),

        // icon + 總餘額 + 刷新 icon
        Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '總餘額： ${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: onRefresh,
              child: Row(
                children: [
                  Icon(
                    isRefreshing ? Icons.hourglass_bottom : Icons.refresh,
                    size: 20,
                    color: onRefresh == null ? Colors.grey : Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isRefreshing ? '${refreshCountdown}s' : '刷新',
                    style: TextStyle(
                      fontSize: 16,
                      color: onRefresh == null ? Colors.grey : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).mt(20),
      ],
    );
  }

  // 建立 多錢包內容
  Widget _buildMultiWalletContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 從 x 錢包 下拉
          const Text('從錢包', style: TextStyle(fontSize: 16)),
          _buildWalletDropdown(
            value: _fromWallet,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _fromWallet = value;
              });
            },
          ).mt(5),

          // 轉到 y 錢包 下拉
          const Text('轉到錢包', style: TextStyle(fontSize: 16)).mt(20),
          _buildWalletDropdown(
            value: _toWallet,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _toWallet = value;
              });
            },
          ).mt(5),

          // 互換 button
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              onPressed: _swapWallets,
              icon: const Icon(Icons.swap_vert),
              label: const Text('互換'),
            ),
          ).mt(20),

          // icon + 輸入金額 + MAX
          Row(
            children: [
              const Icon(Icons.account_balance_wallet),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: '輸入金額',
                    errorText: _amountErrorText,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _setMaxAmount,
                child: const Text('MAX'),
              ),
            ],
          ).mt(20),

          Text('只允许输入小数点后2位数字，并且数值不能为负数').mt(5),

          // 確定轉換 button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmTransfer,
              child: const Text('確定轉換'),
            ),
          ).mt(30),
        ],
      ),
    );
  }

  // 建立 多錢包 > 錢包下拉
  Widget _buildWalletDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: _walletList.map((acc) {
          return DropdownMenuItem<String>(
            value: acc,
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, size: 20),
                const SizedBox(width: 8),
                Text(acc),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // 建立 單錢包內容
  Widget _buildSingleWalletContent() {
    // 單錢包頁面目前需求較少，就簡單展示即可
    return Column(
      children: [
        Text(
          '溫馨提示',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '您目前自动额度转换的状态，无需额度转换，可以直接进入游戏哦~',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}