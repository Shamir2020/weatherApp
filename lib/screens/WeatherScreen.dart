import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import '../style/styles.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherFactory wf = new WeatherFactory('d074b2abe77b5a9a3995e3a365e672fa');
  bool loading = true;
  getLocation() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Map<String,String> weatherInfo = {'temp':"",'areaName':"","country":"",'wind':"",'humidity':"",'pressure':"",'feelslike':''};

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getWeather() async{
    Position location = await getLocation();
    Weather w = await wf.currentWeatherByLocation(location.latitude, location.longitude);


    setState(() {
      weatherInfo['temp'] = w.temperature.toString();
      weatherInfo['country'] = w.country.toString();
      weatherInfo['areaName'] = w.areaName.toString();
      weatherInfo['wind'] = w.windSpeed.toString();
      weatherInfo['humidity'] = w.humidity.toString();
      weatherInfo['pressure'] = w.pressure.toString();
      weatherInfo['feelslike'] = w.tempFeelsLike.toString();
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleLocationPermission();
    getLocation();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Text('Weather App'),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          setState(() {
            loading = true;
          });
          await getLocation();
          setState(() {
            loading = false;
          });
        },
        child: ListView(
          children:[ Center(
            child: loading?CircularProgressIndicator():Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.0,),
                Text('Weather App',style: TextHead4(colorBlack),),
                SizedBox(height: 20.0,),
                Image.asset('images/logo.png'),
                SizedBox(height: 20.0,),
                Text(weatherInfo['temp']!,style: TextHead1(colorBlack),),
                Text(weatherInfo['areaName']!,style: TextHead1(colorBlack),),
                Text(weatherInfo['country']!,style: TextHead1(colorBlack),),
                SizedBox(height: 30.0,),
                Text('Additional Information',style: TextHead1(colorBlack),),
                SizedBox(height: 30.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: width*0.40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Wind',style: TextHead5(colorBlack),),
                            SizedBox(width: width*0.15,),
                            Text(weatherInfo['wind']!,style: TextHead5(colorBlack),),
                          ],
                        ),
                      ),
                      SizedBox(width: width*0.05,),
                      Container(
                        width: width*0.40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Humidity',style: TextHead5(colorBlack),),
                            SizedBox(width: width*0.15,),
                            Text(weatherInfo['humidity']!,style: TextHead5(colorBlack),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        width: width*0.40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pressure',style: TextHead5(colorBlack),),

                            Text(weatherInfo['pressure']!,style: TextHead5(colorBlack),),
                          ],
                        ),
                      ),
                      SizedBox(width: width*0.05,),
                      Container(
                        width: width*0.40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Feels Like',style: TextHead5(colorBlack),),

                            Text(weatherInfo['feelslike']!,style: TextHead5(colorBlack),),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )]
        ),
      )
    );
  }
}
