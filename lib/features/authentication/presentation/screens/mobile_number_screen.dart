import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/controllers/login_controller.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/presentation/screens/otp_screen.dart';

class MobileNumberScreen extends ConsumerStatefulWidget {
  const MobileNumberScreen({super.key});

  static const String name = '/mobile-number-screen';

  @override
  ConsumerState<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends ConsumerState<MobileNumberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.white),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your mobile no',
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      color: const Color(0xFF101828),
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'We need to verity your number',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: const Color(0xFF667085),
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text.rich(
                const TextSpan(
                  text: 'Mobile Number',
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF101828),
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  maxLength: 10,
                  controller: ref.read(mobileNumberTextEditingController),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counter: const SizedBox.shrink(),
                    hintText: 'Enter Mobile No.',
                    hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF667085),
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field cannot be empty';
                    }
                    if (value.length < 10) {
                      return 'Invalid Mobile Number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      if (ref.read(isMobileFormValid) == true) {
                        ref
                            .read(isMobileFormValid.notifier)
                            .update((state) => false);
                      }
                      return;
                    }
                    if (value.length < 10) {
                      if (ref.read(isMobileFormValid) == true) {
                        ref
                            .read(isMobileFormValid.notifier)
                            .update((state) => false);
                      }
                      return;
                    }
                    ref
                        .read(isMobileFormValid.notifier)
                        .update((state) => true);
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer(builder: (context, ref, child) {
                bool checkBoxValue = ref.watch(mobileNumberCheckBox);
                bool isMobileNumberValid = ref.watch(isMobileFormValid);
                return ElevatedButton(
                  onPressed: checkBoxValue && isMobileNumberValid
                      ? () {
                          context.go(
                              '${MobileNumberScreen.name}/${OtpScreen.name}');
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.disabled)) {
                          return null;
                        }
                        return Colors.black;
                      },
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Get OTP',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              Consumer(builder: (context, ref, child) {
                bool value = ref.watch(mobileNumberCheckBox);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: GestureDetector(
                    onTap: () {
                      ref
                          .read(mobileNumberCheckBox.notifier)
                          .update((state) => !state);
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: value ? const Color(0xFF007DFB) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: value ? Colors.white : Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Allow fydaa to send financial knowledge and critical alerts on your WhatsApp.',
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF667085),
                        ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
