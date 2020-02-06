import 'package:flutter/material.dart';
import 'package:sharetime/common/timezones.dart';

class TimeZoneList extends StatelessWidget {

  final Function onTimeZoneSelection;

  TimeZoneList({this.onTimeZoneSelection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Timezones'),
      ),
      body: ListView.builder(
        itemCount: timezones.length,
        itemBuilder: (context, position) {
          return InkWell(
            onTap: () {
              onTimeZoneSelection(timezones[position]['abbr']);
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${timezones[position]['value']} (${timezones[position]['abbr']})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.teal,
                      fontSize: 18
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    timezones[position]['text']
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}