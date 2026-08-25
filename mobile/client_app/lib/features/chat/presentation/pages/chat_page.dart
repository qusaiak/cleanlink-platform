import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/chat_error_code.dart';
import '../../domain/entities/chat_action.dart';
import '../../../payments/presentation/bloc/payments_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_input.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_typing_indicator.dart';
import '../widgets/chat_welcome.dart';
import '../widgets/chat_action_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.conversationId});
  final int? conversationId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  int? _chatPaymentOrderId;

  @override
  void initState() {
    super.initState();
    if (widget.conversationId case final int id) {
      context.read<ChatBloc>().add(LoadChatConversation(id));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      final nearBottom = position.maxScrollExtent - position.pixels < 260.h;
      if (nearBottom || position.maxScrollExtent == 0) {
        _scrollController.animateTo(
          position.maxScrollExtent,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _pay(int orderId) {
    _chatPaymentOrderId = orderId;
    final payments = context.read<PaymentsBloc>();
    payments.add(const ResetPaymentState());
    payments.add(
      PayForOrder(
        orderId: orderId,
        darkMode: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  void _handleAction(ChatAction action) {
    context.read<ChatBloc>().add(const ChatActionHandled());
    if (action.requiresPayment && action.orderId != null) {
      _pay(action.orderId!);
    }
  }

  void _onPaymentState(PaymentsState state) {
    if (_chatPaymentOrderId == null || state.orderId != _chatPaymentOrderId) {
      return;
    }
    final l = AppLocalizations.of(context)!;
    switch (state.stage) {
      case PaymentStage.succeeded:
        showToast(
          text: l.payment_confirmed,
          state: ToastState.success,
          shortDuration: true,
        );
        _chatPaymentOrderId = null;
      case PaymentStage.cancelled:
        showToast(
          text: l.chat_payment_cancelled,
          state: ToastState.error,
          shortDuration: true,
        );
        _chatPaymentOrderId = null;
      case PaymentStage.failed:
        showToast(
          text: l.chat_payment_failed,
          state: ToastState.error,
          shortDuration: true,
        );
        _chatPaymentOrderId = null;
      default:
        break;
    }
  }

  String _errorText(BuildContext context, Failure failure) {
    final l = AppLocalizations.of(context)!;
    final chatError = switch (failure.errorCode) {
      ChatErrorCode.quotaExceeded => l.chat_quota_exceeded,
      ChatErrorCode.temporarilyUnavailable => l.chat_temporarily_unavailable,
      ChatErrorCode.connectionError => l.chat_provider_connection_error,
      ChatErrorCode.error => l.chat_error,
      _ => null,
    };
    if (chatError != null) return chatError;
    return switch (failure.type) {
      AppFailureType.noInternet ||
      AppFailureType.timeout => l.chat_connection_error,
      _ => failure.message,
    };
  }

  void _confirmDelete(ChatState state) {
    final l = AppLocalizations.of(context)!;
    showAdaptiveDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ChatBloc>(),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, current) => CustomDialog(
            title: l.delete_conversation_title,
            body: l.delete_conversation_body,
            isLoading: current.isDeleting,
            isBackButtonDismiss: !current.isDeleting,
            cancelButtonText: l.cancel,
            doneButtonText: l.ok,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onTap: () =>
                context.read<ChatBloc>().add(const DeleteCurrentConversation()),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocListener<PaymentsBloc, PaymentsState>(
      listener: (_, state) => _onPaymentState(state),
      child: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) =>
            previous.messages.length != current.messages.length ||
            previous.isSending != current.isSending ||
            previous.failure != current.failure ||
            previous.deleteSucceeded != current.deleteSucceeded,
        listener: (context, state) {
          _scrollToLatest();
          if (state.failure case final Failure failure) {
            if (state.messages.isNotEmpty || state.failedMessage != null) {
              showToast(
                text: _errorText(context, failure),
                state: ToastState.error,
                shortDuration: true,
              );
              context.read<ChatBloc>().add(const ClearChatError());
            }
          }
          if (state.deleteSucceeded) {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            showToast(
              text: l.conversation_deleted,
              state: ToastState.success,
              shortDuration: true,
            );
          }
          if (state.actionToHandle case final ChatAction action) {
            _handleAction(action);
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(l.cleanlink_assistant),
            actions: [
              IconButton(
                tooltip: l.previous_chats,
                onPressed: state.isSending
                    ? null
                    : () => context.push(AppRouter.kChatConversations),
                icon: const Icon(Icons.history_rounded),
              ),
              IconButton(
                tooltip: l.new_chat,
                onPressed: state.isSending
                    ? null
                    : () => context.read<ChatBloc>().add(const OpenNewChat()),
                icon: const Icon(Icons.add_comment_outlined),
              ),
              if (state.conversationId != null)
                IconButton(
                  tooltip: l.delete_chat,
                  onPressed: state.isSending || state.isDeleting
                      ? null
                      : () => _confirmDelete(state),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : state.failure != null && state.messages.isEmpty
              ? AppErrorState(
                  failure: state.failure,
                  onRetry: () {
                    final id = widget.conversationId;
                    if (id != null) {
                      context.read<ChatBloc>().add(LoadChatConversation(id));
                    }
                  },
                )
              : Column(
                  children: [
                    Expanded(
                      child: state.messages.isEmpty
                          ? ChatWelcome(
                              title: l.cleanlink_assistant,
                              subtitle: l.chat_welcome_subtitle,
                              suggestions: [
                                l.suggestion_services,
                                l.suggestion_nearby,
                                l.suggestion_booking,
                                l.suggestion_compare,
                              ],
                              onSuggestion: (message) => context
                                  .read<ChatBloc>()
                                  .add(SendChatMessage(message)),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.fromLTRB(
                                14.w,
                                14.h,
                                14.w,
                                6.h,
                              ),
                              itemCount:
                                  state.messages.length +
                                  (state.isSending ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.messages.length) {
                                  return ChatTypingIndicator(
                                    label: l.assistant_typing,
                                  );
                                }
                                final message = state.messages[index];
                                final payment = context
                                    .watch<PaymentsBloc>()
                                    .state;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ChatMessageBubble(message: message),
                                    if (message.action
                                        case final ChatAction action)
                                      ChatActionView(
                                        action: action,
                                        isPaying:
                                            payment.isBusy &&
                                            payment.orderId == action.orderId,
                                        onSend: (value) => context
                                            .read<ChatBloc>()
                                            .add(SendChatMessage(value)),
                                        onViewBooking: (orderId) =>
                                            context.push(
                                              AppRouter.orderDetailsPath(
                                                orderId,
                                              ),
                                            ),
                                        onPay: _pay,
                                      ),
                                  ],
                                );
                              },
                            ),
                    ),
                    ChatInput(
                      enabled: !state.isSending && !state.isDeleting,
                      hint: l.ask_cleanlink,
                      onSend: (message) => context.read<ChatBloc>().add(
                        SendChatMessage(message),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
