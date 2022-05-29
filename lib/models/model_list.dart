import 'dart:collection';
import 'dart:math';

import 'package:mml_admin/models/model_base.dart';

class ModelList extends ListBase<ModelBase?> {

  List<ModelBase?> _l = [];

  int totalCount;


  ModelList(List<ModelBase> data, int offset, this.totalCount) {
    _l = [];
    _l.length = totalCount;
    _l.replaceRange(offset, min(_l.length, offset + data.length), data);
  }

  @override
  set length(int newLength) {
    throw UnimplementedError();
  }

  @override
  int get length => _l.length;

  @override
  ModelBase? operator [](int index) => _l[index];

  @override
  void operator []=(int index, ModelBase? value) {
    throw UnimplementedError();
  }
}
