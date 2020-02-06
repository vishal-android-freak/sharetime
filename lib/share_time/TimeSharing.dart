import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:sharetime/share_time/TimeZoneList.dart';

class TimeSharing extends StatefulWidget {
  @override
  _TimeSharingState createState() => _TimeSharingState();
}

class _TimeSharingState extends State<TimeSharing> {
  String currentTZ = DateTime.now().timeZoneName;
  String currentTime = DateFormat('HHmm').format(DateTime.now());

  onTimeZoneSelection(tz) {
    setState(() {
      currentTZ = tz;
    });
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
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => TimeZoneList(onTimeZoneSelection: onTimeZoneSelection)
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.purple)),
                          child: Text(
                            '$currentTZ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: 'Pixel'),
                          ),
                        ),
                      ),
                      const Text(
                        '/',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: 'Pixel'),
                      ),
                      InkWell(
                        onTap: () async {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              final now = DateTime.now();
                              currentTime = DateFormat('HHmm').format(DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  time.hour,
                                  time.minute));
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.teal)),
                          child: Text(
                            currentTime,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                fontFamily: 'Pixel'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Share.share('Open the link to check the time in your timezone\n\nhttps://sharetime.in/$currentTZ/$currentTime');
                  },
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
            SizedBox(
              height: 8,
            ),
            const Text(
                'Tap on the boxes above to edit the timezone and time before sharing',
                textAlign: TextAlign.center),
            SizedBox(
              height: 24,
            ),
            RaisedButton(
              elevation: 0,
              onPressed: () {},
              color: Colors.blueAccent,
              child: Text(
                'Add Calendar Event',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
