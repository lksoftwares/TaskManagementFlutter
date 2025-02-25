// import 'package:flutter/material.dart';
// import 'card_decoration.dart';
//
// Widget buildUserCard({
//   required Map<String, dynamic> userFields,
//   Function? onEdit,
//   Function? onDelete,
// }) {
//   List<Widget> fieldRows = [];
//   String firstKey = userFields.keys.first;
//   dynamic firstValue = userFields[firstKey] ?? '';
//
//   userFields.forEach((key, value) {
//     if (key != firstKey) {
//       Widget displayValue;
//       if (value is bool) {
//         displayValue = Icon(
//           value ? Icons.check_circle : Icons.cancel,
//           color: value ? Colors.green : Colors.red,
//         );
//       } else {
//         displayValue = Text(
//           key == 'Password' ? '*' * (value.length ?? 0) : value.toString(),
//           style: TextStyle(fontSize: 15, color: Colors.grey[900]),
//         );
//       }
//
//       fieldRows.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5.0),
//           child: Row(
//             children: [
//               Text(
//                 '$key:',
//                 style: TextStyle(fontSize: 15, color: Colors.grey[900]),
//               ),
//               Spacer(),
//               displayValue,
//             ],
//           ),
//         ),
//       );
//     }
//   });
//
//   return buildCardLayout(
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Text(
//                   '$firstKey: $firstValue',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[900],
//                   ),
//                 ),
//               ),
//               Spacer(),
//               IconButton(
//                 icon: Icon(Icons.edit, color: Colors.green),
//                 onPressed: onEdit as void Function()?,
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete, color: Colors.red),
//                 onPressed: onDelete as void Function()?,
//               ),
//             ],
//           ),
//           ...fieldRows,
//           Divider(thickness: 1, color: Colors.grey[400]),
//         ],
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'card_decoration.dart';

Widget buildUserCard({
  required Map<String, dynamic> userFields,
  Function? onEdit,
  Function? onDelete,
  bool showEdit = false,  // default to false
  bool showDelete = false,  // default to false
}) {
  List<Widget> fieldRows = [];
  String firstKey = userFields.keys.first;
  dynamic firstValue = userFields[firstKey] ?? '';

  userFields.forEach((key, value) {
    if (key != firstKey) {
      Widget displayValue;
      if (value is bool) {
        displayValue = Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        );
      } else {
        displayValue = Text(
          key == 'Password' ? '*' * (value.length ?? 0) : value.toString(),
          style: TextStyle(fontSize: 15, color: Colors.grey[900]),
        );
      }

      fieldRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Text(
                '$key:',
                style: TextStyle(fontSize: 15, color: Colors.grey[900]),
              ),
              Spacer(),
              displayValue,
            ],
          ),
        ),
      );
    }
  });

  return buildCardLayout(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  '$firstKey: $firstValue',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Spacer(),
              if (showEdit)
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: onEdit as void Function()?,
                ),
              if (showDelete)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete as void Function()?,
                ),
            ],
          ),
          ...fieldRows,
          Divider(thickness: 1, color: Colors.grey[400]),
        ],
      ),
    ),
  );
}
