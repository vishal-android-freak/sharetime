import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart';
import 'package:sharetime/common/timezones.dart';
import 'package:intl/intl.dart';

class NowTz extends StatefulWidget {
  final Map<String, String> tzData;

  NowTz({@required this.tzData});

  @override
  _NowTzState createState() => _NowTzState();
}

class _NowTzState extends State<NowTz> {
  TZDateTime convertedDate;
  String location;
  Location validLoc;
  Timer timer;

  @override
  void initState() {
    var tzType = widget.tzData['type'];
    var tz = widget.tzData['tz'];
    if (tzType == 'tz') {
      var filteredLocation =
          timezones.firstWhere((timezone) => timezone['abbr'] == tz);
      validLoc = getValidLocation(filteredLocation['utc']);
      location = validLoc.name;
    } else {
      try {
        validLoc = getLocation(tz);
        location = tz;
      } catch (error) {
        print(error);
      }
    }
    convertedDate = TZDateTime.from(DateTime.now(), validLoc);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        convertedDate = TZDateTime.from(DateTime.now(), validLoc);
      });
    });
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
        title: Text('Time in $location'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'The time right now',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '${DateFormat('hh:mm:ss a').format(convertedDate)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Pixel', fontSize: 44, color: Color(0xff373e9e)),
            ),
            SizedBox(
              height: 16,
            ),
            const Text(
              'in the timezone',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '$location',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Pixel', fontSize: 30, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
