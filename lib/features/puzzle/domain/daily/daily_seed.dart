/// Daily seed from UTC date + server-controlled salt/version.
/// Never uses the device local clock alone.
int dailySeed({
  required DateTime utcDate,
  required int saltVersion,
  String salt = 'logic42-daily',
}) {
  final day = DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
  final ymd = day.year * 10000 + day.month * 100 + day.day;
  var h = ymd ^ (saltVersion * 10007);
  for (final c in salt.codeUnits) {
    h = 0x1fffffff & (h * 33 + c);
  }
  return h & 0x7fffffff;
}

String dailyPuzzleId(DateTime utcDate) {
  final day = DateTime.utc(utcDate.year, utcDate.month, utcDate.day);
  final mm = day.month.toString().padLeft(2, '0');
  final dd = day.day.toString().padLeft(2, '0');
  return 'daily-${day.year}-$mm-$dd';
}
