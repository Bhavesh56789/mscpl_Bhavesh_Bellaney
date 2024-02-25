import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/timer_controller.dart';

class TimerWidget extends ConsumerStatefulWidget {
  const TimerWidget({super.key});

  @override
  ConsumerState<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends ConsumerState<TimerWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(timerController.notifier).startTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Text(
        'Verification code expires in ${ref.watch(timerController)}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
