class Endpoints {
  Endpoints._();
 
  static const cocoCategoriesUrl =
      'https://cocodataset.org/other/cocoexplorer.js';

  static const cocoDatasetUrl =
      'https://us-central1-open-images-dataset.cloudfunctions.net/coco-dataset-bigquery';

  static String categoryIcon(int? id) => id == null
      ? 'https://cocodataset.org/images/cocoicons/blank.jpg'
      : 'https://cocodataset.org/images/cocoicons/$id.jpg';
}
