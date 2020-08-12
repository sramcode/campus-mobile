import 'package:campus_mobile_experimental/core/constants/app_constants.dart';
import 'package:campus_mobile_experimental/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_login.dart';


class OnboardingAffiliations extends StatefulWidget {
  @override
  _OnboardingAffiliationsState createState() => _OnboardingAffiliationsState();
}

class _OnboardingAffiliationsState extends State<OnboardingAffiliations> {
  bool studentSelected = false;
  bool staffSelected = false;
  bool visitorSelected = false;
  bool readyToProceed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: Container(
        color: ColorPrimary,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 36.0),
                child: Text(
                    "Your affiliation with UC San Diego",
                    style: TextStyle(color: lightTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    color: studentSelected ? ColorPrimary : darkButtonColor,
                    textColor: studentSelected ? darkButtonColor : ColorPrimary,
                    shape: ContinuousRectangleBorder(
                        side: BorderSide(
                            color: darkButtonColor,
                            width: 1,
                            style: BorderStyle.solid)
                    ),
                    onPressed: () {
                      this.setState(() {
                        studentSelected = !studentSelected;
                        readyToProceed = studentSelected;
                        visitorSelected = false;
                        staffSelected = false;
                      });
                    },
                    child: Text(
                        "Student",
                      style: TextStyle(fontSize: 17, decoration: TextDecoration.underline)
                    )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                      color: staffSelected ? ColorPrimary : darkButtonColor,
                      textColor: staffSelected ? darkButtonColor : ColorPrimary,
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(
                              color: darkButtonColor,
                              width: 1,
                              style: BorderStyle.solid)
                      ),
                      onPressed: () {
                        this.setState(() {
                          staffSelected = !staffSelected;
                          readyToProceed = staffSelected;
                          studentSelected = false;
                          visitorSelected = false;
                        });
                      },
                      child: Text(
                          "Staff/Faculty",
                        style: TextStyle(fontSize: 17, decoration: TextDecoration.underline)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                      color: visitorSelected ? ColorPrimary : darkButtonColor,
                      textColor: visitorSelected ? darkButtonColor : ColorPrimary,
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(
                              color: darkButtonColor,
                              width: 1,
                              style: BorderStyle.solid)
                      ),
                      onPressed: () {
                        this.setState(() {
                          visitorSelected = !visitorSelected;
                          readyToProceed = visitorSelected;
                          studentSelected = false;
                          staffSelected = false;
                        });
                      },
                      child: Text(
                          "Visitor",
                        style: TextStyle(fontSize: 17, decoration: TextDecoration.underline)
                      )
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                        color: ColorPrimary,
                        disabledColor: ColorPrimary,
                        disabledTextColor: Colors.grey,
                        textColor: darkButtonColor ,
                        shape: ContinuousRectangleBorder(
                            side: BorderSide(
                                color: darkButtonColor,
                                width: readyToProceed ? 1 : 0,
                                style: BorderStyle.solid)
                        ),
                        onPressed: !readyToProceed ? null : () async {
                          if(studentSelected || staffSelected) {
                            Navigator.of(context).push(_createRoute());
                          }
                          else {
                            Navigator.pushNamedAndRemoveUntil(context,
                            RoutePaths.BottomNavigationBar, (_) => false);
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showOnboardingScreen', false);
                          }
                        },
                        child: Text(
                            "Next",
                          style: TextStyle(fontSize: 17, decoration: TextDecoration.underline)
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => OnboardingLogin(),
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}