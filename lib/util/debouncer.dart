import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  int? millisecond;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.millisecond});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: millisecond as int), action);
  }
}