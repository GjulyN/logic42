abstract class Clock {
  DateTime now();
  DateTime nowUtc();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

class FakeClock implements Clock {
  FakeClock(this._now);
  DateTime _now;

  void setNow(DateTime value) => _now = value;

  void add(Duration d) => _now = _now.add(d);

  @override
  DateTime now() => _now;

  @override
  DateTime nowUtc() => _now.toUtc();
}
