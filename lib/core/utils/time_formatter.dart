import 'package:intl/intl.dart';

String formatTime(DateTime time) {
  return DateFormat('HH:mm').format(time);
}
