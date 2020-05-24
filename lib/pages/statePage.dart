import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatePage extends StatefulWidget {
  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  List stateData;
  Map totalData;

  fetchStateData() async {
    http.Response response = await http.get("https://disease.sh/v2/gov/India");
    setState(() {
      stateData = (json.decode(response.body))['states'];
      //stateData['states'].sort((a,b) => a['cases'].compareTo(b['cases']));
      stateData.sort((b, a) {
        return int.parse(a['cases'].toString())
            .compareTo(int.parse(b['cases'].toString()));
      });
    });
  }


  fetchTotalData() async {
    http.Response response =
    await http.get('https://disease.sh/v2/countries/India');
    setState(() {
      totalData = json.decode(response.body);
    });
  }

  Future fetchData() async{
    fetchStateData();
    fetchTotalData();
    print(totalData['cases'].toString());
}

  @override
  void initState() {
    fetchStateData();
    fetchTotalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[600],
      appBar: AppBar(
        title: Text('India Stats'),
      ),
      body:
          RefreshIndicator(
            onRefresh: fetchData,
            child: stateData == null && totalData==null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
              children:<Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  color: Colors.red,
                  child: Center(
                    child:Text('Total Confirmed: '+ totalData['cases'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                Container(
                  height: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  color: Colors.blue,
                  child: Center(
                    child:Text('Total Active: '+ totalData['active'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                Container(
                  height: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  color: Colors.green,
                  child: Center(
                    child:Text('Total Recovered: '+ totalData['recovered'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                Container(
                  height: 30,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  color: Colors.grey,
                  child: Center(
                    child:Text('Total Deaths: '+ totalData['deaths'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                ListView.builder(
                  physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 130,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(color: Colors.amberAccent[900], boxShadow: [
                          BoxShadow(
                              color: Colors.amber,
                              blurRadius: 5,
                              offset: Offset(0, 5)),
                        ]),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    stateData[index]['state'].toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Image.network(
                                    'https://disease.sh/assets/img/flags/in.png',
                                    height: 50,
                                    width: 60,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'CONFIRMED: ' +
                                        stateData[index]['cases'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    'ACTIVE: ' + stateData[index]['active'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    'RECOVERED: ' +
                                        stateData[index]['recovered'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    'DEATHS: ' + stateData[index]['deaths'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800]),
                                  ),
                                ],
                              )),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: stateData == null ? 0 : stateData.length,
                  ),
      ],
            ),
          ),
    );
  }
}
