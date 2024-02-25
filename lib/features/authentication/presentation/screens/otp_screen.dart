import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/login_controller.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/state/auth_state.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/timer_controller.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/presentation/widgets/otp_pin_widget.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/presentation/widgets/timer_widget.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  static const String name = 'otp-screen';

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  @override
  void dispose() {
    ref.invalidate(timerController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_outlined),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Verify your phone',
              style: Theme.of(context).textTheme.headline1?.copyWith(
                    color: const Color(0xFF101828),
                  ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Text.rich(
              TextSpan(
                text: 'Enter the verification code sent to',
                children: [
                  TextSpan(
                    text:
                        '\n(9**)***-**${ref.read(mobileNumberTextEditingController).text.split('').getRange(8, 10).join('')}',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF101828),
                        ),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    fontSize: 16,
                    color: const Color(0xFF101828),
                  ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const OtpPinWidget(
            otpLength: 6,
          ),
          Consumer(builder: (context, ref, child) {
            return Visibility(
              visible: [AuthState.notverified, AuthState.failure]
                  .contains(ref.watch(loginController)),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: const TimerWidget(),
              ),
            );
          }),
          const SizedBox(
            height: 10,
          ),
          const Spacer(),
          Consumer(builder: (context, ref, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: ref.watch(enableResendButton)
                    ? () {
                        if (ref
                                .read(timerController.notifier)
                                .numberOfRetries ==
                            0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Maximum number of retries reached'),
                            ),
                          );
                        } else {
                          ref.read(timerController.notifier).startTimer();
                        }
                      }
                    : null,
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.white;
                  }),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFDDE2EB),
                      ),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Resend Code',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 16,
                          color: const Color(0xFF0D1D33),
                        ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFFDDE2EB),
                    ),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  'Change Number',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF0D1D33),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
