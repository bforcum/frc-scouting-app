import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/model/form_data.dart';

part 'form_data_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentFormData extends _$CurrentFormData {
  @override
  FormDataModel build() {
    return FormDataModel.empty();
  }

  void setValue(String key, dynamic value) {
    var data = state.data.entries;
    data = data.map((e) => MapEntry(e.key, e.key == key ? value : e.value));
    state = state.copyWith(data: Map.fromEntries(data));
  }

  dynamic getValue(String key) {
    return state.data[key];
  }

  void clear() {
    var data = state.data.entries;
    data = data.map((e) => MapEntry(e.key, null));
    state = state.copyWith(data: Map.fromEntries(data));
  }
}
