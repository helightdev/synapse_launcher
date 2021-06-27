class Account {
  String _id;
  String _name;
  List<Groups> _groups;

  String get id => _id;
  String get name => _name;
  List<Groups> get groups => _groups;

  bool get isStaff => groups.any((element) => element.staff);

  Account({
      String id, 
      String name, 
      List<Groups> groups}){
    _id = id;
    _name = name;
    _groups = groups;
}

  Account.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    if (json["groups"] != null) {
      _groups = [];
      json["groups"].forEach((v) {
        _groups.add(Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    if (_groups != null) {
      map["groups"] = _groups.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Groups {
  String _id;
  String _name;
  String _color;
  List<String> _permissions;
  bool _remoteAdmin;
  bool _kickable;
  bool _bannable;
  bool _kick;
  bool _ban;
  bool _hidden;
  bool _staff;

  String get id => _id;
  String get name => _name;
  String get color => _color;
  List<String> get permissions => _permissions;
  bool get remoteAdmin => _remoteAdmin;
  bool get kickable => _kickable;
  bool get bannable => _bannable;
  bool get kick => _kick;
  bool get ban => _ban;
  bool get hidden => _hidden;
  bool get staff => _staff;

  Groups({
      String id, 
      String name, 
      String color, 
      List<String> permissions, 
      bool remoteAdmin, 
      bool kickable, 
      bool bannable, 
      bool kick, 
      bool ban, 
      bool hidden, 
      bool staff}){
    _id = id;
    _name = name;
    _color = color;
    _permissions = permissions;
    _remoteAdmin = remoteAdmin;
    _kickable = kickable;
    _bannable = bannable;
    _kick = kick;
    _ban = ban;
    _hidden = hidden;
    _staff = staff;
}

  Groups.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _color = json["color"];
    _permissions = json["permissions"] != null ? json["permissions"].cast<String>() : [];
    _remoteAdmin = json["remoteAdmin"];
    _kickable = json["kickable"];
    _bannable = json["bannable"];
    _kick = json["kick"];
    _ban = json["ban"];
    _hidden = json["hidden"];
    _staff = json["staff"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["color"] = _color;
    map["permissions"] = _permissions;
    map["remoteAdmin"] = _remoteAdmin;
    map["kickable"] = _kickable;
    map["bannable"] = _bannable;
    map["kick"] = _kick;
    map["ban"] = _ban;
    map["hidden"] = _hidden;
    map["staff"] = _staff;
    return map;
  }

}