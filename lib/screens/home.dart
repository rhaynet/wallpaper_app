import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/data.dart';
import 'package:wallpaper_app/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/models/wallpaper_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_app/screens/categories.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> categories = [];
  late Future<List<Wallpaper>> futureList;

  @override
  void initState() {
    futureList = getTrendingWallpaper();
    categories = getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe9ebf0),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: const [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search wallpaper',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: const Text(
                  'Popular now',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              FutureBuilder<List<Wallpaper>>(
                future: getTrendingWallpaper(),
                builder: (context, AsyncSnapshot<List<Wallpaper>> snapshot) {
                  return snapshot.hasData
                      ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                          height: 300,
                          color: Colors.transparent,
                          child: ListView.separated(
                            itemCount: snapshot.data!.length,
                            physics: const ClampingScrollPhysics(),

                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 10);
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                height: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    snapshot.data![index].src.portrait,
                                    // height: 300,
                                    // width: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 7.0,
                    childAspectRatio: 2.0,
                  ),
                  children: List.generate(categories.length, (index) {
                    return CategoryTile(
                      imgUrl: categories[index].imageAssetUrl,
                      title: categories[index].categorieName,
                    );
                  }),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({Key? key, required this.imgUrl, required this.title})
      : super(key: key);

  final String imgUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Categories(catergory: title)));
      },
      child: Container(
        width: 220,
        height: 80,
        child: Stack(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  imgUrl,
                  width: 220,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 220,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Wallpaper>> getTrendingWallpaper() async {
  final response = await http.get(
      Uri.parse(
        "https://api.pexels.com/v1/curated?per_page=15",
      ),
      headers: {'Authorization': API_KEY});
  if (response.statusCode == 200) {
    print(response.statusCode);
    Iterable jsonData = jsonDecode(response.body)['photos'];
    // print(jsonData['photos'][0]['photographer_url']);
    List<Wallpaper> wallpaper =
        jsonData.map((element) => Wallpaper.fromJson(element)).toList();
    print(wallpaper.length);
    return wallpaper;
  } else {
    throw Exception('Failed to load wallpaper');
  }
}
