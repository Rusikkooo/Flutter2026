import 'package:flutter/material.dart';

import 'contacts.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // A RenderFlex overflowed by 378 pixels on the right.
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(child: Text(contact.initial)),
                if (contact.unread > 0)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${contact.unread}',
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(contact.name, style: theme.textTheme.titleMedium),
                  Text(contact.email, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
