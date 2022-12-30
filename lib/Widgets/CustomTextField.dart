import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String hint, label;
  final double _width;
  final TextInputType keyboardType;
  bool? editAble=true;
  int? max_length;
  CustomTextField(this._width, this.hint, this.label, this.keyboardType, this._controller,{this.editAble,this.max_length});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: _width,
        margin: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: _width*0.26,
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: _width*0.7,
              child: TextFormField(
                cursorColor: Colors.grey,
                controller: _controller,
                keyboardType: keyboardType,
                maxLength: max_length,
                enabled: editAble,
                style: const TextStyle(fontSize: 15, color: Colors.black),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white.withOpacity(0.6),
                    filled: true,
                    /*border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      borderSide: BorderSide(color: Color(0xff8d62d6), width: 3.0),
                    ),*/
                    contentPadding: const EdgeInsets.all(5),
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.8),
                        fontWeight: FontWeight.w300)
                    //labelText: hint,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
