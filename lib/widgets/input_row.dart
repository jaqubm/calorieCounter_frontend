import 'package:flutter/material.dart';

Widget InputRow(
  String label,
  TextEditingController controller,
  String unit, {
  String? Function(String?)? validator,
  bool isReadOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 25.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: TextFormField(
              controller: controller,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                border: isReadOnly
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      ),
                focusedBorder: isReadOnly
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              ),
              keyboardType:
                  label == 'Name' ? TextInputType.text : TextInputType.number,
              validator: validator,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(unit),
        ),
      ],
    ),
  );
}
