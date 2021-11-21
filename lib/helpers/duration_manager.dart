import 'dart:async';

//каждый вызов запускает таймер, и если другой вызов происходит до того, как таймер запускается, таймер сбрасывается и ждет нужное время
class DurationManager {
  Timer? _timer;
  final int milliseconds;
  Function? action;
  DurationManager({required this.milliseconds});

  run(Function a, String s) {
    if (null != _timer) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), a(s));
  }
}