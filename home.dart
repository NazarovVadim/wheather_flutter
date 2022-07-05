import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

String temperatureUnit = '°',
  humidityUnit = '%',
  pressureUnit = ' mmHg',
  windUnit = ' m/s';


// String getDescription(data) {
//   String desc = data[0]["weather"][0]["description"];
//   return desc;
// }
//
// String getCurrentTemp(data){
//   double temp = data[0]["main"]["temp"];
//   int convertTemp = temp.toInt() - 273;
//   String res = convertTemp.toString() + temperatureUnit;
//   return res;
// }

String getForecastHours(data, index){
  //int dt = data[index]["dt"];
  int? date = DateTime.now().hour;
  date = date+1;
  date = (date + 3*(index+1)) as int?;
  if(date!>=24){
    int r = date - 24;
    date = 0 + r;
  }
  String result = date < 10 ? '0$date:00' : '$date:00';
  return result;

}
String getForecastTemp(data, index){
  double temp = data[index+1]["main"]["temp"];
  int convertTemp = temp.toInt() - 273;
  String res = convertTemp.toString() + temperatureUnit;
  return res;

}
// String getFeelsLike(data){
//   double temp = data[0]["main"]["feels_like"];
//   int convertTemp = temp.toInt() - 273;
//   String res = convertTemp.toString() + temperatureUnit;
//   return res;
// }
// String getPressure(data){
//   int temp = data[0]["main"]["pressure"];
//   String res = temp.toString() + pressureUnit;
//   return res;
// }
// String getHumidity(data){
//   int hum = data[0]["main"]["humidity"];
//   String res = hum.toString() + humidityUnit;
//   return res;
// }
// String getWindSpeed(data){
//   double velocity = data[0]["wind"]["speed"];
//   String res = velocity.toString()+windUnit;
//   return res;

//}

Future<Wheather> fetchWheather() async {
  final response = await http
      .get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?id=498817&appid=e163b8b661bc14e09841495637e2ba12'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Wheather.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load wheather');
  }
}

class Wheather {
  final String description;
  final double currentTemp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double windSpeed;

  const Wheather({
    required this.description,
    required this.currentTemp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.windSpeed
  });

  factory Wheather.fromJson(Map<String, dynamic> json){
    return Wheather(
      description: json['list'][0]['weather'][0]['description'],
      currentTemp: json['list'][0]['main']['temp'],
      feelsLike: json['list'][0]['main']['feels_like'],
      pressure: json['list'][0]['main']['pressure'],
      humidity: json['list'][0]['main']['humidity'],
      windSpeed: json['list'][0]['wind']['speed']

    );
  }

}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<Wheather> futureWheather;

  @override
  void initState(){
    super.initState();
    futureWheather = fetchWheather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text('Saint-Petersburg', style: TextStyle(fontSize: 32),),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder<Wheather>(
            future: futureWheather,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return SingleChildScrollView(
                  child: Column(

                    children: [
                      Text(
                        snapshot.data!.description,
                        style: const TextStyle(color: Colors.white, fontSize: 26),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        '${snapshot.data!.currentTemp.toInt()-273}$temperatureUnit',
                        style: const TextStyle(color: Colors.white, fontSize: 64),
                      ),

                     ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index){
                            return Column(

                            );
                          },
                        ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Feels like:', style: TextStyle(color: Colors.white, fontSize: 28),),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: Text(
                                      '${snapshot.data!.feelsLike.toInt()-273}$temperatureUnit',
                                      style: const TextStyle(color: Colors.white, fontSize: 32),
                                    )
                                ),
                                const Padding(padding: EdgeInsets.only(top: 30)),
                                const Text('HUM:', style: TextStyle(color: Colors.white, fontSize: 28),),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: Text(
                                      '${snapshot.data!.humidity}$humidityUnit',
                                      style: const TextStyle(color: Colors.white, fontSize: 32),
                                    )
                                ),
                              ]
                          ),


                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pressure:', style: TextStyle(color: Colors.white, fontSize: 28),),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: Text(
                                      '${snapshot.data!.pressure}$pressureUnit',
                                      style: const TextStyle(color: Colors.white, fontSize: 32),
                                    )
                                ),
                                const Padding(padding: EdgeInsets.only(top: 30)),
                                const Text('Wind:', style: TextStyle(color: Colors.white, fontSize: 28),),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                    child: Text(
                                      '${snapshot.data!.windSpeed}$windUnit',
                                      style: const TextStyle(color: Colors.white, fontSize: 32),
                                    )
                                ),
                              ]
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      )

    );
  }
}
