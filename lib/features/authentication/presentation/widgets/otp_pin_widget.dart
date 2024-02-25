import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/login_controller.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/state/auth_state.dart';

class OtpPinWidget extends ConsumerStatefulWidget {
  const OtpPinWidget({this.otpLength = 6, super.key});

  final int otpLength;

  @override
  ConsumerState<OtpPinWidget> createState() => _OtpPinWidgetState();
}

class _OtpPinWidgetState extends ConsumerState<OtpPinWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(
      widget.otpLength,
      (index) => FocusNode(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (index > 0 && _controllers[index].text.isEmpty) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              return KeyEventResult.handled;
            } else {
              return KeyEventResult.ignored;
            }
          }
          return KeyEventResult.ignored;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(loginController);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: authStatus == AuthState.verified ? 15 : 5,
      ),
      width: double.infinity,
      decoration: authStatus != AuthState.notverified
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: authStatus == AuthState.verified
                  ? Colors.green
                  : const Color(0xFFEA5959),
            )
          : null,
      child: Column(
        children: [
          Wrap(
            children: List.generate(
              widget.otpLength,
              (index) => Container(
                margin: const EdgeInsets.only(right: 8),
                width: (MediaQuery.of(context).size.width - 50 - 48) / 6,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  // maxLength: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    counter: const SizedBox.shrink(),
                    fillColor: authStatus == AuthState.notverified
                        ? const Color(0xFFF2F4F7)
                        : Colors.white,
                    filled: true,
                    errorMaxLines: 0,
                  ),
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTap: () => _controllers[index]
                    ..selection = TextSelection.fromPosition(
                        TextPosition(offset: _controllers[index].text.length)),
                  onChanged: (value) {
                    if (value.length > 1 && RegExp(r'[\d]').hasMatch(value)) {
                      int i = 0;
                      int start = index;
                      while (start < _controllers.length &&
                          start != value.length + index) {
                        if (i < _controllers.length) {
                          _controllers[start].text = value[i];
                          i++;
                          start++;
                        }
                      }
                      if (_controllers.length == start) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        ref
                            .read(loginController.notifier)
                            .verifyOtp(_controllers.map((e) => e.text).join());
                      } else {
                        FocusScope.of(context).requestFocus(_focusNodes[start]);
                      }
                      return;
                    }
                    if (value.length == 1 && index < 5) {
                      FocusScope.of(context)
                          .requestFocus(_focusNodes[index + 1]);
                    }
                    if (value.length == 1 && index == 5) {
                      ref
                          .read(loginController.notifier)
                          .verifyOtp(_controllers.map((e) => e.text).join());
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: authStatus != AuthState.notverified,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  authStatus == AuthState.verified ? Icons.check : Icons.cancel,
                  color: authStatus == AuthState.verified
                      ? Colors.white
                      : const Color(0xFFEA5959),
                ),
                Text(
                  authStatus == AuthState.verified ? 'Verified' : 'Invalid OTP',
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                        color: Colors.white,
                      ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
