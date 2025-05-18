import 'package:intl/intl.dart';

String FormatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
