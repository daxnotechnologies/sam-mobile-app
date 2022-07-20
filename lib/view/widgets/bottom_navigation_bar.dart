import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sam_beckman/view/screens/favourite_pages.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/login_page.dart';
import 'package:sam_beckman/view/screens/search_page.dart';
import 'package:sam_beckman/view/screens/user_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/popup_model.dart';

class CustomBottomNavigationBar extends StatefulWidget {
 CustomBottomNavigationBar(this.index);
  var index;
  
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  _CustomBottomNavigationBarState();

  void navigation() async{
    if (widget.index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
    } else if (widget.index == 1) {
      if(FirebaseAuth.instance.currentUser!.email == 'guest@gmail.com'){
        var value = await popup(context, "Sign in to favourite, \ncurate and review apps.", "Sign in", "No thanks");
        if(value){
          Navigator.pop(context);
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    Login()));
        } else 
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const FavouritesPage()));
      }
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const FavouritesPage()));
    } else if (widget.index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => SearchPage(filterValue: 'Filter By',)));
    } else {
       if(FirebaseAuth.instance.currentUser!.email == 'guest@gmail.com'){
        var value = await popup(context, "Sign in to favourite, \ncurate and review apps.", "Sign in", "No thanks");
        if(value){
          Navigator.pop(context);
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    Login()));
        } else 
          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const UserProfilePage()));
      }
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const UserProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
            ? Colors.white
            : Colors.black12.withOpacity(0.5),
        borderRadius: BorderRadius.circular(100)
      ),
      child: SalomonBottomBar(
        selectedItemColor: Theme.of(context).primaryColor,
        selectedColorOpacity: 1.0,
        currentIndex: widget.index,
        onTap: (i) {
          setState(() => widget.index = i);
          navigation();
          setState(() => widget.index = 1);
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(
              Icons.home,
              color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            title: Text(
            "Home",
            style: GoogleFonts.roboto(
              color:
                  SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13
            ),
            // style: TextStyle(
            //   color:
            //       SchedulerBinding.instance.window.platformBrightness == Brightness.dark
            //           ? Colors.white
            //           : Colors.black,
            // ),
              ),
            selectedColor: Theme.of(context).primaryColor,
            unselectedColor: Colors.grey,
          ),

          SalomonBottomBarItem(
            icon: Icon(
              Icons.favorite,
              color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            title: Text(
              "Favourites",
               style: GoogleFonts.roboto(
                color:
                    SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13
              ),
            ),
            unselectedColor: Colors.grey,
            selectedColor: Theme.of(context).primaryColor,
          ),

          SalomonBottomBarItem(
            icon: Icon(
              Icons.search,
              color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            title: Text(
              "Search",
               style: GoogleFonts.roboto(
                color:
                    SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13
              ),
            ),
            unselectedColor: Colors.grey,
            selectedColor: Theme.of(context).primaryColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(
              Icons.person,
              color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            unselectedColor: Colors.grey,
            title: Text(
              "Profile",
              style: GoogleFonts.roboto(
                color:
                    SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13
              ),
            ),
            selectedColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
