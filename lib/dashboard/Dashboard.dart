import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharetime/meetings/Meetings.dart';
import 'package:sharetime/misc/Misc.dart';
import 'package:sharetime/share_time/TimeSharing.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State {

  int bottomNavBarIndex = 0;

  List<Widget> components = [
    TimeSharing(),
    Meetings(),
    Misc()
  ];

  onTabChange(index) {
    setState(() {
      bottomNavBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text(
          'sharetime',
          style: const TextStyle(
            fontFamily: 'Pixel',
            color: Color(0xff96c6cf)
          ),
        ),
      ),
      body: components[bottomNavBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabChange,
        selectedItemColor: Color(0xff96c6cf),
        currentIndex: bottomNavBarIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/images/clock.svg', height: 20, width: 20,),
            title: Text('time')
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/meeting.svg', height: 20, width: 20),
              title: Text('meetings')
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/question.svg', height: 20, width: 20),
              title: Text('how')
          )
        ],
      ),
    );
  }
}
