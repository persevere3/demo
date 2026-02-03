import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

/// 定義上傳圖片的數據模型
/// 這是一個簡單的數據類（Data Class），用於封裝圖片相關信息
/// 好處：統一數據結構，方便在不同組件間傳遞
class UploadedImage {
  final File? file;        // 移動平台使用的文件對象
  final Uint8List? bytes;  // Web 平台使用的字節數組
  final String? fileName;  // 文件名稱

  UploadedImage({this.file, this.bytes, this.fileName});

  /// Getter：計算屬性，根據平台判斷是否有圖片
  /// kIsWeb 是 Flutter 提供的編譯時常量，用於判斷當前運行平台
  bool get hasImage => (kIsWeb ? bytes != null : file != null);
}

class ImageUploadWidget extends StatefulWidget {
  /// Callback 函數：用於子組件向父組件傳遞數據
  /// Flutter 是單向數據流：父 -> 子通過構造函數傳參，子 -> 父通過 callback
  final Function(UploadedImage?) onImageChanged;

  /// 構造函數
  /// Key：用於 Flutter 識別和複用 Widget，通常用於列表或動畫
  /// required：Dart 語法，表示此參數必須提供
  const ImageUploadWidget({
    Key? key,
    required this.onImageChanged,
  }) : super(key: key);

  /// createState：StatefulWidget 必須實現的方法
  /// 創建一個 State 對象來管理組件的可變狀態
  /// 注意：Widget 是不可變的（immutable），State 是可變的（mutable）
  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

/// State 類：管理 StatefulWidget 的狀態
/// 生命週期：initState -> build -> (setState觸發重建) -> dispose
class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  /// 狀態變量：這些變量的改變會觸發 UI 重建（通過 setState）
  File? _imageFile;        // 存儲移動平台的圖片文件
  Uint8List? _webImage;    // 存儲 Web 平台的圖片字節

  /// final 變量：初始化後不能改變
  /// ImagePicker：第三方套件，用於從相簿或相機選擇圖片
  final ImagePicker _picker = ImagePicker();

  /// 非同步函數：選擇圖片
  /// async/await：Dart 的異步編程機制
  /// Future<void>：表示此函數會在未來某個時間點完成，不返回值
  Future<void> _pickImage() async {
    // 調用 image_picker 插件選擇圖片
    // await：等待異步操作完成
    // XFile：跨平台的文件抽象類
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,  // 從相簿選擇
      maxWidth: 1800,                // 限制最大寬度（性能優化）
      maxHeight: 1800,               // 限制最大高度
    );

    // null check：如果用戶取消選擇，image 為 null
    if (image != null) {
      // kIsWeb：編譯時常量，根據平台執行不同代碼
      // 編譯後，非目標平台的代碼會被移除（tree shaking）
      if (kIsWeb) {
        // Web 平台處理邏輯
        final bytes = await image.readAsBytes();  // 將圖片讀取為字節數組

        setState(() {
          _webImage = bytes;
        });

        // 通知父組件
        widget.onImageChanged(UploadedImage(
          bytes: bytes,
          fileName: image.name,
        ));
      }
      else {
        // 移動平台（iOS/Android）處理邏輯
        setState(() {
          _imageFile = File(image.path);  // 創建 File 對象
        });

        // 通知父組件
        widget.onImageChanged(UploadedImage(
          file: _imageFile,
          fileName: image.name,
        ));
      }
    }
  }

  /// 刪除圖片的函數
  void _removeImage() {
    // 清空狀態變量
    setState(() {
      _imageFile = null;
      _webImage = null;
    });

    // 通知父組件圖片已刪除（傳 null）
    widget.onImageChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    // 計算是否有圖片（避免在 Widget 樹中重複判斷）
    bool hasImage = kIsWeb ? _webImage != null : _imageFile != null;

    /// GestureDetector：手勢檢測器，用於捕捉用戶交互
    /// Flutter 中所有的交互都是通過 GestureDetector 或其變體實現
    return GestureDetector(
      onTap: !hasImage ? _pickImage : null,

      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(8),  // 圓角
        ),

        /// 條件渲染：根據狀態顯示不同的 Widget
        /// Flutter 中沒有 if 語句直接在 Widget 樹中使用
        /// 必須使用三元運算符或提取到方法中
        child: !hasImage
            ? _buildUploadPlaceholder()  // 顯示上傳提示
            : _buildImagePreview(),      // 顯示圖片預覽
      ),
    );
  }

  /// 提取 Widget 構建方法：提高代碼可讀性
  /// 返回上傳佔位符的 UI
  Widget _buildUploadPlaceholder() {
    /// Column：垂直排列子 Widget
    /// 類似的還有 Row（水平）、Stack（堆疊）
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,  // 主軸居中（垂直方向）
      children: [
        Icon(Icons.add, size: 40, color: Colors.grey),
        SizedBox(height: 8),  // 空白間距（推薦用 SizedBox 而非 Padding）
        Text(
          '截圖上傳',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  /// 構建圖片預覽的 UI
  Widget _buildImagePreview() {
    /// Stack：堆疊佈局，子 Widget 可以重疊
    /// 用於實現圖片上方疊加刪除按鈕
    return Stack(
      fit: StackFit.expand,  // 子 Widget 擴展填滿 Stack
      children: [
        /// ClipRRect：裁剪圓角
        /// Flutter 中圖片默認不會遵循父容器的圓角，需要顯式裁剪
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: kIsWeb
          /// Image.memory：從內存中的字節數組加載圖片（Web）
              ? Image.memory(_webImage!, fit: BoxFit.cover)
          /// Image.file：從文件路徑加載圖片（移動端）
              : Image.file(_imageFile!, fit: BoxFit.cover),
          // fit: BoxFit.cover 確保圖片填滿容器，類似 CSS 的 cover
        ),

        /// Positioned：在 Stack 中絕對定位
        /// 類似 CSS 的 position: absolute
        Positioned(
          right: 5,   // 距離右邊 5 像素
          top: 5,     // 距離上邊 5 像素
          child: GestureDetector(
            onTap: _removeImage,  // 點擊刪除按鈕
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,  // 圓形背景
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}