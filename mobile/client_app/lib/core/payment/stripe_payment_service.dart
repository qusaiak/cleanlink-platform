import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService {
  const StripePaymentService();

  Future<void> initPaymentSheet({
    required String clientSecret,
    required bool darkMode,
  }) async {
    _debugLog(
      'before initPaymentSheet '
      '(clientSecretPresent=${clientSecret.isNotEmpty}, darkMode=$darkMode)',
    );

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'CleanLink',
          style: darkMode ? ThemeMode.dark : ThemeMode.light,
        ),
      );

      _debugLog('after initPaymentSheet');
    } on StripeException catch (error, stackTrace) {
      _debugStripeError('initPaymentSheet', error, stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      _debugUnexpectedError('initPaymentSheet', error, stackTrace);
      rethrow;
    }
  }

  Future<void> presentPaymentSheet() async {
    _debugLog('before presentPaymentSheet');

    try {
      await Stripe.instance.presentPaymentSheet();
      _debugLog('after presentPaymentSheet');
    } on StripeException catch (error, stackTrace) {
      _debugStripeError('presentPaymentSheet', error, stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      _debugUnexpectedError('presentPaymentSheet', error, stackTrace);
      rethrow;
    }
  }

  void _debugStripeError(
    String operation,
    StripeException exception,
    StackTrace stackTrace,
  ) {
    if (!kDebugMode) return;

    final error = exception.error;

    debugPrint(
      '[StripePaymentSheet] $operation failed: '
      'code=${error.code}, '
      'message=${error.message}, '
      'localizedMessage=${error.localizedMessage}, '
      'stripeErrorCode=${error.stripeErrorCode}, '
      'declineCode=${error.declineCode}, '
      'type=${error.type}',
    );

    debugPrintStack(
      label: '[StripePaymentSheet] $operation stack trace',
      stackTrace: stackTrace,
    );
  }

  void _debugUnexpectedError(
    String operation,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!kDebugMode) return;

    debugPrint('[StripePaymentSheet] $operation unexpected error: $error');

    debugPrintStack(
      label: '[StripePaymentSheet] $operation stack trace',
      stackTrace: stackTrace,
    );
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[StripePaymentSheet] $message');
    }
  }
}
