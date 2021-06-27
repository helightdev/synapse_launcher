import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:synapse_launcher/blocs/navigation_cubit.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/components/account_settings.dart';
import 'package:synapse_launcher/components/api_settings.dart';
import 'package:synapse_launcher/components/developer_settings.dart';

class SettingsView extends StatelessWidget {

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Container(
        width: mq.size.width,
        height: mq.size.height,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  color: "#1e272e".toColor(),
                  child: Column(children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(color: Colors.black26, width: mq.size.width / 5, child: Column(
                            children: [
                              Container(height: mq.size.height / 6,),
                              TextButton(child: Text("Account", style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),), onPressed: () {
                                navigationCubit.emit(0);
                              },),
                              TextButton(child: Text("API Locations", style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),), onPressed: () {
                                navigationCubit.emit(1);
                              },),
                              TextButton(child: Text("DevTools", style: GoogleFonts.openSans(fontSize: 16, color: Colors.white),), onPressed: () {
                                navigationCubit.emit(2);
                              },),
                            ],
                          ),),
                          Column(children: [
                            Container(height: 32,),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: BlocBuilder<NavigationCubit, int>(builder: (ctx,state) {
                                switch (state) {
                                  case 0: {
                                    return AccountSettings();
                                  }

                                  case 1: {
                                    return ApiSettings();
                                  }

                                  case 2: {
                                    return DeveloperSettings();
                                  }
                                }

                                return null;
                              }, bloc: navigationCubit,),
                            ),
                            Expanded(child: Container(),),
                            Container(
                              width: mq.size.width - (mq.size.width / 5),
                              child: BlocBuilder<ProgressCubit, ProgressState>(
                                builder: (context, state) {
                                  return state.active
                                      ? LinearProgressIndicator(
                                    value: state.isNull ? null : state.getPercent(),
                                    valueColor:
                                    AlwaysStoppedAnimation("#74b9ff".toColor()),
                                    backgroundColor: "#2d3436".toColor(),
                                  )
                                      : Container();
                                },
                                bloc: progressCubit,
                              ),
                            ),
                          ], crossAxisAlignment: CrossAxisAlignment.start,)
                        ],
                      ),
                    )
                  ]),
                )),
            Positioned(
              child: IconButton(
                  icon: Icon(EvaIcons.arrowBack),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              left: 16,
              top: 16,
            ),
          ],
        ),
      ),
    );
  }

  static double fullSize(MediaQueryData mq) {
    return mq.size.width - (mq.size.width / 5) - 64;
  }
}
