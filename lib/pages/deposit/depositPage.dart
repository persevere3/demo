import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:demo/extensions/widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/configProvider.dart';
// import 'package:demo/providers/userProvider.dart';

import '../../../layout/DefaultLayout.dart';
import '../../components/Drawer.dart';
import '../../utils/datetime_picker_utils.dart';

//
enum DepositType {
  online,      // 線上存款
  offline,     // 線下存款
  vip,         // VIP 支付
}

// 線上錢包 配置
class OnlineWallet {
// final String id;                                   // 錢包唯一識別
  final String name;                                  // 錢包名稱（顯示用）
  final String icon;                                  // 錢包 icon（可選，或用 IconData）
  final bool isRecommended;                           // 是否推薦
  List<OnlineWalletMerchantOption> merchantOptions;   // 商號選擇列表
  OnlineWalletMerchantOption? selectedMerchant;       // 選中的商號

  OnlineWallet({
    // required this.id,
    required this.name,
    this.icon = '',
    this.isRecommended = false,
    required this.merchantOptions,
    this.selectedMerchant,
  });
}

// 線上錢包 商號選項
class OnlineWalletMerchantOption {
  // final String id;                       // 商號 ID
  final String name;                        // 商號名稱
  final String? logo;                       // 商號 logo URL（可選）
  final String? instructionUrl;             // 使用說明連結
  final double minAmount;                   // 最小存款額度
  final double maxAmount;                   // 最大存款額度
  final String? bonusText;                      // 該商號的贈送優惠
  final String? handlingFeeText;                // 手續費
  final String? hint;                       // 提示文字
  final List<double>? quickAmounts;         // 該商號的快捷額度（會跟著變動）
  final bool? isAccountHolderNameRequired;  // 是否需要填帳號名稱

  OnlineWalletMerchantOption({
    // required this.id,
    required this.name,
    this.logo,
    this.instructionUrl,
    required this.minAmount,
    required this.maxAmount,
    this.bonusText,
    this.handlingFeeText,
    this.hint,
    this.quickAmounts,
    this.isAccountHolderNameRequired
  });
}

// VIP
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

// 線下
class OfflineDepositType {
  final String name;
  final int type;

  OfflineDepositType({
    required this.name,
    required this.type,
  });
}

class OfflineDepositAccount {
  /// 銀行名稱
  final String bankName;

  /// 收款人
  final String accountHolderName;

  /// 開戶行網點
  final String bankBranch;

  /// 銀行帳號
  final String accountNumber;

  /// 提示訊息
  final String? hint;

  OfflineDepositAccount({
    required this.bankName,
    required this.accountHolderName,
    required this.bankBranch,
    required this.accountNumber,
    this.hint,
  });
}

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({super.key});
  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> with TickerProviderStateMixin {
  late BuildContext _outerContext;

  // 線上存款 =============================================
  final String _anouncement = '暫無公告!';

  DepositType _depositType = DepositType.online;

  final List<OnlineWallet> onlineWallets = [
    OnlineWallet(
      // id: '紅豆錢包',
      name: '紅豆錢包',
      icon: '💰',
      isRecommended: true,
      merchantOptions: [
        OnlineWalletMerchantOption(
          name: '紅豆錢包',
          instructionUrl: 'https://open.hdpay.top/tutorial/',
          minAmount: 10,
          maxAmount: 1000000,
          bonusText: '1.2%',
          handlingFeeText: '1%',
          quickAmounts: [10, 100, 1000, 10000, 100000, 1000000],
          hint: '【注册送36元】红豆钱包充值，笔笔加赠最高3%，专享优惠活动，存取款秒到账！',
          isAccountHolderNameRequired: true
        ),
        OnlineWalletMerchantOption(
          name: '商號 B',
          minAmount: 50,
          maxAmount: 5000,
          bonusText: '1.2345%',
          quickAmounts: [50, 100, 500, 1000, 2000, 3000, 5000],
        ),
      ],
    ),
  ];
  OnlineWallet? selectedOnlineWallet;

  // 帳號 + 幣種
  final String _account = 'Jacob';
  final String _currency = 'CNY';

  // 輸入金額
  final TextEditingController _amountController = TextEditingController();
  String? _amountErrorText;
  final TextEditingController _accountHolderNameController = TextEditingController();
  String? _accountHolderNameErrorText;

  // 顯示 公告
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

  // 修改 存款類型
  void _changeDepositType(type) {
    setState(() {
      _depositType = type;
      if(type == DepositType.online) {
        selectedOnlineWallet = onlineWallets[0];
        selectedOnlineWallet?.selectedMerchant = selectedOnlineWallet?.merchantOptions[0];
      }
      else if(type == DepositType.vip) {
        selectedVIPMerchant = VIPMerchantList[0];
      }
    });
  }
  Widget _handleContent(Color primaryColor) {
    return switch (_depositType) {
      DepositType.online => _buildOnlineDepositContent(primaryColor),
      DepositType.vip => _buildVipDepositContent(primaryColor),
      DepositType.offline => _buildOfflineDepositContent(primaryColor),
    };
  }

  // 確定轉換
  void _confirmDeposit() {
    final amountText = _amountController.text;
    final accountHolderNameText = _accountHolderNameController.text;


    setState(() {
      _amountErrorText = validateAmount(amountText);
      if(selectedOnlineWallet?.selectedMerchant?.isAccountHolderNameRequired ?? false) {
        _accountHolderNameErrorText = validateAccountHolderName(accountHolderNameText);
      }
    });

    if (_amountErrorText != null) return;
    if(selectedOnlineWallet?.selectedMerchant?.isAccountHolderNameRequired ?? false) {
      if (_accountHolderNameErrorText != null) return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('確定存款: $amountText').mr(10),
            if(selectedOnlineWallet?.selectedMerchant?.isAccountHolderNameRequired ?? false)
              Text('帳戶姓名: $accountHolderNameText')
          ],
        ),
      ),
    );
  }
  String? validateAmount(String text) {
    if (text.isEmpty) return '請輸入金額';

    final value = double.tryParse(text);
    if (value == null) return '請輸入有效數字';
    if (value < 0) return '金額不能為負數';

    // 檢查 區間
    final wallet = selectedOnlineWallet;
    if(wallet == null) return null;
    final merchant = wallet.selectedMerchant;
    if(merchant == null) return null;
    if (value < merchant.minAmount ||
        value > merchant.maxAmount
    ) {
      return '存款额度须在 ${selectedOnlineWallet?.selectedMerchant?.minAmount} - ${selectedOnlineWallet?.selectedMerchant?.maxAmount} 之間';
    }

    return null; // 通過驗證
  }
  String? validateAccountHolderName(String text) {
    if (text.isEmpty) return '請輸入帳戶姓名';

    return null; // 通過驗證
  }

  // VIP支付 =============================================
  List<VIPMerchant> VIPMerchantList = [
    VIPMerchant(
      name: '紅豆快速錢包',
      paymentTypeWalletText: '紅豆快速錢包',
      paymentTypeHint: '点击"绑定"进行授权绑定。',
      showsManagePayments: true,
      minAmount: 10,
      maxAmount: 100000,
      enterWalletText: '進入紅豆快速錢包',
      requiresPaymentPassword: false,
      requiresSmsVerification: false,
      paymentHint: '【注册送36元】 点击"绑定"进行授权绑定>下载红豆钱包完成相关验证>钱包转出或者转入操作>首次存款或取款需短信验证授权'
    ),
    VIPMerchant(
        name: '錢能快速錢包',
        paymentTypeWalletText: '錢能快速錢包1-5000000',
        // paymentTypeHint: '',
        showsManagePayments: false,
        minAmount: 1,
        maxAmount: 5000000,
        enterWalletText: '進入錢能錢包',
        requiresPaymentPassword: false,
        requiresSmsVerification: false,
        paymentHint: '快速充值绑定手机号，需与注册信息手机号一致。一经绑定无法更改。'
    ),
  ];
  VIPMerchant? selectedVIPMerchant;

  // 金額
  final TextEditingController _VIPAmountController = TextEditingController();
  String? _VIPAmountErrorText;

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
        child: OrderQueryDrawerContent(primaryColor),
      ),
    );
  }
  Widget OrderQueryDrawerContent(Color primaryColor) {
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
        child: OrderFilterDrawerContent(primaryColor),
      ),
    );
  }

  DateTime _orderFilterStart = DateTimePickerUtils.startOfDay();
  DateTime _orderFilterEnd = DateTime.now();
  String? selectedValue;
  final List<String> items = ['選項1', '選項2', '選項3'];

  Widget OrderFilterDrawerContent(Color primaryColor) {
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
                      _outerContext,
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

  // 提交
  void _submit() {
    final VIPAmountText = _VIPAmountController.text;

    setState(() {
      _VIPAmountErrorText = validateAmount(VIPAmountText);
    });

    if (_VIPAmountErrorText != null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('提交 金額: $VIPAmountText').mr(10),
          ],
        ),
      ),
    );
  }

  // 線下存款 =============================================
  // 存款方式
  List<OfflineDepositType> offlineDepositTypes = [
    OfflineDepositType(name: '錢能錢包', type: 1),
    OfflineDepositType(name: '購寶錢包', type: 1),
    OfflineDepositType(name: '虛擬幣支付', type: 2),
  ];
  OfflineDepositType? selectedOfflineDepositType;
  String? selectedOfflineDepositTypeErrorText;

  // 轉入帳戶
  List<OfflineDepositAccount> offlineDepositAccounts = [
    OfflineDepositAccount(
      bankName: '购宝钱包',
      accountHolderName: '购宝钱包APP',
      bankBranch: '购宝钱包APP',
      accountNumber: '请联系在线客服！',
      hint: '需下载购宝钱包，进行实名，绑定收付款方式以及平台【选择购宝充值方式-使用购宝扫描器进行扫码、点击【确认付款】无论成功或失败或余额是否足够，都会自动激活及绑定，扫码可获取下载地址和详细存款教程'
    ),
    OfflineDepositAccount(
      bankName: '钱能钱包',
      accountHolderName: '钱能钱包',
      bankBranch: '钱能钱包',
      accountNumber: 'qnee0cbf8c7cb7de4b'
    )
  ];
  OfflineDepositAccount? selectedOfflineDepositAccount;

  // 轉出帳戶
  List<String> offlineWithdrawAccounts = [
    '錢能錢包',
    '匯旺ID錢包',
    'OnePay錢包',
    '樂山市商業銀行',
    '天山農商銀行'
  ];
  String? selectedOfflineWithdrawAccount;
  String? selectedOfflineWithdrawAccountErrorText;

  // 金額
  final TextEditingController _offlineAmountController = TextEditingController();
  String? _offlineAmountErrorText;

  // 時間
  DateTime? pickedTime;
  String? pickedTimeErrorText;

  // 存款人姓名
  final TextEditingController _offlineNameController = TextEditingController();
  String? _offlineNameErrorText;

  //
  static String _format(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}';

  // 提交
  void _offlineDepositSubmit() {
    final type = selectedOfflineDepositType;
    final bank = selectedOfflineWithdrawAccount;
    final offlineAmountText = _offlineAmountController.text;
    final time = pickedTime;
    final offlineNameText = _offlineNameController.text;


    setState(() {
      if(type == null) {
        selectedOfflineDepositTypeErrorText = '請選擇存款方式';
      }
      else {
        selectedOfflineDepositTypeErrorText = null;
      }

      if(bank == null) {
        selectedOfflineWithdrawAccountErrorText = '請選擇帳戶';
      }
      else {
        selectedOfflineWithdrawAccountErrorText = null;
      }

      _offlineAmountErrorText = validateAmount(offlineAmountText);

      if(time == null) {
        pickedTimeErrorText = '請選擇時間';
      }
      else {
        pickedTimeErrorText = null;
      }

      if(offlineNameText.isEmpty) {
        _offlineNameErrorText = '請輸入存款人姓名';
      }
      else {
        _offlineNameErrorText = null;
      }
    });

    if(bank == null) return;
    if (_offlineAmountErrorText != null) return;
    if(time == null) return;
    if (_offlineNameErrorText != null) return;


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('線下存款 提交').mr(10),
            Text('銀行: $bank').mr(10),
            Text('金額: $offlineAmountText').mr(10),
            Text('時間: $time').mr(10),
            Text('存款人姓名: $offlineNameText ').mr(10),
          ],
        ),
      ),
    );
  }

  // override =============================================

  @override
  void initState() {
    super.initState();

    _depositType = DepositType.online;

    // api 取得 onlineWallets

    selectedOnlineWallet = onlineWallets[0];
    selectedOnlineWallet?.selectedMerchant = selectedOnlineWallet?.merchantOptions[0];
  }

  @override
  void dispose() {
    _amountController.dispose();
    _VIPAmountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final primaryColor = config.primaryColor.toColor();

    _outerContext = context; // ✅ 儲存

    return DefaultLayout(
      // title 可選，不傳則使用 config.appName
      title: '快速充值',
      child: Column(
        children: [
          _buildAnnouncement(),

          const Divider(height: 1),

          _buildTabs(primaryColor).mt(10),

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

  // 建立 標籤 =============================================
  Widget _buildTabs(Color primaryColor) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
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
            label: '線上存款',
            selected: _depositType == DepositType.online,
            onTap: () {
              _changeDepositType(DepositType.online);
            },
          ),
          _buildTab(
            primaryColor: primaryColor,
            label: 'VIP支付',
            selected: _depositType == DepositType.vip,
            onTap: () {
              _changeDepositType(DepositType.vip);
            },
          ),
          _buildTab(
            primaryColor: primaryColor,
            label: '線下存款',
            selected: _depositType == DepositType.offline,
            onTap: () {
              _changeDepositType(DepositType.offline);
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

  // 建立 線上存款 內容 =============================================
  Widget _buildOnlineDepositContent(Color primaryColor) {
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
                    wallet.selectedMerchant = wallet.merchantOptions[0];
                  });
                },
                child: Text(onlineWallets[walletIndex].name),
              );
            }),
          ),

          // 使用說明
          if(selectedOnlineWallet?.selectedMerchant?.instructionUrl != null)
           Text('[${selectedOnlineWallet?.name}說明] 買賣幣使用流程 | [下載地址]', style: TextStyle(color: Colors.red)).mt(20),

          // 帳號 + 幣種
          Text('帳號: $_account').mt(20),
          Text('幣種: $_currency'),

          // 商號 下拉
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<OnlineWalletMerchantOption>(
              value: selectedOnlineWallet?.selectedMerchant,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: selectedOnlineWallet?.merchantOptions.map((option) {
                return DropdownMenuItem<OnlineWalletMerchantOption>(
                  value: option,
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(option.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (OnlineWalletMerchantOption? newValue) {
                setState(() {
                  selectedOnlineWallet?.selectedMerchant = newValue!;
                });
              },
            ),
          ).mt(20),

          // 金額
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,

            textAlignVertical: TextAlignVertical.center,  // 關鍵設定

            decoration: InputDecoration(
              labelText: '輸入金額',
              errorText: _amountErrorText,
              contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距

              prefix: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.attach_money, size: 20).mr(5),
                ],
              ).h(35),

              // prefixIcon: Icon(Icons.attach_money, size: 20),  // 左：貨幣圖標,
              suffixIcon: IconButton(  // 右：可點擊清空按鈕
                icon: Icon(Icons.clear),
                onPressed: () {
                  _amountController.clear();
                  setState(() {
                    _amountErrorText = null;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
          ).px(1).mt(20),

          // 存款额度說明 贈送優惠 手續費 提示 快捷按鈕 帳號名稱
          if( selectedOnlineWallet?.selectedMerchant != null) ...[
            // 存款额度說明
            Text('(存款额度须在 ${selectedOnlineWallet?.selectedMerchant?.minAmount} - ${selectedOnlineWallet?.selectedMerchant?.maxAmount} 之間)').mt(2),

            // 贈送優惠
            if(selectedOnlineWallet?.selectedMerchant?.bonusText != null)
              Text(
                '贈送優惠: ${selectedOnlineWallet?.selectedMerchant?.bonusText}',
                style: TextStyle(color: Colors.white)
              ).px(6).py(3).bg('#ed6f00'.toColor()).rounded(3).mt(5),

            // 手續費
            if(selectedOnlineWallet?.selectedMerchant?.handlingFeeText != null)
              Text(
                  '手續費: ${selectedOnlineWallet?.selectedMerchant?.handlingFeeText}',
                  style: TextStyle(color: Colors.white)
              ).px(6).py(3).bg('#ff1414'.toColor()).rounded(3).mt(5),

            // 提示
            if(selectedOnlineWallet?.selectedMerchant?.hint != null)
              Text('${selectedOnlineWallet?.selectedMerchant?.hint}', style: TextStyle(color: Colors.red)).mt(5),

            // 快捷按鈕 列表
            if(selectedOnlineWallet?.selectedMerchant?.quickAmounts != null)
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,            // 不滾動時使用
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3,       // 調整按鈕寬高比
                children: List.generate( selectedOnlineWallet?.selectedMerchant?.quickAmounts?.length ?? 0, (quickAmountIndex) {
                return ElevatedButton(
                  style:  ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 圓角
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _amountController.text = '${selectedOnlineWallet?.selectedMerchant?.quickAmounts?[quickAmountIndex]}';
                    });
                  },
                  child: Text('${selectedOnlineWallet?.selectedMerchant?.quickAmounts?[quickAmountIndex]}'),
                );
                }),
            ).mt(20)
          ],

          // 帳號名稱
          if(
            selectedOnlineWallet?.selectedMerchant?.isAccountHolderNameRequired != null &&
            selectedOnlineWallet?.selectedMerchant?.isAccountHolderNameRequired != false
          ) ...[
            TextField(
              controller: _accountHolderNameController,

              textAlignVertical: TextAlignVertical.center,  // 關鍵設定

              decoration: InputDecoration(
                labelText: '輸入帳戶姓名',
                errorText: _accountHolderNameErrorText,
                contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距

                prefix: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.people, size: 20).mr(5),
                  ],
                ).h(35),

                // prefixIcon: Icon(Icons.attach_money, size: 20),  // 左：貨幣圖標,
                suffixIcon: IconButton(  // 右：可點擊清空按鈕
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _amountController.clear();
                    setState(() {
                      _amountErrorText = null;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ).px(1).mt(20),
            Text('(銀行轉帳姓名和註冊姓名需一致)', style: TextStyle(color: primaryColor)),
          ],

          // 確定存款
          ElevatedButton(
            onPressed: () {
              _confirmDeposit();
            },
            child: Text('確定存款')
          ).w(double.infinity).mt(30)
        ],
      ).px(40).py(20),
    );
  }

  // 建立 VIP 內容 =============================================
  Widget _buildVipDepositContent(Color primaryColor) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: List.generate(VIPMerchantList.length, (index) {
                    return ElevatedButton(
                      style:  ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // 圓角
                        ),
                        side: BorderSide(
                          color: VIPMerchantList[index] == selectedVIPMerchant ? primaryColor : '#aaaaaa'.toColor(),
                          width: 1
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: VIPMerchantList[index] == selectedVIPMerchant ? primaryColor : '#777777'.toColor(),// border
                      ),
                      onPressed: () {
                        setState(() {
                          selectedVIPMerchant = VIPMerchantList[index];
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wallet_giftcard).mr(5),
                          Text(VIPMerchantList[index].name)
                        ],
                      ),
                    );
                  }),
                )
              ),
            ],
          ),

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
                      if(selectedVIPMerchant?.paymentTypeHint != null)
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
                                    if(selectedVIPMerchant?.paymentTypeWalletText != null)
                                      Row(
                                        children: [
                                          Icon(Icons.wallet_giftcard),
                                          Text(
                                            selectedVIPMerchant?.paymentTypeWalletText ?? '',
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
                      if(selectedVIPMerchant?.paymentTypeHint != null)
                        Text(
                          selectedVIPMerchant?.paymentTypeHint ?? '',
                          style: TextStyle(color: Colors.red),
                        ),

                      // 管理綁定支付方式
                      if(selectedVIPMerchant?.showsManagePayments ?? false)
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
                      Text('請輸入存款金額', style: TextStyle(color: Colors.white)).flex(),
                      Text(
                          '存款額度需在 ${selectedVIPMerchant?.minAmount} - ${selectedVIPMerchant?.maxAmount} 之間',
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
                            controller: _VIPAmountController,
                            keyboardType: TextInputType.number,

                            textAlignVertical: TextAlignVertical.center,  // 關鍵設定

                            decoration: InputDecoration(
                              labelText: '輸入金額',
                              errorText: _VIPAmountErrorText,
                              contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距
                              border: const OutlineInputBorder(),
                            ),
                          ).flex(),
                        ],
                      ),

                      // 錢包餘額
                      Row(
                        children: [
                          Text('錢包餘額').mr(20),

                          Text('0   ${_currency}', style: TextStyle(color: '#fc7f03'.toColor(), fontSize: 16, fontWeight: FontWeight.bold)).flex(),

                          InkWell(
                            onTap: () {

                            },
                            child: Text(selectedVIPMerchant?.enterWalletText ?? '', style: TextStyle(color: primaryColor))
                          ),
                        ],
                      ).mt(20),

                      // 存款提示
                      if(selectedVIPMerchant?.paymentHint != null)
                        Text(
                          selectedVIPMerchant?.paymentHint ?? '',
                          style: TextStyle(color: Colors.red),
                        ).mt(20),
                    ],
                  )
              ),
            ],
          ).mt(20),

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

  // 建立 線下存款 內容 =============================================
  Widget _buildOfflineDepositContent(Color primaryColor) {
    return SingleChildScrollView(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 存款方式
          Text('存款方式').w(double.infinity),
          // 下拉
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selectedOfflineDepositTypeErrorText != null ? Colors.red.darken(0.3) : Colors.grey.shade300),
            ),
            child: DropdownButton<OfflineDepositType>(
              value: selectedOfflineDepositType,
              hint: Text('請選擇'),   // ✅ 預設文字
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: offlineDepositTypes.map((option) {
                return DropdownMenuItem<OfflineDepositType>(
                  value: option,
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(option.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (OfflineDepositType? newValue) {
                setState(() {
                  selectedOfflineDepositType = newValue!;
                });
              },
            ),
          ).mt(20),
          if(selectedOfflineDepositTypeErrorText != null)
            Text(
                selectedOfflineDepositTypeErrorText!,
                style: TextStyle(
                    color: Colors.red.darken(0.3),
                    fontSize: 13
                )
            ).mt(5).ml(12),

          // 選擇轉入帳號
          Text('一、请选择转入账号').w(double.infinity).mt(20),
          ListView.builder(
            itemCount: offlineDepositAccounts.length,
            itemBuilder: (context, index) {
              final account = offlineDepositAccounts[index];
              Color backgroundColor = account == selectedOfflineDepositAccount ? primaryColor.lighten(0.1) : Colors.white;
              Color textColor = account == selectedOfflineDepositAccount ? Colors.white : '#555555'.toColor();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: backgroundColor,
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('銀行: ${account.bankName}', style: TextStyle(color: textColor)).mb(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('收款人: ${account.accountHolderName}', style: TextStyle(color: textColor)),
                          TextButton(
                            onPressed: () {

                            },
                            child: Text('複製')
                          ).h(25),
                        ],
                      ).mb(5),
                      Text('收款人: ${account.accountHolderName}', style: TextStyle(color: textColor)).mb(5),
                      Text('開戶行網點: ${account.bankBranch}', style: TextStyle(color: textColor)).mb(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('帳號: ${account.accountNumber}', style: TextStyle(color: textColor)),
                          TextButton(
                            onPressed: () {

                            },
                            child: Text('複製')
                          ).h(25),
                        ],
                      ).mb(5),
                      if (account.hint != null && account.hint!.isNotEmpty)
                        Text('提示: ${account.hint}', style: TextStyle(color: Colors.red.darken(0.2)))
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    setState(() {
                      selectedOfflineDepositAccount = account;
                    });
                  },
                ),
              );
            },
          ).h(400).mt(10),

          // 掃碼存款
          Text('掃碼存款:').mt(20),
          Container(
            width: 250,
            height: 250,
            color: primaryColor.lighten(0.3),
            child: QrImageView(
              data: 'https://www.youtube.com/',
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            ),
          ).center(),
          Text(
            '${selectedOfflineDepositAccount?.accountHolderName} 下載碼',
            style: TextStyle(fontWeight: FontWeight.w600)
          ).center().mt(10),
          TextButton(
            onPressed: () {

            },
            child: Text(
              '转跳支付(请先截屏或长按二维码保存)',
              style: TextStyle(color: primaryColor.darken(0.1))
            ),
          ).w(double.infinity).mt(10),

          // 選擇轉出帳號
          Text('二、选择您所使用的银行帐户').w(double.infinity).mt(20),

          // 轉出帳號 下拉
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selectedOfflineWithdrawAccountErrorText != null ? Colors.red.darken(0.3) : Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              value: selectedOfflineWithdrawAccount,
              hint: Text('請選擇'),   // ✅ 預設文字
              isExpanded: true,
              underline: const SizedBox.shrink(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: offlineWithdrawAccounts.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(option),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOfflineWithdrawAccount = newValue!;
                });
              },
            ),
          ).mt(20),
          if(selectedOfflineWithdrawAccountErrorText != null)
            Text(
              selectedOfflineWithdrawAccountErrorText!,
              style: TextStyle(
                color: Colors.red.darken(0.3),
                fontSize: 13
              )
            ).mt(5).ml(12),

          // 金額
          TextField(
            controller: _offlineAmountController,
            keyboardType: TextInputType.number,

            textAlignVertical: TextAlignVertical.center,  // 關鍵設定

            decoration: InputDecoration(
              labelText: '存入金額',
              errorText: _offlineAmountErrorText,
              contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距
              border: const OutlineInputBorder(),
            ),
          ).mt(10),
          if(_offlineAmountErrorText != null)
          Text('支付幣種: $_currency', style: TextStyle(color: Colors.black54)).mt(2),

          // 時間
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final selectedTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  picked.hour,
                  picked.minute,
                );

                // ✅ 這裡就是回傳的地方
                setState(() {
                  pickedTime = selectedTime;  // 更新你的變數
                });
              }
            },
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: pickedTimeErrorText != null ? Colors.red.darken(0.3) : Colors.black26),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.black),
                  SizedBox(width: 12),
                  Text(
                    pickedTime == null
                      ? '選擇時間'
                      : DateTimePickerUtils.formatTime(pickedTime!),
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ],
              ),
            ),
          ).mt(20),
          if(pickedTimeErrorText != null)
            Text(
                pickedTimeErrorText!,
                style: TextStyle(
                    color: Colors.red.darken(0.3),
                    fontSize: 13
                )
            ).mt(5).ml(12),

          // 姓名
          TextField(
            controller: _offlineNameController,
            keyboardType: TextInputType.name,

            textAlignVertical: TextAlignVertical.center,  // 關鍵設定

            decoration: InputDecoration(
              labelText: '存款人姓名',
              errorText: _offlineNameErrorText,
              contentPadding: EdgeInsets.only(left: 10),  // 移除預設內距
              border: const OutlineInputBorder(),
            ),
          ).mt(20),

          // 提交
          ElevatedButton(
              onPressed: () {
                _offlineDepositSubmit();
              },
              child: Text('提交')
          ).w(double.infinity).mt(30)
        ]
      ).p(40),
    );
  }
}
