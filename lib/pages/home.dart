import 'package:flutter/material.dart';
import 'package:demo/extensions/widget.dart';
import '../config/app_config.dart';
import '../../components/carousel.dart';
import '../../api/ProductApi.dart';

class HomeScreen extends StatelessWidget {
  final AppConfig config;
  final productApi = ProductApi();

  HomeScreen({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(config.appName)),
        backgroundColor: Color(int.parse(config.primaryColor.replaceFirst('#', '0xFF'))),
      ),
      body: FutureBuilder(
        future: productApi.getProducts(),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Banner(),
              News(),
              Hot(),
              Product()
            ],
          );
        }
      )

    );
  }
}

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://picsum.photos/id/1011/800/400',
      'https://picsum.photos/id/1012/800/400',
      'https://picsum.photos/id/1013/800/400',
    ];

    return Carousel(
      imgList: imageUrls,
      // aspectRatio: 828 / 280,
      borderRadius: 16,
      onTap: (index) {
        print('點擊第 $index 張圖');
      },
    );
  }
}

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
            "最新公告",
            style: TextStyle()
                    .textSize(15)
                    .textColor(Colors.blueAccent)
        ).p(10),
        Text("最新公告最新公告最新公告最新公告最新公告").p(10),
      ]
    );
  }
}

class Hot extends StatelessWidget {
  const Hot({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:<Widget> [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  "熱門推薦",
                  style: TextStyle()
                      .textSize(15)
                      .textColor(Colors.blueAccent)
              ).p(10),
              Icon(Icons.add).mr(5),
            ]
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(10, (index) {
                return Column( children: <Widget>[
                  Column( children: <Widget>[
                    Container(color: Colors.black12).wh(70, 70).mb(5),
                    Text('熱門推薦$index')
                  ]).p(5)
                ]).p(5);
              })
          ).p(10),
        ).fullWidth()
      ]
    );
  }
}

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children:<Widget> [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(10, (index) {
                return Column( children: <Widget>[
                  Container(color: Colors.black12).wh(55, 55),
                  Text('分類$index')
                ]).p(5);
              }),
            ),
          ).h(300).mx(5),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 5, // 水平間距
              mainAxisSpacing: 5,  // 垂直間距
              childAspectRatio: 5 / 6,
              shrinkWrap: true,
              children: List.generate(21, (index) {
                return Column( children: <Widget>[
                  Container(color: Colors.black12).wh(75, 75).rounded(5),
                  Text('產品$index')
                ]);
              }),
            ).h(300),
          ),
        ]
    );
  }
}