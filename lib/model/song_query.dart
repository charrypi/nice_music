//import 'package:nicemusic/model/abstract_query.dart';

import 'package:nicemusic/model/abstract_query.dart';

class SongQuery<T> extends Query<T> {
  Map<String, dynamic> conditions;

  SongQuery({this.conditions});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conditions != null) {
      data['conditions'] = this.conditions.toString();
    }
    return data;
  }
}
