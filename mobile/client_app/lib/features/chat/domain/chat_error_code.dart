abstract final class ChatErrorCode {
  static const quotaExceeded = 'CHAT_QUOTA_EXCEEDED';
  static const temporarilyUnavailable = 'CHAT_TEMPORARILY_UNAVAILABLE';
  static const connectionError = 'CHAT_CONNECTION_ERROR';
  static const error = 'CHAT_ERROR';

  static const values = {
    quotaExceeded,
    temporarilyUnavailable,
    connectionError,
    error,
  };
}
