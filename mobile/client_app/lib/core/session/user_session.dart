import 'package:flutter/material.dart';

import '../auth/user_role.dart';
import '../storage/shared_storage.dart';
import '../storage/storage_data.dart';

class UserSession extends ChangeNotifier {
  int? id;
  String? role;
  String? fullname;
  String? email;
  String? token;
  String? phone;
  String? address;
  String? image;

  bool get hasToken => token != null && token!.isNotEmpty;

  bool get isAuthenticated =>
      hasToken && UserRole.parse(role) == UserRole.client;

  Future<void> load() async {
    id = await SharedStorage.get<int>(StorageData.userId);
    role = await SharedStorage.get<String>(StorageData.role);
    fullname = await SharedStorage.get<String>(StorageData.fullName);
    email = await SharedStorage.get<String>(StorageData.email);
    token = await SharedStorage.get<String>(StorageData.token);
    phone = await SharedStorage.get<String>(StorageData.phone);
    address = await SharedStorage.get<String>(StorageData.address);
    image = await SharedStorage.get<String>(StorageData.image);
    if (hasToken && !isAuthenticated) {
      await clear();
      return;
    }
    notifyListeners();
  }

  Future<void> updateAuthenticatedUser({
    required int id,
    required String role,
    required String fullname,
    required String email,
    required String token,
    String phone = '',
    String address = '',
    String image = '',
  }) async {
    this.id = id;
    this.role = role;
    this.fullname = fullname;
    this.email = email;
    this.token = token;
    this.phone = phone;
    this.address = address;
    this.image = image;
    await SharedStorage.set(StorageData.userId, id);
    await SharedStorage.set(StorageData.role, role);
    await SharedStorage.set(StorageData.fullName, fullname);
    await SharedStorage.set(StorageData.email, email);
    await SharedStorage.set(StorageData.token, token);
    await SharedStorage.set(StorageData.phone, phone);
    await SharedStorage.set(StorageData.address, address);
    await SharedStorage.set(StorageData.image, image);
    notifyListeners();
  }

  Future<void> updateProfile({
    String? fullname,
    String? email,
    required String phone,
    required String address,
    required String image,
  }) async {
    if (fullname != null) {
      this.fullname = fullname;
      await SharedStorage.set(StorageData.fullName, fullname);
    }
    if (email != null) {
      this.email = email;
      await SharedStorage.set(StorageData.email, email);
    }
    this.phone = phone;
    this.address = address;
    this.image = image;
    await SharedStorage.set(StorageData.phone, phone);
    await SharedStorage.set(StorageData.address, address);
    await SharedStorage.set(StorageData.image, image);
    notifyListeners();
  }

  Future<void> clear() async {
    id = null;
    role = null;
    fullname = null;
    email = null;
    token = null;
    phone = null;
    address = null;
    image = null;
    await SharedStorage.clear();
    notifyListeners();
  }
}
