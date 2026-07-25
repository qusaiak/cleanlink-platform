import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

/// Concrete [NotificationsRepository]: connectivity guard + Dio→Failure
/// mapping, mirroring `TasksRepositoryImpl` / `WorkerProfileRepositoryImpl`.
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
    } catch (e) {
      return Left(ServerFailure(e.toString(), ''));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() =>
      _guard(() => remoteDataSource.getNotifications());

  @override
  Future<Either<Failure, AppNotification>> markAsRead(String id) =>
      _guard(() => remoteDataSource.markAsRead(id));

  @override
  Future<Either<Failure, List<AppNotification>>> markAllAsRead() =>
      _guard(() => remoteDataSource.markAllAsRead());
}
