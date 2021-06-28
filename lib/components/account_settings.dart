import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';
import 'package:synapse_launcher/blocs/account_cubit.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/blocs/session_cubit.dart';
import 'package:synapse_launcher/central.dart';
import 'package:synapse_launcher/launcher.dart';
import 'package:synapse_launcher/views/launcher_view.dart';
import 'package:synapse_launcher/views/settings_view.dart';

class AccountSettings extends StatefulWidget {
  AccountSettings({Key key}) : super(key: key);

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController idController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    progressCubit.emit(ProgressUpdate(0.0,0.0, isNull: true));
    try {
      await Central.ensureLoadedAccount();
      var acc = accountCubit.state.account;
      if (acc == null) {
        progressCubit.emit(ProgressInitial());
        return;
      }
      nameController.text = acc.name;
      idController.text = acc.id;
      if (this.mounted) setState(() {});
      await Central.ensureOpenSession();
      print("AccountSettingsLoad Complete!");
    } catch(e) {
      log(e.toString());
    }
    progressCubit.emit(ProgressInitial());
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var full = SettingsView.fullSize(mq);
    return BlocBuilder<AccountCubit, AccountState>(
      bloc: accountCubit,
      builder: (context, account) {
        return Container(
          width: full,
          child: Column(
            children: [
              Text(
                "Account",
                style: GoogleFonts.openSans(
                    fontSize: 24, color: Colors.white),
              ),
              if (account.exists) Container(
                width: full / 2,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: GoogleFonts.openSans(
                          fontSize: 12, color: "#636e72".toColor())),
                  style: GoogleFonts.openSans(
                      fontSize: 16, color: "#dfe6e9".toColor()),
                  controller: nameController,
                ),
              ),
              if (account.exists) Container(
                width: full / 2,
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "ID",
                      labelStyle: GoogleFonts.openSans(
                          fontSize: 12, color: "#636e72".toColor())),
                  style: GoogleFonts.openSans(
                      fontSize: 16, color: "#dfe6e9".toColor()),
                  controller: idController,
                  enabled: false,
                ),
              ),
              Container(height: 32),
              if (account.exists) Row(children: [
                ElevatedButton(
                  onPressed: () async {
                    progressCubit.emit(ProgressUpdate(0.0,0.0, isNull: true));
                    try {
                      await Central.changeName(nameController.text);
                      await Central.ensureLoadedAccount();
                      LauncherView.showSuccessful("Updated!", "You successfully updated your player name", context: SettingsView.scaffoldKey.currentContext);
                    } catch (e,e1) {
                      LauncherView.showError(e, e1, context: SettingsView.scaffoldKey.currentContext);
                    }
                    progressCubit.emit(ProgressInitial());
                  },
                  child: Text("Save",
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all("#00b894".toColor())),
                ),
                Container(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Delete",
                      style: GoogleFonts.openSans(
                          fontSize: 16, color: Colors.white)),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all("#d63031".toColor())),
                )
              ])
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      },
    );
  }
}
