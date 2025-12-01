import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(this.imageUrl, {this.radius = 80.0, super.key});

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      // backgroundColor: colors.secondary,
      backgroundImage: NetworkImage(imageUrl),
      onBackgroundImageError: (exception, stackTrace) =>
          debugPrint('Error fetching imageUrl : $exception'),
      radius: radius,
      // child: Icon(Icons.person_outline, color: colors.onSurface, size: 95.0),
    );
  }
}
