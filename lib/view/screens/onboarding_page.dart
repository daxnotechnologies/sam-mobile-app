import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/screens/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  var brightness ;
  bool? isDarkMode;
  @override
  void initState() {
     brightness = SchedulerBinding.instance.window.platformBrightness;
     isDarkMode = brightness == Brightness.dark;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      builder: () => SafeArea(
        child: Scaffold(
          body: IntroductionScreen(
            globalBackgroundColor: isDarkMode!?Colors.black12:Colors.white,
            pages: [
              _pageViewModel(context,
                  title1: 'Explore. ',
                  title2: 'Discover. ',
                  body:
                      'Browse new and exciting applications added to the app every single week.',
                  gifPath: 'gif1'),
              _pageViewModel(context,
                  gifPath: 'gif2',
                  title1: 'Watch. ',
                  title2: 'Learn.',
                  body:
                      "Like an application you've discovered? Watch the video is featured in from the Sam Beckman Youtube Channel."),
              _pageViewModel(context,
                  gifPath: 'gif3',
                  title1: 'Curate. ',
                  title2: 'Rate.',
                  body:
                      'Create your very own lists of applications. Provide your own ratings and reviews of each app!'),
            ],
            showNextButton: false,
            showBackButton: false,
            showDoneButton: true,
            showSkipButton: false,
            done: Text(
              'Next',
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Color.fromARGB(255, 254, 192, 1),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold),
            ),
            onDone: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
          ),
        ),
      ),
    );
  }

  PageViewModel _pageViewModel(BuildContext context,
      {String? title1, String? title2, String? body, String? gifPath}) {
    return PageViewModel(
      titleWidget: Container(
        margin: EdgeInsets.only(top: 40.h),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: title1 ?? '',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode!
                        ? Colors.white
                        : Colors.black,
              ),
            ),
            TextSpan(
              text: title2 ?? '',
              style: TextStyle(
                fontSize: 28.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ]),
        ),
      ),
      bodyWidget: Container(
        margin: EdgeInsets.only(top: 30.h),
        child: Text(
          body ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey, fontSize: 17.sp, fontWeight: FontWeight.w500),
        ),
      ),
      image: Container(
        width: double.infinity,
        height: 420.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35.r),
            bottomRight: Radius.circular(35.r),
          ),
        ),
        child: Image.asset(
          'assets/gifs/$gifPath.gif',
          width: 150.w,
          height: 150.h,
        ),
      ),
    );
  }
}
