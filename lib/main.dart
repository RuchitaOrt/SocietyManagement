
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:society_management/core/constants/app_colors.dart';
// import 'package:society_management/feature/auth/presentation/bloc/login_bloc.dart';
// import 'package:society_management/feature/auth/presentation/pages/LoginScreen.dart';
// import 'package:society_management/feature/auth/presentation/pages/RegistrationScreen.dart';
// import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_bloc.dart';
// import 'package:society_management/feature/society_setup/presentation/pages/SocietySetupScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(
//     BlocProvider(
//       create: (context) => VisitorBloc(),
//       child: const SocietyPortalApp(),
//     ),
    
//   );
// }
// class SocietyPortalApp extends StatelessWidget {
//   const SocietyPortalApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Society Portal',
//       debugShowCheckedModeBanner: false,

//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         scaffoldBackgroundColor: AppColors.background,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.primary,
//           primary: AppColors.primary,
//         ),
//       ),

//       home: BlocProvider(
//         create: (_) => LoginBloc(),
//         child: Builder(
//           builder: (context) {
//             return LoginScreen(
//               onForgotPassword: () {
//                 // Navigate to Forgot Password screen later.
//               },

//               onCreateAccount: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const RegistrationScreen(),
//                   ),
//                 );
//               },

//               onLoginSuccess: (token) {
//                 // Navigate to Dashboard later.
//                  Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const SocietySetupScreen(),
//               ),
//             );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_management/Member/Screens/member_dashboard_screen.dart';

import 'package:society_management/core/constants/app_colors.dart';

import 'package:society_management/feature/auth/presentation/bloc/login_bloc.dart';
import 'package:society_management/feature/auth/presentation/pages/LoginScreen.dart';
import 'package:society_management/feature/auth/presentation/pages/RegistrationScreen.dart';

import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/society_setup_bloc.dart';

import 'package:society_management/feature/society_setup/presentation/pages/SocietySetupScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<VisitorBloc>(
          create: (context) => VisitorBloc(),
        ),

        BlocProvider<SocietySetupBloc>(
          create: (context) => SocietySetupBloc(),
        ),
      ],
      child: const SocietyPortalApp(),
    ),
  );
}

class SocietyPortalApp extends StatelessWidget {
  const SocietyPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Society Portal',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      ),

      home: BlocProvider(
        create: (_) => LoginBloc(),
        child: Builder(
          builder: (context) {
            return LoginScreen(
              onForgotPassword: () {
                // Navigate to Forgot Password screen later.
              },

              onCreateAccount: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationScreen(),
                  ),
                );
              },

              onLoginSuccess: (token) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MemberDashboardScreen()
                    //  const SocietySetupScreen(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
