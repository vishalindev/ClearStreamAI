import 'package:flutter/foundation.dart';

import '../../core/roles.dart';

class AuthController extends ChangeNotifier {
  RoleName _activeRole = RoleName.platformAdmin;
  String _tenantName = 'Default Tenant';

  RoleName get activeRole => _activeRole;
  String get tenantName => _tenantName;

  void updateRole(RoleName role) {
    _activeRole = role;
    notifyListeners();
  }

  void updateTenant(String tenantName) {
    _tenantName = tenantName;
    notifyListeners();
  }
}
