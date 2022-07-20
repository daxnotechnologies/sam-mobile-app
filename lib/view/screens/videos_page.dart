import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/model/video_models.dart';
import 'package:sam_beckman/view/screens/videoScreen.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:intl/intl.dart';

import '../../controller/apiService.dart';
import '../../model/chanel_models.dart';

class VideosPage extends StatefulWidget {
  VideosPage({ this.controller,this.videos});
  final ScrollController? controller;
  Future<List<Video>>? videos;
  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  Channel ?channel;
  @override
  void initState() {
    // TODO: implement initState
    log("asdddddddddddddddddddddddd");
    log(widget.videos.toString());
    super.initState();
  }
  _initChannel()async{
    Channel channels = await APIService.instance.fetchChannel(channelId: 'UC_1awbvccFZOnVRjAIkCG7Q');
    setState(() {
      channel=channels;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
            ? Colors.grey.shade50
            : Color(0xff292b2e),
        borderRadius: BorderRadius.only(topRight: Radius.circular(24.r),topLeft: Radius.circular(24.r)),

      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          children: [
            SizedBox(height: 18.h),
            Image.asset('assets/icons/line.png'),
            SizedBox(height: 12.h),
            CustomText(
              text: 'Videos',
              size: 16.sp,
              fontWeight: FontWeight.bold,
              color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark?
                   Colors.white
                  : Colors.black,
            ),
            SizedBox(height: 30.h),
            FutureBuilder<List<Video>>(
              future:widget.videos,
              builder: (context,snapshot) {
                if(snapshot.hasData)
                {
                  log(snapshot.data.toString());
                  return GridView.builder(
                      primary: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:snapshot.data?.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          DateTime dt = DateTime.parse(snapshot.data!.elementAt(index).publishedAt.toString());
                          String formattedDate = DateFormat('dd MMMM yy').format(dt);
                          return Column(
                            children: [
                               Container(
                                  child: Center(child: Text('${snapshot.data?.elementAt(index).title}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10),))),
                                Container(
                                  child: Text("$formattedDate",maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10),)),
                              Center(
                                child: InkWell(
                                  onTap:(){
                                   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VideoScreen(id:snapshot.data!.elementAt(index).id, description: snapshot.data!.elementAt(index).description,)));
                                  },
                                  child: Container(
                                      width: 140.w,
                                      height: 140.h,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,image: NetworkImage(snapshot.data!.elementAt(index).thumbnailUrl.toString()),
                                  )),
                                  child: Image.network(snapshot.data!.elementAt(index).thumbnailUrl.toString()),
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                                ),
                              ),
                            ],
                          );
                      });
                  }else{return Container();}
              }
            )
          ],
        ),
      ),
    );
  }
}

class ImageWithText extends StatelessWidget {
   ImageWithText({Key? key, this.index,this.title,this.video}) : super(key: key);
  Video ?video;
  String ?title;
  final String? index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          top: 120.h,
          left: 20.w,
          child: CustomText(
            overflow: TextOverflow.ellipsis,
            text: '${video?.title}',  
            size: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
