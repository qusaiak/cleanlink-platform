enum ServiceStatus {
  assigned,
  onTheWay,
  arrived,
  serviceStarted,
  completed;

  static ServiceStatus fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'assigned':
        return ServiceStatus.assigned;
      case 'on_the_way':
      case 'on the way':
        return ServiceStatus.onTheWay;
      case 'arrived':
        return ServiceStatus.arrived;
      case 'service_started':
      case 'service started':
      case 'started':
        return ServiceStatus.serviceStarted;
      case 'completed':
        return ServiceStatus.completed;
      default:
        return ServiceStatus.assigned;
    }
  }

  /// The raw value used by the backend.
  String get key {
    switch (this) {
      case ServiceStatus.assigned:
        return 'assigned';
      case ServiceStatus.onTheWay:
        return 'on_the_way';
      case ServiceStatus.arrived:
        return 'arrived';
      case ServiceStatus.serviceStarted:
        return 'service_started';
      case ServiceStatus.completed:
        return 'completed';
    }
  }

  /// Normalized progress (0.0 -> 1.0) used to animate the map route.
  double get progress {
    switch (this) {
      case ServiceStatus.assigned:
        return 0.05;
      case ServiceStatus.onTheWay:
        return 0.45;
      case ServiceStatus.arrived:
        return 0.8;
      case ServiceStatus.serviceStarted:
        return 0.95;
      case ServiceStatus.completed:
        return 1.0;
    }
  }
}
