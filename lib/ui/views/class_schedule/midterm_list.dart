import 'package:campus_mobile_experimental/core/data_providers/class_schedule_data_provider.dart';
import 'package:campus_mobile_experimental/core/models/class_schedule_model.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/container_view.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/time_range_widget.dart';
import 'package:campus_mobile_experimental/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class MidtermList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<SectionData> midtermData =
        Provider.of<ClassScheduleDataProvider>(context).midterms;
    return ContainerView(
      child: buildMidtermsSchedule(midtermData, context),
    );
  }

  String abbrevToFullWeekday(String abbreviation) {
    switch (abbreviation) {
      case 'MO':
        return 'Monday';
      case 'TU':
        return 'Tuesday';
      case 'WE':
        return 'Wednesday';
      case 'TH':
        return 'Thursday';
      case 'FR':
        return 'Friday';
      case 'SA':
        return 'Saturday';
      case 'SU':
        return 'Sunday';
      case 'Other':
        return 'Other';
      default:
        return 'Other';
    }
  }

  Widget buildMidtermsSchedule(
      List<SectionData> midtermData, BuildContext context) {
    List<Widget> listToReturn = List<Widget>();

    for (SectionData data in midtermData) {
      listToReturn.add(ListTile(
        title: buildClassTitle(
            data.subjectCode + ' ' + data.courseCode, data.courseTitle),
        subtitle: Column(
          children: [
            buildDateRow(data.days, data.date),
            buildTimeRow(data.time),
            buildLocationRow(data.building + ' ' + data.room),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));
    }
    listToReturn =
        ListTile.divideTiles(tiles: listToReturn, context: context).toList();
    listToReturn.add(
      Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      ),
    );
    return ListView(
      // TODO: Resolve #709
      // Re-enable scrolling if content overflows space
//        physics: NeverScrollableScrollPhysics(),
      children: listToReturn,
    );
  }

  String formatDate(String date) {
    String month = date.substring(5, 7);
    String day = date.substring(8);
    switch (month) {
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "June";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }

    return month + " " + day;
  }

  Widget buildDateRow(String day, String date) {
    String weekday = abbrevToFullWeekday(day);
    String monthDate = formatDate(date);

    return Text(weekday + "," + monthDate);
  }

  Widget buildClassTitle(String title, String courseName) {
    return Text(title + ": " + courseName);
  }

  Widget buildTimeRow(String time) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TimeRangeWidget(
                time: time,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLocationRow(String location) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(location),
            ],
          ),
        ),
      ],
    );
  }
}
