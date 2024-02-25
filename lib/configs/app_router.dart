import 'package:go_router/go_router.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/presentation/screens/mobile_number_screen.dart';
import 'package:mscpl_bhavesh_bellaney/features/authentication/presentation/screens/otp_screen.dart';

final router = GoRouter(
  initialLocation: MobileNumberScreen.name,
  redirect: (context, state) => null,
  routes: [
    GoRoute(
      path: MobileNumberScreen.name,
      builder: (context, state) => const MobileNumberScreen(),
      routes: [
        GoRoute(
          path: OtpScreen.name,
          builder: (context, state) => const OtpScreen(),
        )
      ],
    )
  ],
);
