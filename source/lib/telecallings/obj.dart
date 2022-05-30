class Application {
  final int id;
  final int tid;
  final int uid;
  final List<Datas> data;

  Application({this.id, this.tid, this.uid, this.data});

  factory Application.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Datas> datasList = list.map((i) => Datas.fromJson(i)).toList();

    return Application(
        id: parsedJson['id'],
        tid: parsedJson['tid'],
        uid: parsedJson['uid'],
        data: datasList);
  }
}

class Datas {
  final String dataName;
  final int dataNumber;
  final String dataLang;

  Datas({this.dataName, this.dataNumber, this.dataLang});
  factory Datas.fromJson(Map<String, dynamic> parsedJson) {
    return Datas(
        dataName: parsedJson['Name'],
        dataNumber: parsedJson['Mobile Number'],
        dataLang: parsedJson['Language']);
  }
}
