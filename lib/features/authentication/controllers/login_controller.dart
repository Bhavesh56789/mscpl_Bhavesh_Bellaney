import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/state/auth_state.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/timer_controller.dart';

final mobileNumberTextEditingController =
    Provider((ref) => TextEditingController());
final otpTextEditingController = Provider((ref) => TextEditingController());

final mobileNumberCheckBox = StateProvider<bool>((ref) => false);
final isMobileFormValid = StateProvider<bool>((ref) => false);
final enableResendButton = StateProvider<bool>((ref) => false);

final loginController = StateNotifierProvider<LoginController, AuthState>(
    (ref) => LoginController(ref));

class LoginController extends StateNotifier<AuthState> {
  LoginController(this.providerRef) : super(AuthState.notverified);

  StateNotifierProviderRef<LoginController, AuthState> providerRef;

  void verifyOtp(String otp) {
    if (otp == '934477') {
      state = AuthState.verified;
      providerRef.read(timerController.notifier).cancelTimer();
    } else {
      state = AuthState.failure;
    }
  }
}
