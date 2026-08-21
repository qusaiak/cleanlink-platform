import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        ConnectionFailure('No Internet Connection', ErrorCode.noInternet),
      );
    }
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } on FormatException catch (e, stackTrace) {
      log(
        'notifications payload could not be parsed: ${e.message}',
        name: 'Notifications',
        error: e,
        stackTrace: stackTrace,
      );
      return const Left(ServerFailure('', ErrorCode.badResponseFormat));
    } catch (e, stackTrace) {
      log(
        'notifications request failed',
        name: 'Notifications',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(e.toString(), ''));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() =>
      _guard(() => remoteDataSource.getNotifications());

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) => _guard(() async {
    await remoteDataSource.markAsRead(id);
    return unit;
  });

  @override
  Future<Either<Failure, List<AppNotification>>> markAllAsRead() =>
      _guard(() => remoteDataSource.markAllAsRead());
}
