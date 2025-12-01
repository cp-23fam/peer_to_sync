// import 'package:flutter/material.dart';
// import 'package:peer_to_sync/src/common_widgets/styled_text.dart';
// import 'package:peer_to_sync/src/theme/theme.dart';

// class FilterDropdown extends StatefulWidget {
//   const FilterDropdown({
//     super.key,
//     required this.selected,
//     required this.isSelected,
//     required this.list,
//     required this.title,
//   });
//   final List<String?> list;
//   final String? selected;
//   final Function(String? newValue) isSelected;
//   final String title;

//   @override
//   State<FilterDropdown> createState() => _FilterDropdownState();
// }

// class _FilterDropdownState extends State<FilterDropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColors.secondColor,
//               border: Border.all(color: AppColors.firstColor, width: 2.0),
//               borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//             ),
//             child: DropdownButton<String>(
//               value: widget.selected,
//               hint: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: StyledText('Type de la room', 20.0),
//               ),
//               dropdownColor: AppColors.secondColor,
//               style: TextStyle(color: AppColors.whiteColor),
//               underline: const SizedBox(),
//               borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//               items: widget.list.map((String? type) {
//                 return DropdownMenuItem<String>(
//                   value: type,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: StyledText(type ?? 'Aucun', 20.0),
//                   ),
//                 );
//               }).toList(),
//               onChanged: widget.isSelected,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
