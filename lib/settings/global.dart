import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

List<String> images=[];
List<CameraDescription> cameras = [];
const String GOOGLE_MAP_API = 'AIzaSyAs0P-uY0grNE0Eg4r-yuy4C931jKgXve8';

void _saveImageToGallery(String imagePath) async {
  try {
    final result = await GallerySaver.saveImage(imagePath);
    if (result != null) {
      print('Image saved to gallery: $result');
    } else {
      print('Failed to save image to gallery.');
    }
  } catch (e) {
    print('Error saving image to gallery: $e');
  }
}