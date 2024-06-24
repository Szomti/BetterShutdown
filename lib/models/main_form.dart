import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../screen/home/home.dart';
import '../shutdown/shutdown_options.dart';
import 'schedule_type.dart';

class MainForm {
  final homeScreenKey = GlobalKey<HomeScreenState>();
  final SecondsField secondsField = SecondsField();
  final MinutesField minutesField = MinutesField();
  final HoursField hoursField = HoursField();
  final DaysField daysField = DaysField();
  final DateField dateField = DateField();
  final ScrollController scrollController = ScrollController();
  final ShutdownForm shutdownForm = ShutdownForm();
  FieldsType fieldValue = FieldsType.seconds;
  DateTime? shutdownDate;
  int? seconds;
  bool processing = false;

  ScheduleField get currentField {
    return switch (fieldValue) {
      FieldsType.seconds => secondsField,
      FieldsType.minutes => minutesField,
      FieldsType.hours => hoursField,
      FieldsType.days => daysField,
      FieldsType.date => dateField,
    };
  }
}

enum FieldsType {
  seconds._(1, 'Seconds'),
  minutes._(2, 'Minutes'),
  hours._(3, 'Hours'),
  days._(4, 'Days'),
  date._(5, 'Date');

  final int id;
  final String name;

  const FieldsType._(this.id, this.name);

  static FieldsType fromId(int? id) {
    return values.firstWhereOrNull((e) => e.id == id) ?? values.first;
  }
}
