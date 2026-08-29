enum UserRole {
  admin,
  regionManager,
  companyManager,
  client,
  worker,
  unknown;

  static UserRole parse(String? value) {
    return switch (value?.trim()) {
      'admin' => UserRole.admin,
      'region_manager' => UserRole.regionManager,
      'company_manager' => UserRole.companyManager,
      'client' => UserRole.client,
      'worker' => UserRole.worker,
      _ => UserRole.unknown,
    };
  }
}
