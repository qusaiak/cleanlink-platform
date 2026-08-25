import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isUser = message.isUser;
    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .78,
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isUser ? colors.primary : colors.secondaryContainer,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(18.r),
            topEnd: Radius.circular(18.r),
            bottomStart: Radius.circular(isUser ? 18.r : 4.r),
            bottomEnd: Radius.circular(isUser ? 4.r : 18.r),
          ),
          border: isUser
              ? null
              : Border.all(color: colors.outlineVariant.withValues(alpha: .35)),
        ),
        child: isUser
            ? Text(
                message.content,
                textDirection: _direction(message.content),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onPrimary,
                  height: 1.5,
                ),
              )
            : MarkdownBody(
                data: message.content,
                selectable: true,
                softLineBreak: true,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                      p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        height: 1.5,
                      ),
                      h1: Theme.of(context).textTheme.titleLarge,
                      h2: Theme.of(context).textTheme.titleMedium,
                      h3: Theme.of(context).textTheme.titleSmall,
                      listBullet: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                      blockquoteDecoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8.r),
                        border: BorderDirectional(
                          start: BorderSide(color: colors.primary, width: 3),
                        ),
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
              ),
      ),
    );
  }

  TextDirection _direction(String text) {
    final firstLetter = RegExp(
      r'[A-Za-z\u0600-\u06FF]',
    ).firstMatch(text)?.group(0);
    return firstLetter != null &&
            RegExp(r'[\u0600-\u06FF]').hasMatch(firstLetter)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}
