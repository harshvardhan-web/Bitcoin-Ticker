import 'dart:io';

import 'package:bitcoin_ticker/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'data.dart';

void main() {
  runApp(const MyApp());
}

const apiKey = "D71B0C89-7ED0-47BB-97EC-D092EDD27D8A";

var price;
String cryp = "BTC", curr = "USD";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: TickerHome(),
        ),
      ),
    );
  }
}

class TickerHome extends StatefulWidget {
  const TickerHome({Key? key}) : super(key: key);

  @override
  State<TickerHome> createState() => _TickerHomeState();
}

class _TickerHomeState extends State<TickerHome> {

  @override void initState(){
    super.initState();
    setState((){
      getData();
    });
  }

  List<DropdownButton<String>> androidDropdown(){
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in curreny){
      var newItem = DropdownMenuItem(child: Text(currency), value: currency,);
      dropdownItems.add(newItem);
    }

    List<DropdownButton<String>> db = [];

     db.add(DropdownButton<String>(
      value: curr,
      items: dropdownItems,
      onChanged: (value){
        setState((){
          curr = value as String;
          getData();
        });
      },
    ));

    List<DropdownMenuItem<String>> dropdownItems2 = [];
    for(String crypto in crypto){
      var newItem = DropdownMenuItem(child: Text(crypto), value: crypto,);
      dropdownItems2.add(newItem);
    }

    db.add(DropdownButton<String>(
      value: cryp,
      items: dropdownItems2,
      onChanged: (value){
        setState((){
          cryp = value as String;
          getData();
        });
      },
    )
    );
    return db;
  }

  List<CupertinoPicker> iosPicker(){
    List<Text> pickerItems = [], pickerItems2 = [];
    for(String currency in curreny){
      pickerItems.add(Text(currency));
    }
    for(String crypto in crypto){
      pickerItems2.add(Text(crypto));
    }

    List<CupertinoPicker> cp = [];

    cp.add(
        CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (selectedIndex){
              setState((){
                curr = curreny[selectedIndex];
                getData();
              });
              },
            children: pickerItems)
        );
    cp.add(
        CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (selectedIndex){
              setState((){
                cryp = crypto[selectedIndex];
                getData();
              });
            },
            children: pickerItems2)
    );

    return cp;
  }

  void getData() async{
    // DateTime now = DateTime.now().toUtc();
    // String time = (now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString()+"T"+now.hour.toString()+":"+now.minute.toString()+":"+now.second.toString()+"."+now.microsecond.toString());
    var url  = Uri.https("rest.coinapi.io", "/v1/exchangerate/$cryp/$curr",{"apikey":apiKey},);
    print(url);
    var response = await http.get(url,headers: {"x-coinapi-key" : apiKey});
    print(response.body);
    if(response.statusCode==200){
      var res = convert.jsonDecode(response.body);
      setState((){
        price = res["rate"].toStringAsFixed(2);
      });
    }else{
      print("An error occurred with code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CupertinoPicker> iosElements = iosPicker();
    List<DropdownButton<String>> androidElements = androidDropdown();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent, title: Center(child: Text("Bitcoin Ticker")),),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: TextButton(
                child: Text(""),
                onPressed: (){
                  getData();
                },
              ),
            ),
            Container(
              child: Text("1 $cryp = $price $curr",style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.lightBlue,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (){
                      getData();
                    },
                    child: Platform.isIOS ? iosElements[0] :androidElements[0]
                ),
                TextButton(
                    onPressed: (){
                      getData();
                    },
                    child: Platform.isIOS ? iosElements[1] :androidElements[1]
                )
              ],
            ),
          ],
        ),

      ),
    );
  }
}

