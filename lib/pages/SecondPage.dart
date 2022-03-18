import 'dart:convert';

import 'package:valo_app/pages/AgentPage.dart';
import 'package:valo_app/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondPage extends StatelessWidget {
  List<Map<String, dynamic>> allAgent = [];

  late String uuid = "";

  Future getAllAgent() async {
    try {
      await Future.delayed(
        Duration(seconds: 1),
      );

      var response = await http.get(
        Uri.parse(
            "https://valorant-api.com/v1/agents?isPlayableCharacter=true"),
      );

      List data = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
      data.forEach((element) {
        allAgent.add(element);
      });
      // print(allAgent);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Text(
        "Find an agent that fits your style",
        style: valorantTextStyle.copyWith(
          fontSize: 32,
          fontWeight: medium,
        ),
      );
    }

    Widget agentTile() {
      return FutureBuilder(
          future: getAllAgent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Text(
                "Loading . . .",
                style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ));
            }
            return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: allAgent.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 3 / 5,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      uuid = "${allAgent[index]["uuid"]}";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgentPage(uuid),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "${allAgent[index]["background"]}"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.20),
                            BlendMode.darken,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: "${allAgent[index]["fullPortrait"]}",
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ),
                  );
                });
          });
    }

    return ListView(
      padding: EdgeInsets.all(defaultmargin),
      children: [
        header(),
        SizedBox(
          height: 32,
        ),
        agentTile(),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
