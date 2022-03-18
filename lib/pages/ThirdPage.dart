// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:valo_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThirdPage extends StatelessWidget {
  late Map<String, dynamic> apiInfo;

  Future getApiInfo() async {
    try {
      var response = await http.get(
        Uri.parse("https://valorant-api.com/v1/version"),
      );
      Map<String, dynamic> data =
          (json.decode(response.body) as Map<String, dynamic>)["data"];
      apiInfo = data;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultmargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The data in this application is taken from the API",
            style: valorantTextStyle.copyWith(
              fontWeight: medium,
              fontSize: 32,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Data Version",
            style: valorantTextStyle.copyWith(
              fontSize: 20,
              fontWeight: medium,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: getApiInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Fetching Data",
                    style: whiteTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: medium,
                    ),
                  ),
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoText(
                    title: "manifestId",
                    value: apiInfo["manifestId"],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InfoText(
                    title: "branch",
                    value: apiInfo["branch"],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InfoText(
                    title: "version",
                    value: apiInfo["version"],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InfoText(
                    title: "buildVersion",
                    value: apiInfo["buildVersion"],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InfoText(
                    title: "buildDate",
                    value: apiInfo["buildDate"],
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InfoText(
                    title: "riotClientVersion",
                    value: ((apiInfo["riotClientVersion"]).toString())
                        .substring(14),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final title;
  final value;

  InfoText({
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: whiteTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 14,
          ),
        ),
        Text(
          value ?? "Error",
          style: whiteTextStyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
        ),
      ],
    );
  }
}
