
import 'package:permission_handler/permission_handler.dart';

class PermissionService{
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission() async {
    var result = await _permissionHandler.requestPermissions([PermissionGroup.phone,PermissionGroup.contacts,PermissionGroup.sms,PermissionGroup.storage]);
    if (result == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission();
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }
}