extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

extension ListExtensions<T> on List<T> {
  /// Safely updates an item at the given index.
  void safeUpdate(int index, T item) {
    if (index >= 0 && index < this.length) {
      this[index] = item;
    }
  }

  void safeUpdateOrAdd(int index, T item) {
    if (index >= 0 && index < this.length) {
      print("list==if");
      this[index] = item;
    } else {
      print("list==else");
      this.add(item);
    }
  }

  /// Safely removes items that match the given condition.
  void safeRemoveWhere(bool Function(T) condition) {
    this.removeWhere(condition);
  }

  /// Finds the first item that matches the given condition.
  /// Returns null if no item is found.
  T? safeFirstWhere(bool Function(T) condition) {
    try {
      return this.firstWhere(condition);
    } catch (e) {
      return null;
    }
  }

  /// Checks if the list is null or empty.
  bool isNullOrEmpty() => this == null || this.isEmpty;
}
