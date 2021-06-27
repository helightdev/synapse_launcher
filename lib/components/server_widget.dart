import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:synapse_launcher/components/labeled_text.dart';
import 'package:synapse_launcher/models/server.dart';
import 'package:supercharged/supercharged.dart';

import '../main.dart';

class ServerWidget extends StatelessWidget {

  Server server;

  ServerWidget(this.server);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(server.address, style: t1, maxLines: 2,),
                    Text(server.id, style: t2.copyWith(color: "#bdc3c7".toColor()),),
                  ],
                )
              ],
            ),
            Divider(),
            GridView.count(crossAxisCount: 3, children: [
              LabeledText("Players", "${server.onlinePlayers}/${server.maxPlayers}"),
              LabeledText("FriendlyFire", server.friendlyFire.toString()),
              LabeledText("Verified", server.verified.toString()),
              LabeledText("Official Code", server.officialCode.toString()),
              LabeledText("Language", server.language),
              LabeledText("Pastebin", server.pastebin)
            ], shrinkWrap: true),
          ],
        ),
      ),
    );
  }
}
