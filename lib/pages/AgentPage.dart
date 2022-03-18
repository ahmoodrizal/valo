import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:valo_app/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class AgentPage extends StatelessWidget {
  late String uuid;
  late Map<String, dynamic> agentData;
  late Map<String, dynamic> role;
  late List<Map<String, dynamic>> abilities = [];
  AgentPage(this.uuid);

  Future getSingleAgent() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      String url = "https://valorant-api.com/v1/agents/$uuid";
      var response = await http.get(
        Uri.parse(url),
      );
      agentData = (jsonDecode(response.body) as Map<String, dynamic>)["data"];
      role = agentData["role"];
      List dataAbilities = agentData["abilities"];
      dataAbilities.forEach(
        (element) {
          abilities.add(element);
        },
      );
      // print(abilities);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body() {
      return FutureBuilder(
          future: getSingleAgent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "Loading . . .",
                  style: whiteTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: medium,
                  ),
                ),
              );
            }
            return ListView(
              padding: EdgeInsets.all(defaultmargin),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 370,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(agentData["background"] ??
                              "https://media.valorant-api.com/agents/5f8d3a7f-467b-97f3-062c-13acf203c006/background.png"),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: agentData["fullPortrait"],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      agentData["displayName"],
                      style: valorantTextStyle.copyWith(
                        fontSize: 36,
                        fontWeight: medium,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "as " +
                          agentData["developerName"] +
                          " - The " +
                          role["displayName"],
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: light,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      role["description"],
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: light,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Abilities",
                      style: valorantTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: medium,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 40,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (context, index) => SizedBox(
                          width: 15,
                        ),
                        itemBuilder: (context, index) => Tooltip(
                          message: "${abilities[index]["displayName"]}",
                          child: Container(
                            height: 40,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "${abilities[index]["displayIcon"]}"),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      agentData["description"],
                      style: valorantTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: light,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: backgroundColorDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: valorantColor,
      ),
      body: body(),
    );
  }
}
