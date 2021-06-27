import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synapse_launcher/launcher.dart';
import 'package:synapse_launcher/models/api_settings_content.dart';
import 'package:synapse_launcher/views/launcher_view.dart';
import 'package:synapse_launcher/views/settings_view.dart';
import 'package:supercharged/supercharged.dart';

class ApiSettings extends StatefulWidget {
  ApiSettings({Key key}) : super(key: key);

  @override
  _ApiSettingsState createState() => _ApiSettingsState();
}

class _ApiSettingsState extends State<ApiSettings> {

  TextEditingController centralServerController;
  TextEditingController serverListController;


  @override
  void initState() {
    super.initState();
    centralServerController = TextEditingController(text: Launcher.apiSettings.centralServer);
    serverListController = TextEditingController(text: Launcher.apiSettings.serverList);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var full = SettingsView.fullSize(mq);
    return Container(
      width: full,
      child: Column(
        children: [
          Text(
            "API Locations",
            style: GoogleFonts.openSans(
                fontSize: 24, color: Colors.white),
          ),
         Container(
            width: full / 2,
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Central-Server",
                  labelStyle: GoogleFonts.openSans(
                      fontSize: 12, color: "#636e72".toColor())),
              style: GoogleFonts.openSans(
                  fontSize: 16, color: "#dfe6e9".toColor()),
              controller: centralServerController,
            ),
          ),
          Container(
            width: full / 2,
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Server-List",
                  labelStyle: GoogleFonts.openSans(
                      fontSize: 12, color: "#636e72".toColor())),
              style: GoogleFonts.openSans(
                  fontSize: 16, color: "#dfe6e9".toColor()),
              controller: serverListController,
            ),
          ),
          Container(height: 32),
          Row(children: [
            ElevatedButton(
              onPressed: () {
                ApiSettingsContent settings = ApiSettingsContent(
                  centralServer: centralServerController.text,
                  serverList: serverListController.text
                );
                Launcher.setApiSettings(settings);
                LauncherView.showSuccessful("Updated", "Changed api settings and wrote updates to apis.json", context: context);
              },
              child: Text("Save",
                  style: GoogleFonts.openSans(
                      fontSize: 16, color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all("#00b894".toColor())),
            ),
          ])
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}