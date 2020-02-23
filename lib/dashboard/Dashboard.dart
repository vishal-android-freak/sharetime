import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharetime/common/NowTz.dart';
import 'package:sharetime/common/ShowParsedTz.dart';
import 'package:sharetime/meetings/Meetings.dart';
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
        var parsedLink = Uri.parse(initialLink).pathSegments;
        if (parsedLink.length == 2) {
          //eg. https://sharetime.in/IST/1030
          if (parsedLink[1] == 'now') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowTz(tzData: {
                          "type": "tz",
                          "tz": parsedLink[0],
                        })));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "tz",
                          "tz": parsedLink[0],
                          "time": parsedLink[1]
                        })));
          }
        } else if (parsedLink.length == 3) {
          //eg. https://sharetime.in/Asia/Kolkata/1030
          if (parsedLink[2] == 'now') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NowTz(tzData: {
                          "type": "continent",
                          "tz": '${parsedLink[0]}/${parsedLink[1]}',
                        })));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowParsedTz(data: {
                          "type": "continent",
                          "tz": '${parsedLink[0]}/${parsedLink[1]}',
                          "time": parsedLink[2]
                        })));
          }
        }
      }
    } on PlatformException {}
  }

  int bottomNavBarIndex = 0;

  List<Widget> components = [TimeSharing(), Meetings()];

  onTabChange(index) {
    setState(() {
      bottomNavBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/how');
              },
              child: SvgPicture.asset('assets/images/question.svg',
                  height: 24, width: 24),
            ),
            SizedBox(
              width: 10,
            ),
          ],
          brightness: Brightness.dark,
          title: const Text(
            'sharetime',
            style:
                const TextStyle(fontFamily: 'Pixel', color: Color(0xff96c6cf)),
          ),
        ),
        body: components[0]
//      body: components[bottomNavBarIndex],
//      bottomNavigationBar: BottomNavigationBar(
//        onTap: onTabChange,
//        selectedItemColor: Color(0xff96c6cf),
//        currentIndex: bottomNavBarIndex,
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(
//              icon: SvgPicture.asset(
//                'assets/images/clock.svg',
//                height: 20,
//                width: 20,
//              ),
//              title: Text('time')),
//          BottomNavigationBarItem(
//              icon: SvgPicture.asset('assets/images/meeting.svg',
//                  height: 20, width: 20),
//              title: Text('meetings')),
//          BottomNavigationBarItem(
//              icon: SvgPicture.asset('assets/images/question.svg',
//                  height: 20, width: 20),
//              title: Text('how'))
//        ],
//      ),
        );
  }
}
