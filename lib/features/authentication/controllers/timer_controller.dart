import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/login_controller.dart';

final timerController = StateNotifierProvider<TimerController, String>(
    (ref) => TimerController(ref));

class TimerController extends StateNotifier<String> {
  TimerController(this.providerRef) : super(formatSecond());
  StateNotifierProviderRef<TimerController, String> providerRef;

  static int start = 170;
  late Timer timer;
  int numberOfRetries = 5;

  cancelTimer() {
    if (timer.isActive) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  static String formatSecond() {
    int minutes = start ~/ 60;
    int remainingSeconds = start % 60;

    String minutesString = minutes.toString().padLeft(2, '0');
    String secondsString = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesString:$secondsString';
  }

  void startTimer() {
    providerRef.read(enableResendButton.notifier).update(
          (state) => false,
        );
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start < 1) {
        timer.cancel();
        providerRef.read(enableResendButton.notifier).update(
              (state) => true,
            );
        start = 170;
        numberOfRetries--;
      } else {
        start--;
        state = formatSecond();
      }
    });
  }
}
