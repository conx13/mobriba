import 'dart:async';

class Debouncer {
  final Duration delay;
  late Timer _timer = Timer(Duration(milliseconds: 1000), () {});

  Debouncer({required this.delay});

  run(void Function() tegevus) {
    _timer.cancel();
    _timer = Timer(delay, tegevus);
  }
}
