import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';

class Home4 extends StatefulWidget {
  const Home4({super.key});
  String get getTitle => "Home 4";
  @override
  State<Home4> createState() => _Home4State();
}

class _Home4State extends State<Home4> {
  final ScreenController screenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              screenController.goBackAt(AppPage.HomeScreen);
            },
            child: Icon(
              Icons.arrow_back,
            )),
        title: Text('Home Screen 4'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              // Obx(() {
              //   return ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: screenController.stack.length,
              //     itemBuilder: (context, index) {
              //       Widget currentWidget = screenController.stack[index];
              //       //   String title = currentWidget.title; // Replace this with the actual title of your widgets
              //
              //       // Use the ListTile widget to display the title and arrow icon
              //       return ListTile(
              //         title: Text(title),
              //         trailing: Icon(Icons.arrow_forward),
              //         onTap: () {
              //           // Handle tap on the widget (if needed)
              //         },
              //       );
              //     },
              //   );
              // }),
              GestureDetector(
                  onTap: () {
                    print('should=to home 2');
                    // screenController.updatePageAt(AppPage.HomeScreen, Home4());
                  },
                  child: Text(
                    'Go to Home 1',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
