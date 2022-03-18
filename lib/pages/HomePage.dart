import 'dart:convert';

import 'package:valo_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> allBundle = [];
  final List<Map<String, dynamic>> allMap = [];

  Future getBundleData() async {
    try {
      await Future.delayed(
        Duration(seconds: 1),
      );
      var response = await http.get(
        Uri.parse("https://valorant-api.com/v1/bundles"),
      );
      List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];

      data.forEach((element) {
        allBundle.add(element);
      });
    } catch (e) {
      print(e);
    }
  }

  Future getNewMap() async {
    try {
      await Future.delayed(
        Duration(seconds: 1),
      );

      var response = await http.get(
        Uri.parse("https://valorant-api.com/v1/maps"),
      );

      List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
      data.forEach((element) {
        allMap.add(element);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Valorant UnOf Database",
          style: valorantTextStyle.copyWith(
            fontSize: 40,
            fontWeight: medium,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          "Get all the information in the world of valorant.",
          style: whiteTextStyle.copyWith(
            fontSize: 18,
            fontWeight: light,
          ),
        ),
      ],
    );
  }

  Widget bundle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hot Bundle",
          style: valorantTextStyle.copyWith(
            fontSize: 20,
            fontWeight: medium,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        FutureBuilder(
            future: getBundleData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Loading . . .",
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: medium,
                    ),
                  ),
                );
              }
              return Container(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(
                    width: 1,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return BundleCard(
                      img: "${allBundle[index]["displayIcon"]}",
                      title: "${allBundle[index]["displayName"]}",
                    );
                  },
                ),
              );
            })
      ],
    );
  }

  Widget newMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New Map",
          style: valorantTextStyle.copyWith(
            fontSize: 20,
            fontWeight: medium,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        FutureBuilder(
          future: getNewMap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "Loading . . .",
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: medium,
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "${allMap[index]["splash"]}"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.30),
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "${allMap[index]["displayName"]}",
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(defaultmargin),
      children: [
        header(),
        SizedBox(
          height: 20,
        ),
        bundle(),
        SizedBox(
          height: 20,
        ),
        newMap(),
        SizedBox(
          height: 85,
        ),
      ],
    );
  }
}

class BundleCard extends StatelessWidget {
  final img;
  final title;

  BundleCard({this.img, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(right: 15),
      height: 120,
      width: 260,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(img),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.20),
            BlendMode.darken,
          ),
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: whiteTextStyle.copyWith(
              fontSize: 18,
              fontWeight: medium,
            ),
          )
        ],
      ),
    );
  }
}
