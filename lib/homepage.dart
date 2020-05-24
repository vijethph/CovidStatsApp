import 'dart:convert';

import 'package:covid_stats_app/pages/statePage.dart';
import 'package:covid_stats_app/panels/infoPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:covid_stats_app/datasource.dart';
import 'package:covid_stats_app/panels/mostaffectedcountries.dart';
import 'package:covid_stats_app/panels/worldwidepanel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldwideData() async {
    http.Response response = await http.get("https://disease.sh/v2/all");
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get("https://disease.sh/v2/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldwideData();
    fetchCountryData();
  }

  @override
  void initState() {
    fetchWorldwideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[600],
        appBar: AppBar(
          title: Text(
            'COVID-19 STATISTICS',
          ),
        ),
        body: RefreshIndicator(
          onRefresh: fetchData,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                    margin: EdgeInsets.all(10),
                    height: 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    color: Colors.orange[100],
                    child: Text(
                      DataSource.quote,
                      style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Worldwide',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StatePage()));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: primaryBlack,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Regional',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ),
                worldData == null
                    ? CircularProgressIndicator()
                    : WorldwidePanel(
                        worldData: worldData,
                      ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Most Affected Countries',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                countryData == null
                    ? Container()
                    : MostAffectedPanel(
                        countryData: countryData,
                      ),
                InfoPanel(),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  'STAY HOME, STAY SAFE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
                SizedBox(
                  height: 50,
                )
              ])),
        ));
  }
}
