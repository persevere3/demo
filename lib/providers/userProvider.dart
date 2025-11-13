import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//
class Item {
  final  id;
  final String name;
  final String imgUrl;

  const Item({required this.id, required this.name, required this.imgUrl});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'imgUrl': imgUrl};

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'], name: json['name'], imgUrl: json['imgUrl']);
  }
}

// 提供收藏邏輯
class FavoriteNotifier extends StateNotifier<List<Item>> {
  static const _storageKey = 'favorites';
  FavoriteNotifier() : super([]) {
    _loadFavorites();
  }

  // 載入收藏列表
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      state = jsonList.map((e) => Item.fromJson(e)).toList();
    }
  }

  // 保存收藏列表
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  // 新增收藏
  void add(Item item) {
    if (!isFavorited(item)) {
      state = [...state, item];
      _saveFavorites();
    }
  }

  // 移除收藏
  void remove(Item item) {
    state = state.where((element) => element.id != item.id).toList();
    _saveFavorites();
  }

  // 判斷是否已收藏
  bool isFavorited(Item item) {
    return state.any((element) => element.id == item.id);
  }
}

// 定義provider
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<Item>>(
      (ref) => FavoriteNotifier(),
);