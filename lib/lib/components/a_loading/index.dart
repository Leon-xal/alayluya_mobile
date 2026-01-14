//import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import '../../utils/global.dart';

class ALoading {
  show(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder:
          (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SafeArea(
              child: Builder(
                builder: (BuildContext context) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black54,
                      ),
                      width: 64,
                      height: 64,
                      child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        //                    color: Colors.white,
                        //                     child: CupertinoActivityIndicator(
                        //                       radius: 14,
                        //                     ),
                        child: new CircularProgressIndicator(
                          backgroundColor: Color(0xffffffff),
                          strokeWidth: 2.0,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(128, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color.fromARGB(0, 255, 255, 255),
      //      barrierColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
    );
  }

  hide(BuildContext context) {
    G.pop();
  }
}
