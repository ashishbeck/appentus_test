import 'package:appentus/code/constants.dart';
import 'package:appentus/code/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Painting> paintings = [];

  fetchImages() async {
    String url = "https://picsum.photos/v2/list";
    var dio = Dio();
    Response response = await dio.get(url);
    List data = response.data;
    data.forEach((element) {
      paintings.add(Painting(author: element['author'], url: element['download_url']));
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget gridTile(int index) {
      Painting painting = paintings[index];
      String url = painting.url;
      String author = painting.author;
      return GridTile(
        // child: Image.network(url, fit: BoxFit.cover, cacheHeight: 150),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          memCacheHeight: 150,
          placeholder: (context, url) => Padding(padding: EdgeInsets.all(width / 9), child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        footer: Stack(
          children: [Text(author, style: gridTextStyle), Text(author)],
        ),
      );
    }

    // staggeredGridView() {
    //   return StaggeredGridView.countBuilder(
    //     itemCount: paintings.length,
    //     crossAxisCount: 3,
    //     mainAxisSpacing: 4,
    //     crossAxisSpacing: 4,
    //     staggeredTileBuilder: (index) => StaggeredTile.fit(1),
    //     itemBuilder: (context, index) => gridTile(index),
    //   );
    // }

    gridView() {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemCount: paintings.length,
          itemBuilder: (context, index) => gridTile(index));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Container(
        child: paintings.isNotEmpty
            ? gridView()
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
