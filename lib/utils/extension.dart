extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

extension ListExtensions<T> on List<T> {
  void safeUpdate(int index, T item) {
    if (index >= 0 && index < length) {
      this[index] = item;
    }
  }

  void safeUpdateOrAdd(int index, T item) {
    if (index >= 0 && index < length) {
      this[index] = item;
    } else {
      add(item);
    }
  }

  void safeRemoveWhere(bool Function(T) condition) {
    removeWhere(condition);
  }

  T? safeFirstWhere(bool Function(T) condition) {
    try {
      return firstWhere(condition);
    } catch (e) {
      return null;
    }
  }
}
