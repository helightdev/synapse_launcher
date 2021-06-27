import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:synapse_launcher/blocs/account_cubit.dart';
import 'package:synapse_launcher/blocs/session_cubit.dart';
import 'package:synapse_launcher/launcher.dart';

import 'models/account.dart';

class Central {

  static String _adminToken;

  static Future ensureOpenSession() async {
    sessionCubit.emit(SessionLoading());
    if (!isAdminTokenValid()) {
      var session = await openSession("Admin");
      _adminToken = session;
    } else {
      print("Returned cached Admin-Token");
    }
    sessionCubit.emit(new SessionLoaded(_adminToken));
    print("Loaded Session");
  }

  static bool isAdminTokenValid() {
    if (_adminToken == null) return false;
    var e = getAdminTokenExp();
    return e.isAfter(DateTime.now());
  }

  static DateTime getAdminTokenExp() {
    var p = _adminToken.split(".")[1];
    var padding = p.length % 4;
    for (int i = 0; i < padding; i++) {
      p += "=";
    }
    var b = base64Decode(p);
    var s = Utf8Decoder().convert(b);
    var d = jsonDecode(s) as Map<String, dynamic>;
    return DateTime.fromMillisecondsSinceEpoch(d["exp"] * 1000);
  }

  static Future ensureLoadedAccount() async {
    accountCubit.emit(AccountStateInitial());
    var uid = Launcher.getUserIdOrNull();
    var account = uid == null ? null : await getAccount(uid);
    accountCubit.emit(AccountStateLoaded(account));
  }

  static Future<String> openSession(String audience) async {
    var res = await http.post(Uri.parse("${Launcher.apiSettings.centralServer}/user/session"), body: Launcher.getUserCertificateOrNull(), headers: {
      "X-Target-Server": audience
    });
    return res.body;
  }

  static Future<Account> getAccount(String uid) async {
    var res = await http.get(Uri.parse("${Launcher.apiSettings.centralServer}/public/$uid"));
    return Account.fromJson(jsonDecode(res.body));
  }

}