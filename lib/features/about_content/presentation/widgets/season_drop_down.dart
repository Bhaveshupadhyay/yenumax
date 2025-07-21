import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SeasonDropDown extends StatefulWidget {
  final List<String> seasons;
  final void Function(String?) onChanged;
  const SeasonDropDown({super.key, required this.seasons, required this.onChanged});

  @override
  State<SeasonDropDown> createState() => _SeasonDropDownState();
}

class _SeasonDropDownState extends State<SeasonDropDown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return  DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          'Select Season',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.seasons
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ))
            .toList(),
        value: selectedValue?? widget.seasons[0],
        onChanged: (String? value) {
          if(value!=null && value !=selectedValue){
            widget.onChanged(value);
            setState(() {
              selectedValue = value;
            });
          }

        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
