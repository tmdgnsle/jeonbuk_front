import 'package:flutter/material.dart';
import 'package:jeonbuk_front/components/app_navigation_bar.dart';
import 'package:jeonbuk_front/screen/add_safe_screen.dart';

class SafeHomeScreen extends StatelessWidget {
  const SafeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('안심귀가'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSafeScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Container(),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
