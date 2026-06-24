import 'package:flutter/material.dart';

import '../storage/shared_storage.dart';
import '../storage/storage_data.dart';

class UserSession extends ChangeNotifier {
  String? fullname;
  String? email;
  String? token;
  String? phone;
  String? address;
  String? image;

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  Future<void> load() async {
    fullname = await SharedStorage.get<String>(StorageData.fullName);
    email = await SharedStorage.get<String>(StorageData.email);
    token = await SharedStorage.get<String>(StorageData.token);
    phone = await SharedStorage.get<String>(StorageData.phone);
    address = await SharedStorage.get<String>(StorageData.address);
    image = await SharedStorage.get<String>(StorageData.image);
    notifyListeners();
  }

  Future<void> updateAuthLogin({
    required String fullname,
    required String email,
    required String token,
    required String phone,
    required String address,
    required String image,
  }) async {
    this.fullname = fullname;
    this.email = email;
    this.token = token;
    this.phone = phone;
    this.address = address;
    this.image = image;
    await SharedStorage.set(StorageData.fullName, fullname);
    await SharedStorage.set(StorageData.email, email);
    await SharedStorage.set(StorageData.token, token);
    await SharedStorage.set(StorageData.phone, phone);
    await SharedStorage.set(StorageData.address, address);
    await SharedStorage.set(StorageData.image, image);
    notifyListeners();
  }

  Future<void> updateAuthRegister({
    required String fullname,
    required String email,
    required String token,
  }) async {
    this.fullname = fullname;
    this.email = email;
    this.token = token;
    await SharedStorage.set(StorageData.fullName, fullname);
    await SharedStorage.set(StorageData.email, email);
    await SharedStorage.set(StorageData.token, token);
    notifyListeners();
  }

  Future<void> updateProfile({
    required String phone,
    required String address,
    required String image,
  }) async {
    this.phone = phone;
    this.address = address;
    this.image = image;
    await SharedStorage.set(StorageData.phone, phone);
    await SharedStorage.set(StorageData.address, address);
    await SharedStorage.set(StorageData.image, image);
    notifyListeners();
  }

  Future<void> clear() async {
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
