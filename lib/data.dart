class data{
  String _title;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String _discription;

  String get discription => _discription;

  set discription(String value) {
    _discription = value;
  }

  data();

  data.fromJson(Map<String, dynamic> json)
      : _title = json['title'],
        _discription = json['discription'];

  Map<String, dynamic> toJson() => {
    'title': _title,
    'discription': _discription,
  };

}