import 'dart:convert';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:synapse_launcher/blocs/my_servers_cubit.dart';
import 'package:synapse_launcher/blocs/navigation_cubit.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/components/account_settings.dart';
import 'package:synapse_launcher/components/api_settings.dart';
import 'package:synapse_launcher/components/developer_settings.dart';
import 'package:synapse_launcher/components/server_edit_dialog.dart';
import 'package:synapse_launcher/components/server_widget.dart';
import 'package:synapse_launcher/launcher.dart';
import 'package:synapse_launcher/models/server.dart';
import 'package:synapse_launcher/servers.dart';
import 'package:synapse_launcher/views/launcher_view.dart';

class MyServersView extends StatefulWidget {
  static GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  _MyServersViewState createState() => _MyServersViewState();

  static double fullSize(MediaQueryData mq) {
    return mq.size.width - (mq.size.width / 5) - 64;
  }

  static Future load() async {
    myServersCubit.emit(MyServersInitial());
    try {
      var mapped = await Servers.getOwn();
      myServersCubit.emit(MyServersLoaded(mapped));
    } catch (e,e1) {
      LauncherView.showError(e, e1, context: MyServersView.scaffoldKey.currentContext);
    }
  }
}

class _MyServersViewState extends State<MyServersView> {



  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return Scaffold(
      key: MyServersView.scaffoldKey,
      backgroundColor: "#1e272e".toColor(),
      body: Container(
        width: mq.size.width,
        height: mq.size.height,
        child: Stack(
          children: [
            BlocBuilder<MyServersCubit, MyServersState>(
              bloc: myServersCubit,
              builder: (context, myServersState) {
                if (!myServersState.loaded) return Center(child: CircularProgressIndicator());
                return Positioned(
                    top: 32,
                    right: 32,
                    bottom: 32,
                    left: 32,
                    child: Column(children: [
                      Text(
                        "My Servers",
                        style:
                        GoogleFonts.openSans(fontSize: 24, color: Colors.white),
                      ),
                      Container(height: 16,),
                      Expanded(
                        child: Container(
                          child: GridView.count(
                              crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8,
                              children: myServersState.servers.map((e) =>
                                  GestureDetector(
                                    child: ServerWidget(e),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog(
                                                child: ServerEditDialog(e),
                                                backgroundColor:
                                                "#1e272e".toColor(),
                                              ));
                                    },
                                  ))
                                  .toList()),
                        ),
                      ),
                      Container(height: 16,),
                      Row(children: [
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      Dialog(
                                        child: ServerEditDialog(Server(
                                            version: "1.0.0",
                                            info: "",
                                            whitelist: false,
                                            friendlyFire: true,
                                            owner: Launcher.getUserIdOrNull())),
                                        backgroundColor: "#1e272e".toColor(),
                                      ));
                            },
                            child: Text("New Server"))
                      ]),
                    ]));
              },
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
            Positioned(
              child: Container(
                width: mq.size.width,
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
              bottom: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    MyServersView.load();
  }
}
