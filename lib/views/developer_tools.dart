import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/central.dart';
import 'package:synapse_launcher/launcher.dart';
import 'package:synapse_launcher/views/launcher_view.dart';
import 'package:synapse_launcher/views/settings_view.dart';
import 'package:supercharged/supercharged.dart';

class DeveloperTools extends StatefulWidget {
  DeveloperTools({Key key}) : super(key: key);

  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  _DeveloperToolsState createState() => _DeveloperToolsState();
}

class _DeveloperToolsState extends State<DeveloperTools> {


  TextEditingController customSessionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      key: DeveloperTools.scaffoldKey,
      backgroundColor: "#1e272e".toColor(),
      body: Stack(
        children: [
          Positioned(
            left: 32, top: 64, right: 16, bottom: 16,
            child: Column(
              children: [
                Text(
                  "Developer Tools",
                  style: GoogleFonts.openSans(
                      fontSize: 24, color: Colors.white),
                ),
                Container(height: 16,),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        var path = installLocation.absolute.path;
                        Clipboard.setData(ClipboardData(text: path));
                        LauncherView.showInfo("Copied!", "Copied path '$path' to clipboard", icon: EvaIcons.clipboardOutline);
                      },
                      child: Text("Copy SynapseClient Path",
                          style: GoogleFonts.openSans(
                              fontSize: 16, color: Colors.white)),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all("#0984e3".toColor())),
                    ),
                    Container(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: Launcher.getUserCertificateOrNull()));
                        LauncherView.showInfo("Copied!", "Copied client certificate to clipboard", icon: EvaIcons.clipboardOutline);
                      },
                      child: Text("Copy Certificate",
                          style: GoogleFonts.openSans(
                              fontSize: 16, color: Colors.white)),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all("#0984e3".toColor())),
                    ),
                  ],
                ),
               Container(
                  width: mq.size.width / 2,
                  child: Tooltip(
                    message: "Generate a custom session token by typing the target audience and pressing enter",
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: "Custom Session",
                          labelStyle: GoogleFonts.openSans(
                              fontSize: 12, color: "#636e72".toColor())),
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: "#dfe6e9".toColor()),
                      controller: customSessionController,
                      onSubmitted: (s) async {
                        try {
                          progressCubit.emit(ProgressUpdate(0.0,0.0, isNull: true));
                          var session = await Central.openSession(s);
                          customSessionController.text = "";
                          setState(() {});
                          LauncherView.showCopyInfo("Session generated!", "A new session for audience '$s' has been generated. " +
                              "Click on the right button to copy the jwt token to your clipboard.", session, context: SettingsView.scaffoldKey.currentContext);

                        } catch (e,e1) {
                          LauncherView.showError(e,e1, context: SettingsView.scaffoldKey.currentContext);
                        }
                        progressCubit.emit(ProgressInitial());
                      },
                    ),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
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
          Positioned(bottom: 0, left: 0, right: 0, child: Container(
            width: mq.size.width - (mq.size.width / 5),
            child: BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, state) {
                return state.active ? LinearProgressIndicator(
                  value: state.isNull ? null : state.getPercent(),
                  valueColor:
                  AlwaysStoppedAnimation("#74b9ff".toColor()),
                  backgroundColor: "#2d3436".toColor(),
                ) : Container();
              },
              bloc: progressCubit,
            ),
          ))
        ],
      ),
    );
  }
}