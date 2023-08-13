import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList.where((city) => city.isDefault == false).toList();
    List<City> selectedCities = City.getSelectedCities();
    Constants myConstant = Constants();
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myConstant.sencondaryColor,
        title:Text('${selectedCities.length} selected'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(left: 10,top: 20, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: size.height * .08,
            width: size.width,
            decoration: BoxDecoration(
              border: cities[index].isSelected==true? Border.all(
                color: myConstant.sencondaryColor.withOpacity(.6),
                width: 2,
              ): Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: myConstant.primaryColor.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Row(
              children: [
                Image.asset(
                  cities[index].isSelected == true
                      ? 'assets/checked.png'
                      : 'assets/unchecked.png',
                  width: 30,
                ),
                const SizedBox(width: 10,),
                Text(cities[index].city,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: cities[index].isSelected == true ? myConstant.primaryColor : Colors.black54
                ),)
              ],
            ),
          );
        },

      ),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: myConstant.sencondaryColor,
        child: const Icon(Icons.pin_drop),
        onPressed: (){
          print(selectedCities);
          // Fluttertoast.showToast(
          //     msg: "$selectedCities",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
        },
      ),
    );
  }
}
