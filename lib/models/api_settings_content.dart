class ApiSettingsContent {

  static ApiSettingsContent defaults = new ApiSettingsContent(
      centralServer: "https://central.synapsesl.xyz",
      serverList: "https://servers.synapsesl.xyz");

  String _centralServer;
  String _serverList;

  String get centralServer => _centralServer;
  String get serverList => _serverList;

  ApiSettingsContent({
      String centralServer, 
      String serverList}){
    _centralServer = centralServer;
    _serverList = serverList;
}

  ApiSettingsContent.fromJson(dynamic json) {
    _centralServer = json["CentralServer"];
    _serverList = json["ServerList"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["CentralServer"] = _centralServer;
    map["ServerList"] = _serverList;
    return map;
  }

}