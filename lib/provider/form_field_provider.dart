import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_field_provider.g.dart';

@Riverpod(keepAlive: true)
class FormFieldNotifier extends _$FormFieldNotifier {
  @override
  dynamic build(String key) {
    return null;
  }

  void setValue(dynamic value) {
    state = value;
  }
}

@riverpod
class FormReset extends _$FormReset {
  @override
  int build() => 0;

  void reset() {
    state += 1; // Reset the state to trigger rebuilds
    ref.notifyListeners();
  }
}
