import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharetime/common/timezones.dart';
import 'package:intl/intl.dart';

class TimeSharing extends StatefulWidget {
  @override
  _TimeSharingState createState() => _TimeSharingState();
}

class _TimeSharingState extends State<TimeSharing> {
  String currentTZ = DateTime.now().timeZoneName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/big_clock.svg',
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                'Share the URL with your friend and they will see the time in their timezone',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  height: 50,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'sharetime.in/',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: 'Pixel'),
                      ),
                      Text(
                        '$currentTZ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: 'Pixel'),
                      ),
                      const Text(
                        '/',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: 'Pixel'),
                      ),
                      Container(
                        child: Text(
                          '${DateFormat('HHmm').format(DateTime.now())}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              fontFamily: 'Pixel'),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.teal,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/share.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
