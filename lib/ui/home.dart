import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather/models/Weather_result.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';
import 'package:weather/network/open_weather_map_client.dart';
import '../state/state.dart';
import '../widget/forecast_tile_widget.dart';
import '../widget/info_widget.dart';
import '../widget/weather_tile_widget.dart';

class Home extends StatefulWidget {
  final String title;
  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(MyStateController());
  var location = Location();
  late StreamSubscription listener;
  late PermissionStatus permissionStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async{
      await enableLocationListener();
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();

  }

  Future<void> enableLocationListener() async{
    controller.isEnableLocation.value = await location.serviceEnabled();
    if(!controller.isEnableLocation.value){
      controller.isEnableLocation.value = await location.requestService();
      if(!controller.isEnableLocation.value){
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await location.requestPermission();
      if(permissionStatus != PermissionStatus.granted){
        return;
      }
    }

    controller.locationData.value = await location.getLocation();
    listener = location.onLocationChanged.listen((event) {

    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Constants().primaryColor));
    Constants myConstants = Constants();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SafeArea(
        child: Obx(() => Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      tileMode: TileMode.clamp,
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                      colors: [
                    myConstants.primaryColor,
                    myConstants.sencondaryColor
                  ])),
              child: controller.locationData.value.latitude != null ? 
                  FutureBuilder(
                      future: OpenWeatherMapClient().getWeather(controller.locationData.value),
                      builder: (context,snapshot){
                   if(snapshot.connectionState == ConnectionState.waiting){
                     return const Center(
                       child: CircularProgressIndicator(color: Colors.white,),
                     );
                   }else if(snapshot.hasError){
                     return Center(
                       child: Text(snapshot.error!.toString(),style: TextStyle(color: Colors.red),),
                     );
                   }else if(!snapshot.hasData){
                     return const Center(child: Text('No Data',style: TextStyle(color: Colors.white),),);
                   }else{
                     var data = snapshot.data as WeatherResult;
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         SizedBox(
                           height: size.height / 20,
                         ),
                         WeatherTileWidget(
                           context: context,
                           title: (data.name != null && data.name!.isNotEmpty)?
                               data.name: '${data.coord?.lat}/${data.coord?.lon}'
                           ,
                           titleFontSize: 30.0,
                           subTitle: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                         ),
                         Center(
                             child: CachedNetworkImage(
                               imageUrl: 'https://openweathermap.org/img/wn/11d@4x.png',
                               height: 200,
                               width: 200,
                               fit: BoxFit.fill,
                               progressIndicatorBuilder:
                                   (context, url, downloadProgress) =>
                               const CircularProgressIndicator(),
                               errorWidget: (context, url, err) => const Icon(
                                 Icons.image,
                                 color: Colors.white,
                               ),
                             )),
                         WeatherTileWidget(
                           context: context,
                           title: '28°C',
                           titleFontSize: 60.0,
                           subTitle: 'Light Rain',
                         ),
                         const SizedBox(
                           height: 30,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             SizedBox(
                               width: size.width / 8,
                             ),
                             InfoWidget(icon: FontAwesomeIcons.wind, text: '10'),
                             InfoWidget(icon: FontAwesomeIcons.cloud, text: '10'),
                             InfoWidget(icon: FontAwesomeIcons.snowflake, text: '10'),
                             SizedBox(
                               width: size.width / 8,
                             ),
                           ],
                         ),
                         const SizedBox(
                           height: 30,
                         ),
                         Expanded(
                             child: ListView(
                               scrollDirection: Axis.horizontal,
                               children: [
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                                 ForeCastTileWidget(
                                   temp: '28°C',
                                   time: '15:00',
                                 ),
                               ],
                             ))
                       ],
                     );
                   }
                  })
                  : const Center(
                child: Text('Waiting.. ', style: TextStyle(color: Colors.white),),
              ) ,
            )),
      ),
    );
  }

}
