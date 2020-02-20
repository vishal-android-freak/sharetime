import 'package:flutter/material.dart';
import 'package:sharetime/common/timezones.dart';
import 'package:timezone/standalone.dart';
import 'package:intl/intl.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class ShowParsedTz extends StatefulWidget {
  final Map<String, String> data;

  ShowParsedTz({@required this.data});

  @override
  _ShowParsedTzState createState() => _ShowParsedTzState();
}

class _ShowParsedTzState extends State<ShowParsedTz> {
  String parsedTime, location, offset, convertedTime, userTz;
  Location validLoc;
  var userParsedTime;
  List<dynamic> timezonesList = [];
  var tz = '';
  var userTzName = '';
  int selectedTzIndex = 0;
  int selectedUserTzIndex = 0;

  List<dynamic> userTzList = [];

  @override
  void initState() {
    parsedTime = widget.data['time'];
    tz = widget.data['tz'];
    if (widget.data['type'] == 'tz') {
     timezonesList =
          timezones.where((timezone) => timezone['abbr'] == tz).toList();
      validLoc = getValidLocation(timezonesList[0]['utc']);
      location = validLoc.name;
    } else {
      try {
        validLoc = getLocation(tz);
        location = tz;
      } catch (error) {}
    }
    var currentTime = DateTime.now();
    userTzName = currentTime.timeZoneName;
    var tzParsedTime = TZDateTime(
        validLoc,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(parsedTime.substring(0, 2)),
        int.parse(parsedTime.substring(2, 4)));
    userTzList = timezones.where((timezone) =>
    timezone['abbr'] == userTzName).toList();
    userParsedTime = TZDateTime.from(
        tzParsedTime,
        getValidLocation(userTzList[0]['utc']));
    userTz = userTzList[0]['utc'][0];
    convertedTime = DateFormat('hh:mm:ss a').format(userParsedTime);
    super.initState();
  }

  onTimezoneChange(index) {
    validLoc = getValidLocation(timezonesList[index]['utc']);
    var currentTime = DateTime.now();
    var tzParsedTime = TZDateTime(
        validLoc,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(parsedTime.substring(0, 2)),
        int.parse(parsedTime.substring(2, 4)));
    userParsedTime = TZDateTime.from(
        tzParsedTime,
        getValidLocation(userTzList[selectedUserTzIndex]['utc']));
    setState(() {
      selectedTzIndex = index;
      location = validLoc.name;
      userTz = userTzList[selectedUserTzIndex]['utc'][0];
      convertedTime = DateFormat('hh:mm:ss a').format(userParsedTime);
    });
  }

  onUserTimeZoneChange(index) {
    validLoc = getValidLocation(timezonesList[selectedTzIndex]['utc']);
    var currentTime = DateTime.now();
    var tzParsedTime = TZDateTime(
        validLoc,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(parsedTime.substring(0, 2)),
        int.parse(parsedTime.substring(2, 4)));
    userParsedTime = TZDateTime.from(
        tzParsedTime,
        getValidLocation(userTzList[index]['utc']));
    setState(() {
      selectedUserTzIndex = index;
      location = validLoc.name;
      userTz = userTzList[index]['utc'][0];
      convertedTime = DateFormat('hh:mm:ss a').format(userParsedTime);
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
      appBar: AppBar(
        title: const Text('Your time'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          position, selectedTzIndex, onTimezoneChange);
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
              userTzList.length > 1 ? Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'and also your timezone ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'CabinSketch',
                                fontSize: 20
                            )
                        ),
                        TextSpan(
                            text: '$userTzName ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontFamily: 'CabinSketch',
                                fontSize: 20
                            )
                        ),
                        TextSpan(
                            text: 'means more than one timezone\n\nPlease select one',
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
              userTzList.length > 1
                  ? Flexible(
                child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: userTzList.length,
                    itemBuilder: (context, position) {
                      return timeZoneCard(userTzList[position],
                          position, selectedUserTzIndex, onUserTimeZoneChange);
                    }),
              )
                  : Container(
                width: 0,
                height: 0,
              ),
              userTzList.length > 1
                  ? SizedBox(
                height: 24,
              )
                  : SizedBox(
                height: 0,
              ),
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Pixel', fontSize: 44, color: Colors.deepPurple),
              ),
              SizedBox(
                height: 32,
              ),
              RaisedButton(
                elevation: 0,
                onPressed: () {
                  final Event event = Event(
                      title: 'Event title',
                      description: 'Event description',
                      location: 'Event location',
                      startDate: userParsedTime,
                      endDate: userParsedTime
                  );
                  Add2Calendar.addEvent2Cal(event);
                },
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
      ),
    );
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
