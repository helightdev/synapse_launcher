import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:synapse_launcher/blocs/launch_cubit.dart';

import '../launcher.dart';
import '../main.dart';

class LaunchButton extends StatefulWidget {
  LaunchButton({Key key}) : super(key: key);

  @override
  _LaunchButtonState createState() => _LaunchButtonState();
}

class _LaunchButtonState extends State<LaunchButton> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: "#0984e3".toColor(),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () async {
          switch (launchCubit.state.configuration) {
            case "modded": {
              if (baseGameDirectory == null) Launcher.selectGameDirectory();
              await Launcher.startGame();
              break;
            }

            case "vanilla": {
              if (baseGameDirectory == null) Launcher.selectGameDirectory();
              await Launcher.startVanillaGame();
              break;
            }
          }
        },
        child: Container(
          //decoration: BoxDecoration(color: "#0984e3".toColor(),),
          child: BlocBuilder<LaunchCubit, LaunchState>(
            bloc: launchCubit, builder: (context, state) {
              return Stack(
                children: [
                  Positioned(
                    left: 16, top: 0, bottom: 0,
                    child: PopupMenuButton<LaunchState>(
                      tooltip: "Change the client type",
                      onSelected: (result) => launchCubit.emit(result),
                      itemBuilder: (ctx) => <PopupMenuEntry<LaunchState>>[
                        PopupMenuItem<LaunchState>(
                          value: LaunchUpdated("modded"),
                          child: Text('Synapse Client'),
                        ),
                        PopupMenuItem<LaunchState>(
                          value: LaunchUpdated("vanilla"),
                          child: Text('Vanilla Client'),
                        ),
                      ],
                      child: Center(child: Icon(EvaIcons.chevronDown, size: 36,)),
                      initialValue: state,
                    ),
                  ),
                  Positioned(
                    right: 16, top: 0, bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Version", style: b1.copyWith(fontSize: 12, color: Colors.white70),),
                        Text(state.configuration == "modded" ? "Synapse" : "Vanilla", style: b1.copyWith(color: Colors.white),),
                      ],
                    )),
                  Center(
                    child: Text("Launch Game", style: t1,),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

/*
  ElevatedButton(
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
    );
   */
}