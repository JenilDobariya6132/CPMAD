import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:billing_app/screens/cart_screen.dart';
import 'package:billing_app/screens/dashboard_screen.dart';
import 'package:billing_app/screens/product_screen.dart';
import 'package:billing_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  List<Widget> screens = [
    DashboardScreen(),
    ProductScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  int currIndx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:screens[currIndx],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currIndx,
      //   onTap: (value){
      //     currIndx = value;
      //     setState((){});
      //   },
      //   items: [
      //   BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //   BottomNavigationBarItem(icon: Icon(Icons.badge), label: "Product"),
      //   BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Cart"),
      //   // BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
      // ]),
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){},
   ),
   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
   bottomNavigationBar: AnimatedBottomNavigationBar(
      icons: [
        Icons.home,
        Icons.badge,
        Icons.shopping_bag,
        Icons.settings
      ],
      activeIndex: currIndx,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: (index) => setState(() => currIndx = index),
      //other params
   ),
    );
  }
}