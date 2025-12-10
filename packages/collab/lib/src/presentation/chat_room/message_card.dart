import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.isMe,
    required this.userName,
    required this.userId,
    required this.imageUrl,
    this.timestamp,
  });

  final String message;
  final bool isMe;
  final String userName;
  final String userId;
  final String? timestamp;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // SmallUserImage(colors: colors, userId: userId),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colors.primary,

                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.transparent,
                // color: Colors.white,
                size: 35.0,
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? colors.primary : colors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      userName,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface.withAlpha(150),
                      ),
                    ),
                  if (!isMe) const SizedBox(height: 4),

                  // MESSAGE
                  Text(
                    message,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: isMe ? colors.onSurface : colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 4),

                  if (timestamp != null)
                    Text(
                      timestamp!,
                      style: GoogleFonts.lato(
                        color: colors.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            const SizedBox(width: 8),
            // SmallUserImage(colors: colors, userId: userId),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colors.primary,

                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.transparent,
                // color: Colors.white,
                size: 35.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
