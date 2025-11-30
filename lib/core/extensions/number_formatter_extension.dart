import 'package:intl/intl.dart';

extension NumberFormatterExtension on int {
  String toDownloadCountString() {
    final String formattedDownloadCount = NumberFormat.decimalPattern().format(this);

    return this > 1 ? '$formattedDownloadCount times' : '$formattedDownloadCount time';
  }
}
