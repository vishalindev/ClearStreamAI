import '../../core/roles.dart';

class AppRouteDef {
  const AppRouteDef({required this.path, required this.title, required this.roles});

  final String path;
  final String title;
  final List<RoleName> roles;
}

const defaultRoles = [
  RoleName.superAdmin,
  RoleName.platformAdmin,
  RoleName.platformUser,
  RoleName.manager,
];

const managerRoles = [
  RoleName.superAdmin,
  RoleName.platformAdmin,
  RoleName.manager,
];

const appRouteDefinitions = <AppRouteDef>[
  AppRouteDef(path: '/dashboard', title: 'Dashboard', roles: defaultRoles),
  AppRouteDef(path: '/live-streaming', title: 'Live Streaming', roles: defaultRoles),
  AppRouteDef(path: '/alertrecipients', title: 'Alert Recipients', roles: managerRoles),
  AppRouteDef(path: '/savedfiles', title: 'Saved Files', roles: defaultRoles),
  AppRouteDef(path: '/ladlehose', title: 'Ladlehose', roles: defaultRoles),
  AppRouteDef(path: '/plantview', title: 'Plant View', roles: managerRoles),
  AppRouteDef(path: '/plant', title: 'Plant Setup', roles: managerRoles),
  AppRouteDef(path: '/platformuser', title: 'Platform User', roles: managerRoles),
  AppRouteDef(path: '/recipientgroups', title: 'Recipient Groups', roles: managerRoles),
  AppRouteDef(path: '/preview-camera/:id', title: 'Preview Camera', roles: defaultRoles),
  AppRouteDef(path: '/rule', title: 'Rules', roles: managerRoles),
  AppRouteDef(path: '/resetpwd', title: 'Reset Password', roles: managerRoles),
  AppRouteDef(path: '/camera', title: 'Camera', roles: managerRoles),
  AppRouteDef(path: '/zone', title: 'Zone', roles: managerRoles),
  AppRouteDef(path: '/wip', title: 'WIP', roles: defaultRoles),
  AppRouteDef(path: '/notification-description/:id', title: 'Notification Description', roles: defaultRoles),
  AppRouteDef(path: '/streaming-alert-details/:id/:cameraId/:isFrom', title: 'Streaming Alert Details', roles: defaultRoles),
  AppRouteDef(path: '/streaming-details/:id/:cameraId/:isFrom', title: 'Streaming Details', roles: defaultRoles),
  AppRouteDef(path: '/preview-zone/:id', title: 'Preview Zone', roles: defaultRoles),
  AppRouteDef(path: '/auth-dashboard', title: 'Auth Dashboard', roles: defaultRoles),
  AppRouteDef(path: '/vehicle-report', title: 'Vehicle Report', roles: defaultRoles),
  AppRouteDef(path: '/anamolies-report', title: 'Anomalies Report', roles: defaultRoles),
  AppRouteDef(path: '/usage-report', title: 'Usage Report', roles: managerRoles),
  AppRouteDef(path: '/ladlehose-report', title: 'Ladlehose Report', roles: managerRoles),
  AppRouteDef(path: '/attendance-report', title: 'Attendance Report', roles: managerRoles),
  AppRouteDef(path: '/mg-punch-in', title: 'Manager Punch In', roles: managerRoles),
  AppRouteDef(path: '/tg-punch-out', title: 'Target Punch Out', roles: managerRoles),
  AppRouteDef(path: '/department', title: 'Department', roles: managerRoles),
  AppRouteDef(path: '/analytics', title: 'Analytics', roles: managerRoles),
  AppRouteDef(path: '/all-notification', title: 'All Notifications', roles: defaultRoles),
  AppRouteDef(path: '/camera-dashboard/:id', title: 'Camera Dashboard', roles: defaultRoles),
  AppRouteDef(path: '/about', title: 'About', roles: defaultRoles),
  AppRouteDef(path: '/searchbyid', title: 'Search by ID', roles: defaultRoles),
  AppRouteDef(path: '/insights', title: 'Insights', roles: managerRoles),
  AppRouteDef(path: '/deep-insights', title: 'Deep Insights', roles: managerRoles),
  AppRouteDef(path: '/trend-charts', title: 'Trend Charts', roles: managerRoles),
  AppRouteDef(path: '/usage-metrics', title: 'Usage Metrics', roles: managerRoles),
  AppRouteDef(path: '/notification-management', title: 'Notification Management', roles: managerRoles),
  AppRouteDef(path: '/error-component', title: 'Error Component', roles: defaultRoles),
  AppRouteDef(path: '/my-ticket', title: 'My Ticket', roles: defaultRoles),
  AppRouteDef(path: '/user-preference', title: 'User Preferences', roles: defaultRoles),
  AppRouteDef(path: '/client', title: 'Client', roles: defaultRoles),
  AppRouteDef(path: '/unit', title: 'Unit', roles: defaultRoles),
  AppRouteDef(path: '/corporate-dashboard', title: 'Corporate Dashboard', roles: [RoleName.corporate]),
];
