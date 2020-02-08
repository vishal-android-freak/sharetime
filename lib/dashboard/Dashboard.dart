import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharetime/common/ShowParsedTz.dart';
import 'package:sharetime/meetings/Meetings.dart';
import 'package:sharetime/misc/Misc.dart';
import 'package:sharetime/share_time/TimeSharing.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State {
  @override
  void initState() {
    initUniLinks();
    super.initState();
  }

  Future<Null> initUniLinks() async {
    try {
      String initialLink = await getInitialLink();
      if (initialLink != null) {
        initialLink = initialLink.replaceAll("https://", "");
        List<String> splitLink = initialLink.split('/');
        if (splitLink.length == 3) {
          //eg. https://sharetime.in/IST/1030
          if (splitLink[2] == 'now') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "tz",
                          "tz": splitLink[1],
                          "time": null
                        })));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "tz",
                          "tz": splitLink[1],
                          "time": splitLink[2]
                        })));
          }
        } else if (splitLink.length == 4) {
          //eg. https://sharetime.in/Asia/Kolkata/1030
          if (splitLink[3] == 'now') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "continent",
                          "tz": '${splitLink[1]}/${splitLink[2]}',
                          "time": null
                        })));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "continent",
                          "tz": '${splitLink[1]}/${splitLink[2]}',
                          "time": splitLink[3]
                        })));
          }
        }
      }
    } on PlatformException {}
  }

  int bottomNavBarIndex = 0;

  List<Widget> components = [TimeSharing(), Meetings(), Misc()];

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
          style: const TextStyle(fontFamily: 'Pixel', color: Color(0xff96c6cf)),
        ),
      ),
      body: components[bottomNavBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabChange,
        selectedItemColor: Color(0xff96c6cf),
        currentIndex: bottomNavBarIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/clock.svg',
                height: 20,
                width: 20,
              ),
              title: Text('time')),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/meeting.svg',
                  height: 20, width: 20),
              title: Text('meetings')),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/question.svg',
                  height: 20, width: 20),
              title: Text('how'))
        ],
      ),
    );
  }
}
