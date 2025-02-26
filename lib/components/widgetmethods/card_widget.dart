import 'package:flutter/material.dart';

Widget buildCardLayout({required Widget child}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: Colors.white,
    shadowColor: Colors.black.withOpacity(0.3),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    ),
  );
}

Widget buildUserCard({
  required Map<String, dynamic> userFields,
  Function? onEdit,
  Function? onDelete,
  Function? onView,
  bool showEdit = false,
  bool showDelete = false,
  bool showView = false,
  Widget? trailingIcon,
  String? topLabel, // Dynamic label text for the top section
  Widget? topIcon, // Dynamic trailing icon for the top section
}) {
  List<Widget> fieldRows = [];
  List<String> keys = userFields.keys.toList();

  if (keys.length >= 2) {
    String firstKey = keys[0];
    dynamic firstValue = userFields[firstKey] ?? '';
    String secondKey = keys[1];
    dynamic secondValue = userFields[secondKey] ?? '';

    fieldRows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Text(
              '$firstKey: $firstValue',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '$secondKey $secondValue',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );

    for (int i = 2; i < keys.length; i++) {
      String key = keys[i];
      dynamic value = userFields[key];

      Widget displayValue;
      if (value is bool) {
        displayValue = Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        );
      } else {
        displayValue = Text(
          key == 'Password' ? '*' * (value.toString().length ?? 0) : value.toString(),
          style: const TextStyle(fontSize: 15, color: Colors.black),
        );
      }

      fieldRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Text(
                '$key:',
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              const Spacer(),
              displayValue,
              if (i == 2) ...[
                if (showEdit)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: onEdit as void Function()?,
                  ),
                if (showDelete)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete as void Function()?,
                  ),
                if (showView)
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Colors.blue),
                    onPressed: onView as void Function()?,
                  ),
              ]
            ],
          ),
        ),
      );
    }
  } else if (keys.isNotEmpty) {
    String firstKey = keys[0];
    dynamic firstValue = userFields[firstKey] ?? '';
    fieldRows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Text(
              '$firstKey: $firstValue',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            if (showEdit)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: onEdit as void Function()?,
              ),
            if (showDelete)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete as void Function()?,
              ),
            if (showView)
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.blue),
                onPressed: onView as void Function()?,
              ),
          ],
        ),
      ),
    );
  }

  return buildCardLayout(
    child: Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topLabel != null || topIcon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                children: [
                  if (topLabel != null)
                    Text(
                      topLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  if (topLabel != null && topIcon != null)
                    const SizedBox(width: 8.0), // Space between label and icon
                  if (topIcon != null) topIcon!,
                ],
              ),
            ),
          // User fields
          ...fieldRows,
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          if (trailingIcon != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: trailingIcon,
              ),
            ),
        ],
      ),
    ),
  );
}
