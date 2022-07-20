import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/custom_text.dart';
import '../widgets/episodeIconsText.dart';
import 'home_page.dart';

class VideoScreen extends StatefulWidget {

  final String ?id;
  final String ?description;

  VideoScreen({this.id, required this.description});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => Scaffold(
            body: WatchVideoBody(description: widget.description, videoId: widget.id,)),
      ),
    );
  }
}

class WatchVideoBody extends StatefulWidget {
  const WatchVideoBody({Key? key, this.description, this.videoId}) : super(key: key);

  final String? videoId;
  final String? description;

  @override
  State<WatchVideoBody> createState() => _WatchVideoBodyState();
}

class _WatchVideoBodyState extends State<WatchVideoBody> {
  bool detail=true;
  YoutubePlayerController ?_controller;

  @override
  void initState() {
    print("asssssssssssssssssssssssssssssssssssssssssss");
    print(widget.videoId);
    print(widget.description);
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.h),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.to(Home());
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0.r),
                          side: const BorderSide(color: Colors.grey),
                        )),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        CustomText(
                          text: 'Back',
                          size: 12.sp,
                          fontWeight: FontWeight.w500,
                          color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    height: 300.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: YoutubePlayer(
                        controller: _controller!,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          print('Player is ready.');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                          },
                          child: episodeIconsWithTexts(
                            isView: true,
                            isLike: false,
                            title: 'View',
                            iconName: 'download',
                            subtitle: '40k',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                          },
                          child: episodeIconsWithTexts(
                            isView: false,
                            isLike:true,
                            title: 'Like',
                            iconName: 'download',
                            subtitle: '10k',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: episodeIconsWithTexts(
                          isLike: false,
                          isView:false,
                          title: 'Upload Date',
                          iconName: 'download',
                          subtitle: '11-Feb, 2022',
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                      visible: detail,
                      child: Column(children:[SizedBox(height: 33.h),
                        ReadMoreText(
                          '${widget.description}',
                          trimLines: 6,
                          colorClickableText:Theme.of(context).primaryColor,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: 'Read less',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp
                          ),
                          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
                        ),
                        //
                        SizedBox(height: 14.h),
                      ],
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
