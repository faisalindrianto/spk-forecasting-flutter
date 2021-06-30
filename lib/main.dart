import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:spk/screens/mainpage.dart';
import 'package:spk/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('id_ID', null).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SPK',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedSplashScreen(
        nextScreen: Onboarding(),
        splash: Container(
          padding: EdgeInsets.all(100),
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            "assets/images/splash.jpg",
            fit: BoxFit.cover,
          ),
        ),
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.fadeTransition,
        // pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<PageViewModel> list = [
    PageViewModel(
      title: "Faisal Indrianto",
      body: "04218076",
      image: Center(
        child: Image.asset('assets/images/onboarding-1.jpg', fit: BoxFit.cover, width: SizeConfig.screenWidth),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
      ),
    ),
    PageViewModel(
      title: "Arrahman Kaffi",
      body: "04218028",
      image: Center(
        child: Image.asset('assets/images/onboarding-2.jpg', fit: BoxFit.cover, width: SizeConfig.screenWidth),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
      ),
    ),
    PageViewModel(
      title: "Herlambang Nurwachid",
      body: "04218025",
      image: Center(
        child: Image.asset('assets/images/onboarding-3.jpg', fit: BoxFit.cover, width: SizeConfig.screenWidth),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
      ),
    ),
    PageViewModel(
      title: "Fahrurrozy",
      body: "04218065",
      image: Center(
        child: Image.asset('assets/images/onboarding-4.jpg', fit: BoxFit.cover, width: SizeConfig.screenWidth),
      ),
      decoration: const PageDecoration(
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: IntroductionScreen(
            pages: list,
            onDone: () => _onIntroEnd(context),
            onSkip: () => Get.off(() => MainPage()),
            showSkipButton: true,
            skipFlex: 0,
            nextFlex: 0,
            skip: Text("Lewati", style: TextStyle(color: Colors.grey)),
            next: Text("Selanjutnya"),
            done: Text("Mulai", style: TextStyle(color: Colors.green)),
            dotsDecorator: DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeColor: Colors.green,
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onIntroEnd(context) {
    Get.off(() => MainPage());
  }
}
