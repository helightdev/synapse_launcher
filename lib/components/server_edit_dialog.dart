import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/main.dart';
import 'package:synapse_launcher/models/server.dart';
import 'package:supercharged/supercharged.dart';
import 'package:synapse_launcher/servers.dart';
import 'package:synapse_launcher/views/launcher_view.dart';
import 'package:synapse_launcher/views/myservers_view.dart';

import 'labeled_checkbox.dart';

class ServerEditDialog extends StatefulWidget {
  Server server;

  ServerEditDialog(this.server, {Key key}) : super(key: key);

  @override
  _ServerEditDialogState createState() => _ServerEditDialogState();
}

class _ServerEditDialogState extends State<ServerEditDialog> {
  TextEditingController addressController;
  TextEditingController pastebinController;
  TextEditingController languageController;

  @override
  void initState() {
    addressController =
        TextEditingController(text: widget.server.address ?? "");
    pastebinController =
        TextEditingController(text: widget.server.pastebin ?? "");
    languageController =
        TextEditingController(text: widget.server.language ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 600,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Server Editing", style: t1,),
            TextField(
              decoration: InputDecoration(
                labelText: "Address",
                labelStyle: l1,
              ),
              style: b1,
              controller: addressController,
              onChanged: (s) {
                widget.server = widget.server.copyWith(address: s);
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Pastebin",
                labelStyle: l1,
              ),
              style: b1,
              controller: pastebinController,
              onChanged: (s) {
                widget.server = widget.server.copyWith(pastebin: s);
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Language",
                    labelStyle: l1,
                  ),
                  style: b1,
                  controller: languageController,
                  onChanged: (s) {
                    widget.server = widget.server.copyWith(language: s);
                  },
                ),
              ),
                Container(width: 8,),
              LabeledCheckbox(
                  label: "Friendly Fire",
                  value: widget.server.friendlyFire,
                  onChanged: (v) {
                    setState(() {
                      widget.server = widget.server.copyWith(friendlyFire: v);
                    });
                  }),
              Container(width: 8,),
              LabeledCheckbox(
                  label: "Whitelist",
                  value: widget.server.whitelist,
                  onChanged: (v) {
                    setState(() {
                      widget.server = widget.server.copyWith(whitelist: v);
                    });
                  })
            ],),
            Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    progressCubit.emit(ProgressUpdate(0.0, 0.0, isNull: true));
                    try {
                      if (widget.server.id == null) {
                        await Servers.register(widget.server);
                        LauncherView.showSuccessful("Registered!", "Your server has been registered successfully. " +
                            "We will have a look at your data so we can verify your server.");
                      } else {
                        await Servers.update(widget.server);
                        LauncherView.showSuccessful("Updated!", "The server entry has been successfully updated.");
                      }
                      progressCubit.emit(ProgressInitial());
                      await MyServersView.load();
                    } catch (e1,e2) {
                      progressCubit.emit(ProgressInitial());
                      LauncherView.showError(e1, e2, context: MyServersView.scaffoldKey.currentContext);
                    }
                  },
                  child: Text("Save",
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all("#00b894".toColor())),
                ),
                Container(width: 8,),
                if (widget.server.id != null) ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    progressCubit.emit(ProgressUpdate(0.0, 0.0, isNull: true));
                    try {
                      await Servers.delete(widget.server);
                      LauncherView.showSuccessful("Deleted!", "The server entry has been successfully deleted.");
                      progressCubit.emit(ProgressInitial());
                      await MyServersView.load();
                    } catch (e1,e2) {
                      progressCubit.emit(ProgressInitial());
                      LauncherView.showError(e1, e2, context: MyServersView.scaffoldKey.currentContext);
                    }
                  },
                  child: Text("Delete",
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all("#e74c3c".toColor())),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
