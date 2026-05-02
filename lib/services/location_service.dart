import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // kiem tra quyen truy cap vi tri
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location service chua bat'); // debug
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Quyen vi tri bi tu choi'); // debug
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Quyen vi tri bi tu choi vinh vien'); // debug
      return false;
    }

    return true;
  }

  // lay vi tri GPS hien tai
  Future<Position> getCurrentLocation() async {
    bool hasPermission = await checkPermission();

    if (!hasPermission) {
      throw Exception('Quyền truy cập vị trí bị từ chối');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // lay ten thanh pho tu toa do (reverse geocoding)
  Future<String> getCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ??
            placemarks[0].subAdministrativeArea ??
            'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      print('Loi geocoding: $e'); // debug
      throw Exception('Không thể xác định tên thành phố');
    }
  }
}
