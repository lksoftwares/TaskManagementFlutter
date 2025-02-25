// import 'package:flutter/material.dart';
//
//
// class DropdownWidget extends StatelessWidget {
//   final List<String> items;
//   final String selectedValue;
//   final Function(String?) onChanged;
//
//   DropdownWidget({
//     required this.items,
//     required this.selectedValue,
//     required this.onChanged,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: selectedValue,
//       onChanged: onChanged,
//       items: items.map((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
//
// class DropdownController extends StatefulWidget {
//   @override
//   _DropdownControllerState createState() => _DropdownControllerState();
// }
//
// class _DropdownControllerState extends State<DropdownController> {
//   String selectedItem = 'Item 1';
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> dropdownItems = ['Item 1', 'Item 2', 'Item 3'];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown'),
//       ),
//       body: Center(
//         child: DropdownWidget(
//           items: dropdownItems,
//           selectedValue: selectedItem,
//           onChanged: (String? newValue) {
//             setState(() {
//               selectedItem = newValue!;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class Dropdown extends StatefulWidget {
//   const Dropdown({super.key});
//
//   @override
//   State<Dropdown> createState() => _DropdownState();
// }
// String selectedItems = 'Mango';
// class _DropdownState extends State<Dropdown> {
//   @override
//   Widget build(BuildContext context) {
//     List<String> fruits =['Mango', "apple" , "banana", "grapes"];
//     return Scaffold(
//       body: Center(
//         child: DropdownWidget(items: fruits, selectedValue: selectedItems, onChanged: (String? newValue){
//           setState(() {
//             selectedItems =newValue!;
//           });
//         }),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomDropdown<T extends Object> extends StatelessWidget {
  final List<T> options;
  final T? selectedOption;
  final String Function(T) displayValue;
  final void Function(T?) onChanged;
  final String labelText;
  final Icon? prefixIcon;

  const CustomDropdown({
    Key? key,
    required this.options,
    this.selectedOption,
    required this.displayValue,
    required this.onChanged,
    required this.labelText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options
            .where((option) =>
            displayValue(option)
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      onSelected: (selectedOption) {
        onChanged(selectedOption);
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: prefixIcon,
          ),
        );
      },
    );
  }
}
