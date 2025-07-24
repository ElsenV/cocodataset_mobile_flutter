abstract class Segmentation {
  final int categoryId;
  const Segmentation({required this.categoryId});
}

class PolygonSegmentation extends Segmentation {
  final List<List<double>> points;

  PolygonSegmentation({required this.points, required super.categoryId});
}

class RLESegmentation extends Segmentation {
  final List<int> counts;
  final List<int> size;

  RLESegmentation({
    required this.counts,
    required this.size,
    required super.categoryId,
  });
}
