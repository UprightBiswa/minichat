import 'package:intl/intl.dart';

String formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} h ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    return DateFormat('MMM d').format(time);
  }
}
