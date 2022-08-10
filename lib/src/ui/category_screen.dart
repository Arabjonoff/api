import 'dart:convert';

import 'package:api/src/model/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryModel? data;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data!.results.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 56,
                        width: 56,
                        child: CachedNetworkImage(
                          imageUrl: data!.results[index].image,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 56,
                          width: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data!.results[index].name,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  _getData() async {
    String url = "https:.uz/api/v1/categories";
    print(url);
    http.Response response = await http.get(
      Uri.parse(url),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      CategoryModel result = CategoryModel.fromJson(
        json.decode(
          utf8.decode(response.bodyBytes),
        ),
      );
      setState(() {
        data = result;
      });
    }
  }
}
