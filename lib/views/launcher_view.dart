import 'dart:developer';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as dev;

import 'package:another_flushbar/flushbar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:synapse_launcher/blocs/account_cubit.dart';
import 'package:synapse_launcher/blocs/game_running_cubit.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/central.dart';
import 'package:synapse_launcher/launcher.dart';
import 'package:synapse_launcher/views/myservers_view.dart';
import 'package:synapse_launcher/views/settings_view.dart';

class LauncherView extends StatefulWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  _LauncherViewState createState() => _LauncherViewState();

  static void showError(dynamic e, StackTrace e1, {BuildContext context}) {
    dev.log(e.toString());
    Flushbar(
      title: "Oh oh, something went wrong!",
      message: e.toString(),
      backgroundColor: "#d63031".toColor(),
      flushbarPosition: FlushbarPosition.TOP,
      mainButton: TextButton(
        onPressed: () {
          Clipboard.setData(
              ClipboardData(text: e.toString() + "\n" + e1.toString()));
        },
        child: Text(
          "Copy",
          style: GoogleFonts.openSans(color: Colors.white),
        ),
      ),
      duration: Duration(seconds: secondForWords(e.toString())),
      icon: Icon(EvaIcons.closeCircleOutline),
    ).show(context??scaffoldKey.currentContext);
  }

  static void featureNotSupported({BuildContext context}) {
    dev.log("Not Implemented");
    Flushbar(
      title: "Ups this doesn't work yet!",
      message:
          "The feature you were trying to access isn't implemented in the current version, "
          "but will be implemented at a later point of time.\n"
          "To stay updated and get notified when this feature is implemented, feel free to join the Synapse-Discord.",
      backgroundColor: "#fdcb6e".toColor(),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 8),
      icon: Icon(EvaIcons.minusCircleOutline),
    ).show(context??scaffoldKey.currentContext);
  }

  static void showInfo(String title, String message, {BuildContext context, IconData icon: EvaIcons.infoOutline}) {
    dev.log("$title: $message");
    Flushbar(
      title: title,
      message: message,
      backgroundColor: "#2d3436".toColor(),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: secondForWords(title + " " + message)),
      icon: Icon(icon),
    ).show(context??scaffoldKey.currentContext);
  }

  static void showCopyInfo(String title, String message, String payload, {BuildContext context, IconData icon: EvaIcons.infoOutline}) {
    dev.log("$title: $message");
    Flushbar(
      title: title,
      message: message,
      backgroundColor: "#2d3436".toColor(),
      flushbarPosition: FlushbarPosition.TOP,
      mainButton: TextButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: payload));
        },
        child: Text(
          "Copy",
          style: GoogleFonts.openSans(color: Colors.white),
        ),
      ),
      duration: Duration(seconds: secondForWords(title + " " + message)),
      icon: Icon(icon),
    ).show(context??scaffoldKey.currentContext);
  }

  static void showSuccessful(String title, String message, {BuildContext context}) {
    dev.log("$title: $message");
    Flushbar(
      title: title,
      message: message,
      backgroundColor: "#00cec9".toColor(),
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: secondForWords(title + " " + message)),
      icon: Icon(EvaIcons.checkmarkCircle),
    ).show(context??scaffoldKey.currentContext);
  }

  static int secondForWords(String s) {
    return min((s.split(" ").length * 0.192).toInt(), 5) + 1; //Based on https://capitalizemytitle.com/reading-time/3000-words/
  }
}

class _LauncherViewState extends State<LauncherView> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var width = mq.size.width;
    var height = mq.size.height;
    var buttons = width * 0.75;
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: "#1e272e".toColor(),
          child: ListView(
           children: [
             ListTile(
               leading: Icon(EvaIcons.hardDriveOutline, size: 36,),
               title: Text('My Servers'),
               subtitle: Text("Manage your old and new servers"),
               onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) => MyServersView()));
               },
             ),
             ListTile(
               leading: Icon(EvaIcons.globe2Outline, size: 36,),
               title: Text('Admin Panel'),
               subtitle: Text("Access to the administration panel"),
               onTap: () async {
                 Navigator.of(context).pop();
                 await Central.ensureLoadedAccount();
                 if (!accountCubit.state.account.isStaff) {
                   LauncherView.showError("No permissions. You have to be Synapse Staff to do that.", StackTrace.current);
                   return;
                 }
                 LauncherView.featureNotSupported();
               },
             ),
           ],
          ),
        ),
      ),
      key: LauncherView.scaffoldKey,
      body: Stack(
        children: [
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
            width: width,
            height: height,
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                  //Here goes the same radius, u can put into a var or function
                  borderRadius:
                  BorderRadius.circular(90),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.54),
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Container(
                      color: "#1e272e".toColor(),
                      width: 24.0*2,
                      height: 24.0*2,
                      child: IconButton(onPressed: () {
                        LauncherView.scaffoldKey.currentState.openDrawer();
                      }, icon: Icon(Icons.expand_more, size: 24,), color: "#dfe6e9".toColor()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Synapse Client\nLauncher Version 1.0.0",
                  style: GoogleFonts.openSans(color: "#bdc3c7".toColor()),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(child: Container()),
              BlocBuilder<ProgressCubit, ProgressState>(
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
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: Container(
                    color: "#000000".toColor().withOpacity(.25),
                    width: width,
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 64,
                            child: IconButton(
                              onPressed: () {
                                Launcher.selectGameDirectory();
                                LauncherView.showInfo("Directory set!",
                                    "The basegame directory has been set to '${baseGameDirectory.path}'.");
                              },
                              icon: Icon(
                                EvaIcons.folder,
                                color: "#ecf0f1".toColor(),
                                size: 32,
                              ),
                              tooltip: "Base-Game Location",
                            ),
                          ),
                          SizedBox(
                            width: buttons,
                            height: 64,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: (buttons / 4 - (8 * 3)) * 1,
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Launcher.install();
                                    },
                                    child: Text("Reinstall",
                                        style:
                                            GoogleFonts.openSans(fontSize: 16)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                "#1e272e".toColor()),
                                        shadowColor: MaterialStateProperty.all(
                                            "#1e272e"
                                                .toColor()
                                                .withOpacity(.5)),
                                        elevation:
                                            MaterialStateProperty.all(10)),
                                  ),
                                ),
                                Container(
                                  width: (buttons / 4 - (8 * 3)) * 2,
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (baseGameDirectory == null)
                                        Launcher.selectGameDirectory();
                                      await Launcher.startGame();
                                    },
                                    child: Text("Launch Game",
                                        style:
                                            GoogleFonts.openSans(fontSize: 24)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                "#0984e3".toColor()),
                                        shadowColor: MaterialStateProperty.all(
                                            "#0984e3"
                                                .toColor()
                                                .withOpacity(.5)),
                                        elevation:
                                            MaterialStateProperty.all(10)),
                                  ),
                                ),
                                Container(
                                  width: (buttons / 4 - (8 * 3)) * 1,
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Launcher.loadMod();
                                    },
                                    child: Text("Load Mod",
                                        style:
                                            GoogleFonts.openSans(fontSize: 16)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                "#1e272e".toColor()),
                                        shadowColor: MaterialStateProperty.all(
                                            "#1e272e"
                                                .toColor()
                                                .withOpacity(.5)),
                                        elevation:
                                            MaterialStateProperty.all(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 64,
                            child: IconButton(
                              onPressed: () {
                                //LauncherView.featureNotSupported();
                                Navigator.of(context).push(new MaterialPageRoute(builder: (ctx) => SettingsView()));
                              },
                              icon: Icon(
                                EvaIcons.settings2,
                                color: "#ecf0f1".toColor(),
                                size: 32,
                              ),
                              tooltip: "Settings",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          BlocBuilder<GameRunningCubit, GameRunningState>(
            builder: (context, state) {
              return state.isRunning
                  ? Container(
                      color: Colors.black45,
                      width: width,
                      height: height,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Game Running...",
                              style: GoogleFonts.openSans(
                                  fontSize: 64, color: Colors.white),
                            ),
                            Container(
                                width: width / 2,
                                child: Text(
                                  "If the game isn't showing up, don't panic and wait a bit, the process is still running. The first start after installation will also take a bit longer.",
                                  style: GoogleFonts.openSans(
                                    fontSize: 28,
                                    color: "#dfe6e9".toColor(),
                                  ),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
            bloc: gameRunningCubit,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Launcher.loadSaved();
  }
}
