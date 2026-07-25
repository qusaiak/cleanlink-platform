import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/service_summary.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

/// Concrete [SearchRepository]: connectivity guard + Dio→Failure mapping,
/// mirroring the other repositories.
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
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
  Future<Either<Failure, List<ServiceSummary>>> search(SearchQuery query) =>
      _guard(() => remoteDataSource.search(query));
}
