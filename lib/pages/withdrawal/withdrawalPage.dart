import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';

import '../../../layout/DefaultLayout.dart';
import '../../components/Drawer.dart';
import '../../utils/datetime_picker_utils.dart';

// 錢包
class OnlineWallet {
  // final String id;                                   // 錢包唯一識別
  final String name;                                  // 錢包名稱（顯示用）
  final String icon;                                  // 錢包 icon（可選，或用 IconData）
  final bool isRecommended;                           // 是否推薦
  final int type;                                     // 1 VIP 2 錢能 3 虛擬幣
  final String currency;                              // 幣種

  List<VIPMerchant>? merchantOptions;   // 商號選擇列表
  VIPMerchant? selectedMerchant;       // 選中的商號

  OnlineWallet({
    // required this.id,
    required this.name,
    this.icon = '',
    this.isRecommended = false,
    required this.type,
    required this.currency,

    this.merchantOptions,
    this.selectedMerchant,
  });
}

// 商戶
class VIPMerchant {
  final String name;                        // 商號名稱
  final String paymentTypeWalletText;       // 收付款方式 錢包 顯示文字
  final String? paymentTypeHint;            // 收付款方式 提示
  final bool? showsManagePayments;          // 是否顯示 管理綁定支付方式
  final double minAmount;                   // 最小存款額度
  final double maxAmount;                   // 最大存款額度
  final String? enterWalletText;            // 進入錢包 顯示文字 (顯示錢包餘額)
  final bool? requiresPaymentPassword;    // 是否需要 支付密碼
  final bool? requiresSmsVerification;    // 是否需要 短信驗證
  final String? paymentHint;                // 存款提示

  VIPMerchant({
    required this.name,
    required this.paymentTypeWalletText,
    this.paymentTypeHint,
    this.showsManagePayments,
    required this.minAmount,
    required this.maxAmount,
    this.enterWalletText,
    this.requiresPaymentPassword,
    this.requiresSmsVerification,
    this.paymentHint
  });
}

class WithdrawalPage extends ConsumerStatefulWidget {
  const WithdrawalPage({super.key});
  @override
  ConsumerState<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends ConsumerState<WithdrawalPage> with TickerProviderStateMixin {
  late BuildContext _outerContext;

  // 公告
  final String _anouncement = '暫無公告!';
  void _showAnnoucement() {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text('公告', style: TextStyle(color: primaryColor)).center(),
          content: Text(_anouncement),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('關閉')
            ),
          ]
      ),
    );
  }

  final List<OnlineWallet> onlineWallets = [
    OnlineWallet(
      name: 'VIP錢包',
      type: 1,
      currency: 'CNY',
      merchantOptions: [
        VIPMerchant(
          name: '錢能快速錢包',
          paymentTypeWalletText: '錢能快速充值',
          minAmount: 10,
          maxAmount: 50000,
          enterWalletText: '进入钱能钱包',
          paymentHint: '笔笔存取，笔笔送，最高送8%'
        ),
        VIPMerchant(
          name: '購寶快速錢包',
          paymentTypeWalletText: '購寶快速錢包',
          paymentTypeHint: '点击"绑定"即完成注册>下载购宝钱包完成相关验证>扫码绑定钱包>首次存款或取款需短信验证授权',
          minAmount: 10,
          maxAmount: 50000,
          paymentHint: '笔笔存取，笔笔送，最高送8%'
        ),
      ]
    ),
    OnlineWallet(
        name: '錢能錢包',
        type: 2,
        currency: 'CNY'
    ),
    OnlineWallet(
        name: '虛擬幣/USDT',
        type: 3,
        currency: '虛擬幣'
    ),
  ];
  OnlineWallet? selectedOnlineWallet;

  // 帳號
  final String _account = 'Jacob';

  // type 1 ===== ===== ===== ===== =====
  // 金額
  final TextEditingController _amountController = TextEditingController();
  String? _amountErrorText;

  // 密碼
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordErrorText;


  // 開啟訂單查詢
  void _showOrderQueryDrawer(BuildContext context, Color primaryColor) {
    showSlideDrawer(
      context: context,
      config: SlideDrawerConfig(
        direction: SlideDirection.fromRight,
        primaryColor: primaryColor,
        title: '訂單查詢', // ✅ 設定表頭標題
        width: MediaQuery.of(context).size.width,
      ),
      child: Container(
        color: const Color(0xFFDFDFDF),
        padding: const EdgeInsets.all(20),
        child: OrderQueryDrawerContent(context, primaryColor),
      ),
    );
  }
  Widget OrderQueryDrawerContent(BuildContext context, Color primaryColor) {
    return Container(
        color: '#dfdfdf'.toColor(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor.darken(0.2),
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 圓角半徑
                      ),
                    ),
                    onPressed: () {

                    },
                    child: Text('查詢', style: TextStyle(color: primaryColor))
                ).h(45).flex(),
                TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor.darken(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 圓角半徑
                      ),
                    ),
                    onPressed: () {
                      _showOrderFilterDrawer(context, primaryColor);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('篩選', style: TextStyle(color: primaryColor)).mr(5),
                        Icon(Icons.filter_alt_outlined)
                      ],
                    )
                ).w(90).h(45).ml(20),
              ],
            )
          ],
        )
    ).flex();
  }
  // 開啟篩選
  void _showOrderFilterDrawer(BuildContext context, Color primaryColor) {
    showSlideDrawer(
      context: context,
      config: SlideDrawerConfig(
        direction: SlideDirection.fromBottom,
        primaryColor: primaryColor,
        title: '訂單篩選', // ✅ 設定表頭標題
        height: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Container(
        color: const Color(0xFFDFDFDF),
        padding: const EdgeInsets.all(20),
        child: OrderFilterDrawerContent(context, primaryColor),
      ),
    );
  }

  DateTime _orderFilterStart = DateTimePickerUtils.startOfDay();
  DateTime _orderFilterEnd = DateTime.now();
  String? selectedValue;
  final List<String> items = ['選項1', '選項2', '選項3'];

  Widget OrderFilterDrawerContent(BuildContext context, Color primaryColor) {
    return StatefulBuilder(  // ✅ 用 StatefulBuilder 包起來
      builder: (context, setFilterState) {
        return Container(
          color: '#ffffff'.toColor(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 開始時間
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('開始時間'),
                  subtitle: Text(DateTimePickerUtils.format(_orderFilterStart)),
                  trailing: Icon(Icons.edit_calendar),
                  onTap: () async {
                    final picked = await DateTimePickerUtils.pickDateTime(
                      context,
                      initial: _orderFilterStart,
                    );
                    if (picked != null) {
                      setFilterState(() {  // ✅ 用 setFilterState 更新 UI
                        _orderFilterStart = picked;
                        if (_orderFilterEnd.isBefore(_orderFilterStart)) {
                          _orderFilterEnd = _orderFilterStart;
                        }
                      });
                    }
                  },
                ),
              ),

              // 結束時間
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text('結束時間'),
                  subtitle: Text(DateTimePickerUtils.format(_orderFilterEnd)),
                  trailing: Icon(Icons.edit_calendar),
                  onTap: () async {
                    final picked = await DateTimePickerUtils.pickDateTime(
                      context,
                      initial: _orderFilterEnd,
                    );
                    if (picked != null) {
                      setFilterState(() {
                        _orderFilterEnd = picked;
                        if (_orderFilterEnd.isBefore(_orderFilterStart)) {
                          _orderFilterStart = _orderFilterEnd;
                        }
                      });
                    }
                  },
                ),
              ).mt(10),

              // 下拉
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  value: selectedValue,
                  hint: Text('請選擇'),
                  isExpanded: true,  // ✅ 撐滿寬度
                  underline: SizedBox.shrink(),  // ✅ 移除底線
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(item),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedValue = value);
                  },
                ),
              ).mt(10),

              // 底部按鈕
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          topRight: Radius.zero,
                          bottomRight: Radius.zero,
                        )
                        ),
                        backgroundColor: '#dfdfdf'.toColor(),
                        foregroundColor: '#000000'.toColor(),
                      ),
                      child: Text('重置', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // 執行篩選邏輯
                        print('篩選: ${DateTimePickerUtils.format(_orderFilterStart)} ~ ${DateTimePickerUtils.format(_orderFilterEnd)}');
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.only(
                          topLeft: Radius.zero,
                          bottomLeft: Radius.zero,
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        ),
                        backgroundColor: primaryColor,
                        foregroundColor: '#ffffff'.toColor(),
                      ),
                      child: Text('確定', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ).px(20).my(20),
            ],
          ).p(20),
        ).flex();
      },
    );
  }

  String? validateAmount(String text) {
    if (text.isEmpty) return '請輸入金額';

    final value = double.tryParse(text);
    if (value == null) return '請輸入有效數字';
    if (value < 0) return '金額不能為負數';

    // // 檢查 區間
    // final wallet = selectedOnlineWallet;
    // if(wallet == null) return null;
    // final merchant = wallet.selectedMerchant;
    // if(merchant == null) return null;
    // if (value < merchant.minAmount ||
    //     value > merchant.maxAmount
    // ) {
    //   return '存款额度须在 ${selectedOnlineWallet?.selectedMerchant?.minAmount} - ${selectedOnlineWallet?.selectedMerchant?.maxAmount} 之間';
    // }

    return null; // 通過驗證
  }

  // type 2 ===== ===== ===== ===== =====


  // type 3 ===== ===== ===== ===== =====


  // 提交
  void _submit() {
    // final VIPAmountText = _VIPAmountController.text;
    //
    // setState(() {
    //   _VIPAmountErrorText = validateAmount(VIPAmountText);
    // });
    //
    // if (_VIPAmountErrorText != null) return;
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Row(
    //       children: [
    //         Text('提交 金額: $VIPAmountText').mr(10),
    //       ],
    //     ),
    //   ),
    // );
  }

  // override =============================================

  @override
  void initState() {
    super.initState();

    // api 取得 onlineWallets
  }

  @override
  void dispose() {
    _amountController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    _outerContext = context; // ✅ 儲存

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '我要取款',
      child: Column(
        children: [
          _buildAnnouncement(),

          const Divider(height: 1),

          _handleContent(primaryColor).flex(),
        ],
      ),
    );
  }

  // 建立 公告 =============================================
  Widget _buildAnnouncement() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _showAnnoucement();
        },
        child: Row(
            children: [
              Text('公告', style: TextStyle(fontSize: 16),).ml(10),
            ]
        ).py(10)
    );
  }

  // 建立 內容 =============================================
  Widget _handleContent(Color primaryColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 錢包 列表
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,            // 不滾動時使用
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3,       // 調整按鈕寬高比
            children: List.generate(onlineWallets.length, (walletIndex) {
              return ElevatedButton(
                style:  ElevatedButton.styleFrom(
                  backgroundColor: onlineWallets[walletIndex] == selectedOnlineWallet ? primaryColor.lighten(0.4) : Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 圓角
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedOnlineWallet = onlineWallets[walletIndex];

                    final wallet = selectedOnlineWallet;
                    if (wallet == null) return;
                    if (wallet.type == 1) {
                      wallet.selectedMerchant = wallet.merchantOptions?[0];
                    }
                  });
                },
                child: Text(onlineWallets[walletIndex].name),
              );
            }),
          ),

          // 帳號 + 幣種 + 錢包餘額 + 可取額度/產品額度
          Text('帳號: $_account').mt(20),
          Text('幣種: ${selectedOnlineWallet?.currency}'),
          Text('錢包餘額: 總餘額 ').mt(10),
          RichText(
            text: TextSpan(
              // 默認樣式
              style: TextStyle(color: '#3aafe2'.toColor()),
              children: <TextSpan>[
                TextSpan(
                  text: '(可取額度 ',
                ),
                TextSpan(
                  text: '0 ',
                  style: TextStyle(color: '#fc7f03'.toColor()),
                ),
                TextSpan(
                  text: '/產品額度 ',
                ),
                TextSpan(
                  text: '0 ',
                  style: TextStyle(color: '#fc7f03'.toColor()),
                ),
                TextSpan(
                  text: ')',
                ),
              ],
            ),
          ),

          if( selectedOnlineWallet?.type == 1)
            Column(
              children: [
                // 選擇商戶
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                        ),
                        child: Text('請選擇商戶', style: TextStyle(color: Colors.white))
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,            // 不滾動時使用
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 4,       // 調整按鈕寬高比
                          children: List.generate(selectedOnlineWallet!.merchantOptions!.length, (index) {
                            return ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // 圓角
                                ),
                                side: BorderSide(
                                    color: selectedOnlineWallet!.merchantOptions![index] == selectedOnlineWallet!.selectedMerchant ? primaryColor : '#aaaaaa'.toColor(),
                                    width: 1
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: selectedOnlineWallet!.merchantOptions![index] == selectedOnlineWallet!.selectedMerchant ? primaryColor : '#777777'.toColor(),// border
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedOnlineWallet!.selectedMerchant = selectedOnlineWallet!.merchantOptions![index];
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wallet_giftcard).mr(5),
                                  Text(selectedOnlineWallet!.merchantOptions?[index].name ?? '')
                                ],
                              ),
                            );
                          }),
                        )
                    ),
                  ],
                ).mt(20),

                // 選擇收付款方式
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                        ),
                        child: Row(
                          children: [
                            Text('請選擇收付款方式', style: TextStyle(color: Colors.white)).flex(),
                            InkWell(
                                onTap: () {
                                  _showOrderQueryDrawer(context, primaryColor);
                                },
                                child: Text(
                                    '訂單查詢',
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                    )
                                )
                            )
                          ],
                        )
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(selectedOnlineWallet!.selectedMerchant?.paymentTypeHint != null)
                              Text(
                                '請先綁定付款方式',
                                style: TextStyle(color: Colors.red),
                              ).mb(10),
                            GestureDetector(
                              onTap: () {

                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: '#aaaaaa'.toColor())
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.phone, color: Colors.green).ml(10).mr(20),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(selectedOnlineWallet!.selectedMerchant?.paymentTypeWalletText != null)
                                            Row(
                                              children: [
                                                Icon(Icons.wallet_giftcard),
                                                Text(
                                                  selectedOnlineWallet!.selectedMerchant!.paymentTypeWalletText,
                                                ),
                                              ],
                                            ),
                                          Text(
                                            '請先綁定支付方式',
                                            style: TextStyle(color: '#aaaaaa'.toColor()),
                                          ),
                                        ],
                                      ).flex(),
                                      Radio<int>(
                                        value: 1,
                                        activeColor: primaryColor, // 勾選時顏色
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 點擊範圍縮小
                                      ),
                                    ],
                                  )
                              ),
                            ),

                            // 收付款方式提示
                            if(selectedOnlineWallet!.selectedMerchant?.paymentTypeHint != null)
                              Text(
                                selectedOnlineWallet!.selectedMerchant!.paymentTypeHint!,
                                style: TextStyle(color: Colors.red),
                              ),

                            // 管理綁定支付方式
                            if(selectedOnlineWallet!.selectedMerchant?.showsManagePayments ?? false)
                              InkWell(
                                onTap: () {

                                },
                                child: Text('管理綁定支付方式').alignCenterRight(),
                              ),
                          ],
                        )
                    ),
                  ],
                ).mt(20),

                // 輸入存款金額
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))
                        ),
                        child: Row(
                          children: [
                            Text('請輸入取款金額', style: TextStyle(color: Colors.white)).flex(),
                            Text(
                                '取款額度需在 ${selectedOnlineWallet!.selectedMerchant?.minAmount} - ${selectedOnlineWallet!.selectedMerchant?.maxAmount} 之間',
                                style: TextStyle(color: Colors.white)
                            )
                          ],
                        )
                    ),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('*', style: TextStyle(color: Colors.red)),
                                Text('金額').mr(20),
                                TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,

                                  textAlignVertical: TextAlignVertical.center,  // 關鍵設定

                                  decoration: InputDecoration(
                                    labelText: '請輸入金額',
                                    errorText: _amountErrorText,
                                    contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距
                                    border: const OutlineInputBorder(),
                                  ),
                                ).flex(),
                              ],
                            ),

                            // 錢包餘額
                            if(selectedOnlineWallet!.selectedMerchant?.enterWalletText != null)
                            Row(
                              children: [
                                Text('錢包餘額').mr(20),

                                Text('0   ${selectedOnlineWallet!.currency}', style: TextStyle(color: '#fc7f03'.toColor(), fontSize: 16, fontWeight: FontWeight.bold)).flex(),

                                InkWell(
                                    onTap: () {

                                    },
                                    child: Text(selectedOnlineWallet!.selectedMerchant?.enterWalletText ?? '', style: TextStyle(color: primaryColor))
                                ),
                              ],
                            ).mt(20),

                            // 存款提示
                            if(selectedOnlineWallet!.selectedMerchant?.paymentHint != null)
                              Text(
                                selectedOnlineWallet!.selectedMerchant?.paymentHint ?? '',
                                style: TextStyle(color: Colors.red),
                              ).mt(20),

                            // 取款密碼
                            Row(
                              children: [
                                Text('*', style: TextStyle(color: Colors.red)),
                                Text('取款密碼').mr(20),
                                TextField(
                                  controller: _passwordController,

                                  textAlignVertical: TextAlignVertical.center,

                                  decoration: InputDecoration(
                                    labelText: '請輸入取款密碼',
                                    errorText: _passwordErrorText,
                                    contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距
                                    border: const OutlineInputBorder(),
                                  ),
                                ).flex(),
                              ],
                            ).mt(20),
                          ],
                        )
                    ),
                  ],
                ).mt(20),

              ],
            ),

          // 提交
          ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: Text('提交')
          ).w(double.infinity).mt(30)
        ],
      ).p(40),
    );
  }
}
