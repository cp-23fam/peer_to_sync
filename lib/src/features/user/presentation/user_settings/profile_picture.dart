// import 'package:flutter/material.dart';
// import 'package:peer_to_sync/src/theme/theme.dart';

// class ProfilePicture extends StatefulWidget {
//   const ProfilePicture({super.key});

//   @override
//   State<ProfilePicture> createState() => _ProfilePictureState();
// }

// class _ProfilePictureState extends State<ProfilePicture> {
//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       backgroundColor: AppColors.secondColor,
//       radius: 80.0,
//       child: Icon(
//         Icons.person_outline,
//         color: AppColors.whiteColor,
//         size: 95.0,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      backgroundColor: colors.secondary,
      radius: 80.0,
      child: Icon(Icons.person_outline, color: colors.onSurface, size: 95.0),
    );
  }
}
