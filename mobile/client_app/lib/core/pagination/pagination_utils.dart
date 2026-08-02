List<T> mergeWithoutDuplicates<T, Id>(
  List<T> current,
  List<T> incoming,
  Id Function(T item) getId, {
  T Function(T current, T incoming)? mergeExisting,
}) {
  final result = List<T>.of(current);
  final indexesById = <Id, int>{
    for (var index = 0; index < result.length; index++)
      getId(result[index]): index,
  };

  for (final item in incoming) {
    final id = getId(item);
    final existingIndex = indexesById[id];
    if (existingIndex == null) {
      indexesById[id] = result.length;
      result.add(item);
    } else {
      result[existingIndex] = mergeExisting == null
          ? item
          : mergeExisting(result[existingIndex], item);
    }
  }

  return List.unmodifiable(result);
}
