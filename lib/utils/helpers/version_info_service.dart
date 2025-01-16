import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
