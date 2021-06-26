import 'dart:async';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapse_launcher/blocs/game_running_cubit.dart';
import 'package:synapse_launcher/blocs/progress_cubit.dart';
import 'package:synapse_launcher/views/launcher_view.dart';
import 'package:win32/win32.dart';
import 'package:supercharged/supercharged.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Directory baseGameDirectory;
Directory installLocation;
Directory installGameLocation;

class Launcher {
  static void createInstallationDir() {
    installLocation =
        Directory(Platform.environment["APPDATA"] + "\\" + "Synapse Client");
    installGameLocation = Directory(Platform.environment["APPDATA"] +
        "\\" +
        "Synapse Client" +
        "\\" +
        "Game");
    if (!installLocation.existsSync()) {
      installLocation.createSync();
    }
    if (!installGameLocation.existsSync()) {
      installGameLocation.createSync();
    }
  }

  static Future loadSaved() async {
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("BaseGame")) {
      baseGameDirectory = Directory(preferences.getString("BaseGame"));
      print("Loaded baseGameDirectory from Preferences");
    }
  }

  static void selectGameDirectory() async {
    var filePicker = OpenFilePicker();
    filePicker.filterSpecification = {"SCP:SL Executable": "SCPSL.exe"};
    filePicker.title = "Select the BaseGame SCPSL.exe";
    var file = filePicker.getFile();
    print(file.path);
    baseGameDirectory = file.parent;
    var preferences = await SharedPreferences.getInstance();
    preferences.setString("BaseGame", baseGameDirectory.path);
  }

  static Future loadMod() async {
    try {
      var picker = OpenFilePicker();
      picker.filterSpecification = {
        "Mod Archive": "*.zip"
      };
      picker.title = "Select the mod archive";
      var file = picker.getFile();

      if (file == null) {
        LauncherView.showError("You have to select the .zip archive containing the mod in order to load it.", StackTrace.current);
        return;
      }

      var temp = await createTemp();
      var mods = Directory(installGameLocation.path + "\\mods");
      var bundles = Directory(installGameLocation.path + "\\bundles");
      if (!mods.existsSync()) await mods.create(recursive: true);
      if (!bundles.existsSync()) await bundles.create(recursive: true);
      await unzip(file, temp);
      for (var value in temp.listSync(recursive: true)) {
        if (value is File) {
          var name = path.basename(value.path);
          if (name.endsWith(".dll")) {
            await value.copy(mods.path + "\\" + name);
          } else if (name.endsWith(".bundle")) {
            await value.copy(bundles.path + "\\" + name);
          }
        }
      }
      await deleteTemp();
      LauncherView.showInfo("Mod installed!", "The mod you selected has been successfully installed on your client.");
    } catch (e,e1) {
      LauncherView.showError(e, e1);
    }
  }

  static Future<Directory> createTemp() async {
    var temp = Directory(installLocation.path + "\\temp");
    if (temp.existsSync()) await temp.delete(recursive: true);
    await temp.create();
    return temp;
  }

  static Future deleteTemp() async {
    var temp = Directory(installLocation.path + "\\temp");
    if (temp.existsSync()) await temp.delete(recursive: true);
  }

  static Future install() async {
    try {
      progressCubit.emit(ProgressUpdate(0, 11));
      if (installGameLocation.existsSync())
        await installGameLocation.delete(recursive: true);
      await installGameLocation.create();

      await copyDirectoryAsync(baseGameDirectory, installGameLocation, false)
          .then((value) => {print("Done!")});

      //1
      progressCubit.emit(ProgressUpdate(1, 11));
      var temp = await createTemp();
      var bepinex = File(temp.path + "\\" + "bepinex.zip");
      var unitylibs = File(temp.path + "\\" + "unitylibs.zip");
      var executable = File(temp.path + "\\" + "SCPSL.exe");
      var client = File(temp.path + "\\" + "SynapseClient-Fat.dll");
      var mono = File(temp.path + "\\" + "mono.zip");
      var logo = File(temp.path + "\\" + "synapse.png");
      //2
      progressCubit.emit(ProgressUpdate(2, 11));
      await downloadFile(
          "https://builds.bepis.io/projects/bepinex_be/371/BepInEx_UnityIL2CPP_x64_64a75b8_6.0.0-be.371.zip",
          bepinex);
      //3
      progressCubit.emit(ProgressUpdate(3, 11));
      await downloadFile(
          "https://github.com/LavaGang/Unity-Runtime-Libraries/raw/master/2019.4.19.zip",
          unitylibs);
      //4
      progressCubit.emit(ProgressUpdate(4, 11));
      await downloadFile(
          "https://storage.googleapis.com/synapse-client/SCPSL.exe",
          executable);
      //5
      progressCubit.emit(ProgressUpdate(5, 11));
      await downloadFile(
          "https://storage.googleapis.com/synapse-client/SynapseClient-Fat.dll",
          client);
      //6
      progressCubit.emit(ProgressUpdate(6, 11));
      await downloadFile(
          "https://storage.googleapis.com/synapse-client/mono.zip", mono);
      //7
      progressCubit.emit(ProgressUpdate(7, 11));
      await downloadFile(
          "https://storage.googleapis.com/synapse-client/synapse.png", logo);
      //8
      progressCubit.emit(ProgressUpdate(8, 11));
      print("Downloaded Files");

      var bepTemp = Directory(temp.path + "\\BepInEx");
      await bepTemp.create(recursive: true);
      await unzip(bepinex, bepTemp);
      await File(bepTemp.path + "\\winhttp.dll")
          .copy(installGameLocation.path + "\\winhttp.dll");
      await File(bepTemp.path + "\\doorstop_config.ini")
          .copy(installGameLocation.path + "\\doorstop_config.ini");
      //9
      progressCubit.emit(ProgressUpdate(9, 11));
      var fbe = File(installGameLocation.path + "\\SCPSL.exe");
      var fbp = Directory(installGameLocation.path + "\\BepInEx");
      var fbpp = Directory(fbp.path + "\\plugins");
      var fbpu = Directory(fbp.path + "\\unity-libs");
      var bpm = Directory(installGameLocation.path + "\\mono");

      if (fbe.existsSync()) await fbe.delete();
      await fbe.create(recursive: true);
      await executable.copy(fbe.path);
      await fbp.create(recursive: true);
      await copyDirectoryAsync(
          Directory(bepTemp.path + "\\BepInEx"), fbp, false);
      await fbpu.create(recursive: true);
      await unzip(unitylibs, fbpu);
      await fbpp.create(recursive: true);
      await client.copy(fbpp.path + "\\SynapseClient-Fat.dll");
      await bpm.create(recursive: true);
      await unzip(mono, bpm);
      await logo.copy(installGameLocation.path + "\\synapse.png");
      //10
      progressCubit.emit(ProgressUpdate(10, 11));
      var nbpm = Directory(bpm.path + "\\mono");
      if (nbpm.existsSync()) {
        print("Mono is somehow nested, copying...");
        await copyDirectoryAsync(nbpm, bpm, false);
      }
      await deleteTemp();
      //11
      progressCubit.emit(ProgressInitial());
      print("Finished");
      LauncherView.showSuccessful("SynapseClient installed!", "The SynapseClient has been successfully installed installed and can "
          "or will now be launched via the play button.\nThanks for downloading and using our client!");
    } catch (e, e1) {
      progressCubit.emit(ProgressInitial());
      LauncherView.showError(e, e1);
    }
  }

  static Future startGame() async {
    try {
      if (installGameLocation.existsSync()) {
        if (installGameLocation.listSync().length <= 10) await install();
        var exe = installGameLocation.path + "\\SCPSL.exe";
        print("Running $exe in ${installGameLocation.path}");
        gameRunningCubit.emit(GameStarted());
        var process = await Process.run("start", ["SCPSL.exe"],
            workingDirectory: installGameLocation.path, runInShell: true);
        print("Finished with exit code ${process.exitCode}!");
        gameRunningCubit.emit(GameStopped());
      } else {
        await install();
        await startGame();
      }
    } catch (e, e1) {
      gameRunningCubit.emit(GameStopped());
      LauncherView.showError(e, e1);
    }
  }

  static Future unzip(File file, Directory out) async {
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        var f = File(out.path + "\\" + filename);
        await f.create(recursive: true);
        await f.writeAsBytes(data);
      } else {
        await Directory(out.path + "\\" + filename).create(recursive: true);
      }
    }
  }

  static Future downloadFile(String url, File file) async {
    file.createSync();
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    await response.pipe(file.openWrite());
  }

  static Future copyDirectoryAsync(
      Directory source, Directory destination, bool nested) async {
    var files = source.listSync(recursive: false);
    var all = source.listSync(recursive: true);
    if (!nested) progressCubit.emit(ProgressUpdate(0, all.length.toDouble()));
    for (var entity in files) {
      if (entity is Directory) {
        var newDirectory = Directory(
            path.join(destination.absolute.path, path.basename(entity.path)));
        await newDirectory.create();
        await copyDirectoryAsync(entity.absolute, newDirectory, true);
      } else if (entity is File) {
        await entity
            .copy(path.join(destination.path, path.basename(entity.path)));
        progressCubit.emit(ProgressIncrement());
      }
    }
  }
}
