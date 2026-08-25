import 'dart:async';

import 'package:client_app/config/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chat_conversation.dart';
import '../bloc/chat_conversations_bloc.dart';

class ChatConversationsPage extends StatefulWidget {
  const ChatConversationsPage({super.key});

  @override
  State<ChatConversationsPage> createState() => _ChatConversationsPageState();
}

class _ChatConversationsPageState extends State<ChatConversationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatConversationsBloc>().add(const LoadChatConversations());
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<ChatConversationsBloc>().add(
      RefreshChatConversations(completer),
    );
    return completer.future;
  }

  void _confirmDelete(ChatConversation conversation) {
    final l = AppLocalizations.of(context)!;
    showAdaptiveDialog<void>(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: l.delete_conversation_title,
        body: l.delete_conversation_body,
        cancelButtonText: l.cancel,
        doneButtonText: l.ok,
        onCancel: () => Navigator.of(dialogContext).pop(),
        onTap: () {
          Navigator.of(dialogContext).pop();
          context.read<ChatConversationsBloc>().add(
            DeleteChatConversation(conversation.id),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.previous_chats),
        actions: [
          IconButton(
            tooltip: l.new_chat,
            onPressed: () => context.pushReplacement(AppRouter.kChat),
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: BlocConsumer<ChatConversationsBloc, ChatConversationsState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (context, state) {
          if (state.failure case final Failure failure
              when state.conversations.isNotEmpty) {
            final message = switch (failure.type) {
              AppFailureType.noInternet ||
              AppFailureType.timeout => l.chat_connection_error,
              _ => failure.message,
            };
            showToast(
              text: message,
              state: ToastState.error,
              shortDuration: true,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.conversations.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (state.failure != null && state.conversations.isEmpty) {
            return AppErrorState(
              failure: state.failure,
              onRetry: () => context.read<ChatConversationsBloc>().add(
                const LoadChatConversations(),
              ),
            );
          }
          if (state.conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * .18),
                  AppEmptyState(
                    icon: Icons.forum_outlined,
                    title: l.no_previous_conversations,
                    body: l.no_previous_conversations_message,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: EdgeInsets.all(14.w),
              itemCount: state.conversations.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return _ConversationCard(
                  conversation: conversation,
                  deleting: state.deletingId == conversation.id,
                  onTap: () =>
                      context.push(AppRouter.chatPath(conversation.id)),
                  onDelete: () => _confirmDelete(conversation),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.conversation,
    required this.deleting,
    required this.onTap,
    required this.onDelete,
  });

  final ChatConversation conversation;
  final bool deleting;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final updatedAt = conversation.updatedAt?.toLocal();

    final date = updatedAt == null
        ? ''
        : '${MaterialLocalizations.of(context).formatCompactDate(updatedAt)} - '
              '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(updatedAt))}';

    final title = conversation.title?.trim().isNotEmpty == true
        ? conversation.title!.trim()
        : l.cleanlink_assistant;

    return GestureDetector(
      onTap: deleting ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? colors.surfaceContainerHigh : colors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .10 : .04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: colors.primary,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      if (conversation.messagesCount != null) ...[
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 14.sp,
                          color: colors.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            l.message_count(conversation.messagesCount!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle12.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (date.isNotEmpty) ...[
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14.sp,
                          color: colors.onSurfaceVariant,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.textStyle12.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            if (deleting)
              SizedBox(
                width: 22.r,
                height: 22.r,
                child: spinKitApp(colors.primary),
              )
            else
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: colors.error,
                    size: 21.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
