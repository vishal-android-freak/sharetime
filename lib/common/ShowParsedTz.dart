import 'package:flutter/material.dart';
import 'package:sharetime/common/timezones.dart';
import 'package:timezone/standalone.dart';
import 'package:intl/intl.dart';

class ShowParsedTz extends StatefulWidget {
  final Map<String, String> data;

  ShowParsedTz({@required this.data});

  @override
  _ShowParsedTzState createState() => _ShowParsedTzState();
}

class _ShowParsedTzState extends State<ShowParsedTz> {
  String parsedTime, location, offset, convertedTime, userTz;
  var filteredLocation;
  Location validLoc;

  @override
  void initState() {
    parsedTime = widget.data['time'];
    var tz = widget.data['tz'];
    if (widget.data['type'] == 'tz') {
      filteredLocation =
          timezones.firstWhere((timezone) => timezone['abbr'] == tz);
      validLoc = getValidLocation(filteredLocation['utc']);
      location = validLoc.name;
    } else {
      try {
        validLoc = getLocation(tz);
        location = tz;
      } catch (error) {}
    }
    var currentTime = DateTime.now();
    var tzParsedTime = TZDateTime(
        validLoc,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(parsedTime.substring(0, 2)),
        int.parse(parsedTime.substring(2, 4)));
    var userTZData = timezones.firstWhere((timezone) =>
    timezone['abbr'] == currentTime.timeZoneName)['utc'];
    var userParsedTime = TZDateTime.from(
        tzParsedTime,
        getValidLocation(userTZData));
    userTz = userTZData[0];
    convertedTime = DateFormat('hh:mm:ss a').format(userParsedTime);
    super.initState();
  }

  Location getValidLocation(List<String> locations) {
    String validLocation = locations.firstWhere((location) {
      try {
        getLocation(location);
        return true;
      } catch (exception) {
        return false;
      }
    });
    return getLocation(validLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your time'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Time as provided ',
              style: const TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '$parsedTime',
              style: const TextStyle(
                  fontFamily: 'Pixel', fontSize: 44, color: Color(0xff373e9e)),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'in ',
                  style: const TextStyle(fontSize: 22),
                ),
                Text(
                  '$location',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
                const Text(
                  ' is',
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              '$convertedTime',
              style: const TextStyle(
                  fontFamily: 'Pixel', fontSize: 44, color: Colors.teal),
            ),
            SizedBox(
              height: 24,
            ),
            const Text(
              'in your local timezone',
              style: const TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '$userTz',
              style: const TextStyle(
                  fontFamily: 'Pixel', fontSize: 44, color: Colors.deepPurple),
            ),
            SizedBox(
              height: 32,
            ),
            RaisedButton(
              elevation: 0,
              onPressed: () {},
              color: Colors.blueAccent,
              child: Text(
                'Add Calendar Event',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900),
              ),
            )
          ],
        ),
      ),
    );
  }
}
