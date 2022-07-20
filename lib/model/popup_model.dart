import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

popup(var context, String question, String yes, String no){
  TextEditingController controller=new TextEditingController();
  var ratting=0.0;
  return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 280,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height:50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              question,
                              style: TextStyle(
                                  color: Colors.black),
                            ),

                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(height: 40),
                          child: ElevatedButton(
                            //login button
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                              shadowColor: Color.fromARGB(255, 254 , 192, 1),
                              // backgroundColor: darkBlueColor,
                              primary: Theme.of(context)
                                  .primaryColor,
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 40),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .primaryColor,
                                    width: 0.5),
                                borderRadius:
                                BorderRadius.circular(
                                    15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child:  Text(
                                yes,
                                style: TextStyle(
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(height: 40),
                          child: ElevatedButton(
                            //login button
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shadowColor:Colors.black,
                              // backgroundColor: darkBlueColor,
                              primary: Colors.white,
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 10),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.white,
                                    width: 0.5),
                                borderRadius:
                                BorderRadius.circular(
                                    15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child:  Text(
                                no,
                                style: TextStyle(
                                    color:Colors.black),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                        ),
                      ],
                    ),
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 60,
                    decoration: BoxDecoration(
                        image:DecorationImage(image:AssetImage('assets/icons/books.png')),
                        color: Colors.transparent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));

}