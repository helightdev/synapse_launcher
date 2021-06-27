import 'dart:convert';

import 'package:synapse_launcher/blocs/my_servers_cubit.dart';
import 'package:synapse_launcher/blocs/session_cubit.dart';
import 'package:synapse_launcher/central.dart';
import 'package:synapse_launcher/models/server.dart';
import 'package:http/http.dart' as http;

import 'launcher.dart';

class Servers {

  static Future<List<Server>> getOwn() async {
    await Central.ensureOpenSession();
    print("1");
    var res = await http.get(Uri.parse("${Launcher.apiSettings.serverList}/servers"), headers: {
      "Authorization": sessionCubit.state.session
    });
    print(res.body);
    var entries = jsonDecode(res.body) as List<dynamic>;
    return entries.map((e) => Server.fromJson(e)).toList();
  }

  static Future register(Server server) async {
    print("0");
    await Central.ensureOpenSession();
    print("1");
    print(server.toJson());
    var res = await http.post(Uri.parse("${Launcher.apiSettings.serverList}/servers/register"), body: jsonEncode(server.toJson()), headers: {
      "Authorization": sessionCubit.state.session,
      "Content-Type": "application/json"
    });
    print("2");
    print(res.statusCode);
    print(res.body);
  }

  static Future update(Server server) async {
    print("0");
    await Central.ensureOpenSession();
    print("1");
    print(server.toJson());
    var res = await http.put(Uri.parse("${Launcher.apiSettings.serverList}/servers/${server.id}"), body: jsonEncode(server.toJson()), headers: {
      "Authorization": sessionCubit.state.session,
      "Content-Type": "application/json"
    });
    print("2");
    print(res.statusCode);
  }

  static Future delete(Server server) async {
    print("0");
    await Central.ensureOpenSession();
    print("1");
    var res = await http.delete(Uri.parse("${Launcher.apiSettings.serverList}/servers/${server.id}"), headers: {
      "Authorization": sessionCubit.state.session
    });
    print("2");
    print(res.statusCode);
  }

}