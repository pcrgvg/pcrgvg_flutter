part of 'extensions.dart';

extension ListExt<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isSafeNotEmpty => !isNullOrEmpty;

  T? getOrNull(final int index) {
    if (isNullOrEmpty) {
      return null;
    }
    return this![index];
  }
  /// 列表相等
  bool eq(List<T>? other) {
    if (this == null) {
      return other == null;
    }
    if (other == null || this!.length != other.length) {
      return false;
    }
    for (int index = 0; index < this!.length; index += 1) {
      if (this![index] != other[index]) {
        return false;
      }
    }
    return true;
  }

  bool ne(List<T>? other) => !eq(other);
}
