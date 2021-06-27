class Server {
  String _id;
  String _address;
  int _onlinePlayers;
  int _maxPlayers;
  String _pastebin;
  String _info;
  String _version;
  bool _whitelist;
  bool _friendlyFire;
  int _officialCode;
  bool _verified;
  String _language;
  String _owner;

  String get id => _id;
  String get address => _address;
  int get onlinePlayers => _onlinePlayers;
  int get maxPlayers => _maxPlayers;
  String get pastebin => _pastebin;
  String get info => _info;
  String get version => _version;
  bool get whitelist => _whitelist;
  bool get friendlyFire => _friendlyFire;
  int get officialCode => _officialCode;
  bool get verified => _verified;
  String get language => _language;
  String get owner => _owner;

  Server({
      String id, 
      String address, 
      int onlinePlayers, 
      int maxPlayers, 
      String pastebin, 
      String info, 
      String version, 
      bool whitelist, 
      bool friendlyFire, 
      int officialCode, 
      bool verified, 
      String language, 
      String owner}){
    _id = id;
    _address = address;
    _onlinePlayers = onlinePlayers;
    _maxPlayers = maxPlayers;
    _pastebin = pastebin;
    _info = info;
    _version = version;
    _whitelist = whitelist;
    _friendlyFire = friendlyFire;
    _officialCode = officialCode;
    _verified = verified;
    _language = language;
    _owner = owner;
}

  Server.fromJson(dynamic json) {
    _id = json["id"];
    _address = json["address"];
    _onlinePlayers = json["onlinePlayers"];
    _maxPlayers = json["maxPlayers"];
    _pastebin = json["pastebin"];
    _info = json["info"];
    _version = json["version"];
    _whitelist = json["whitelist"];
    _friendlyFire = json["friendlyFire"];
    _officialCode = json["officialCode"];
    _verified = json["verified"];
    _language = json["language"];
    _owner = json["owner"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["address"] = _address;
    map["onlinePlayers"] = _onlinePlayers;
    map["maxPlayers"] = _maxPlayers;
    map["pastebin"] = _pastebin;
    map["info"] = _info;
    map["version"] = _version;
    map["whitelist"] = _whitelist;
    map["friendlyFire"] = _friendlyFire;
    map["officialCode"] = _officialCode;
    map["verified"] = _verified;
    map["language"] = _language;
    map["owner"] = _owner;
    return map;
  }

  Server copyWith({
    String id,
    String address,
    int onlinePlayers,
    int maxPlayers,
    String pastebin,
    String info,
    String version,
    bool whitelist,
    bool friendlyFire,
    int officialCode,
    bool verified,
    String language,
    String owner,
  }) {
    return new Server(
      id: id ?? this._id,
      address: address ?? this._address,
      onlinePlayers: onlinePlayers ?? this._onlinePlayers,
      maxPlayers: maxPlayers ?? this._maxPlayers,
      pastebin: pastebin ?? this._pastebin,
      info: info ?? this._info,
      version: version ?? this._version,
      whitelist: whitelist ?? this._whitelist,
      friendlyFire: friendlyFire ?? this._friendlyFire,
      officialCode: officialCode ?? this._officialCode,
      verified: verified ?? this._verified,
      language: language ?? this._language,
      owner: owner ?? this._owner,
    );
  }
}