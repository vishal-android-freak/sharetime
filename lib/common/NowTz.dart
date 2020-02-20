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

  int selectedIndex = 0;

  List<dynamic> timezonesList = [];
  var tz = '';

  @override
  void initState() {
    var tzType = widget.tzData['type'];
    tz = widget.tzData['tz'];
    if (tzType == 'tz') {
      timezonesList =
          timezones.where((timezone) => timezone['abbr'] == tz).toList();
      validLoc = getValidLocation(timezonesList[0]['utc']);
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

  onTimezoneChange(index) {
    validLoc = getValidLocation(timezonesList[index]['utc']);
    setState(() {
      selectedIndex = index;
      location = validLoc.name;
      convertedDate = TZDateTime.from(DateTime.now(), validLoc);
    });
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Time in $location'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              timezonesList.length > 1 ? Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Uh oh! ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'CabinSketch',
                          fontSize: 20
                        )
                      ),
                      TextSpan(
                        text: '$tz ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'CabinSketch',
                            fontSize: 20
                        )
                      ),
                      TextSpan(
                        text: 'means more than one timezone\n\nWhat it might stand for?',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'CabinSketch',
                            fontSize: 20
                        )
                      )
                    ]
                  ),
                  textAlign: TextAlign.center,
                ),
              ): Text(''),
              timezonesList.length > 1
                  ? Flexible(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: timezonesList.length,
                          itemBuilder: (context, position) {
                            return timeZoneCard(timezonesList[position],
                                position, selectedIndex, onTimezoneChange);
                          }),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              timezonesList.length > 1
                  ? SizedBox(
                      height: 24,
                    )
                  : SizedBox(
                      height: 0,
                    ),
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
                    fontFamily: 'Pixel',
                    fontSize: 44,
                    color: Color(0xff373e9e)),
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
                    fontFamily: 'Pixel',
                    fontSize: 30,
                    color: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget timeZoneCard(dynamic data, index, selectedIndex, onTimezoneChange) {
    return InkWell(
      onTap: () {
        onTimezoneChange(index);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: index == selectedIndex
              ? BorderSide(color: Colors.deepPurple, width: 2)
              : BorderSide.none,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                data['value'],
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                data['text'],
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
