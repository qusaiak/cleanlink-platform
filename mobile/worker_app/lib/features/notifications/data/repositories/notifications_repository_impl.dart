import 'dart:developer';

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
    } on FormatException catch (e, stackTrace) {
      // The request SUCCEEDED but the body could not be read as the expected
      // shape. Kept distinct from the catch-all below so it carries a real
      // error code — `localizedFailureMessage` then shows the app's own
      // localized wording instead of a raw Dart exception string, and the log
      // keeps the detail needed to diagnose it.
      log(
        'notifications payload could not be parsed: ${e.message}',
        name: 'Notifications',
        error: e,
        stackTrace: stackTrace,
      );
      return const Left(ServerFailure('', ErrorCode.badResponseFormat));
    } catch (e, stackTrace) {
      // Last resort. Logged with its stack trace: this used to swallow parse
      // errors (a `TypeError` from casting the paginated envelope to a List)
      // into an opaque message with no way to tell where it came from.
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
