enum RoleName {
  superAdmin,
  platformAdmin,
  platformUser,
  manager,
  corporate,
}

extension RoleNameX on RoleName {
  String get label {
    switch (this) {
      case RoleName.superAdmin:
        return 'SuperAdmin';
      case RoleName.platformAdmin:
        return 'PlatformAdmin';
      case RoleName.platformUser:
        return 'PlatformUser';
      case RoleName.manager:
        return 'Manager';
      case RoleName.corporate:
        return 'Corporate';
    }
  }
}
