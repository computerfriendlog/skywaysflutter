import 'package:flutter/material.dart';
import 'package:skywaysflutter/Helper/Constants.dart';

class PlaceSearchTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String hint;
  final double _width;
  final void Function()? _function_handler;

  PlaceSearchTextField(
      this._width, this.hint, this._controller, this._function_handler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      margin: const EdgeInsets.all(2),
      child: Stack(
        children: [
          TextFormField(
            cursorColor: Colors.grey,
            controller: _controller,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gapPadding: 0,
                  borderSide: const BorderSide(
                      color: Colors.grey, width: 0.5, style: BorderStyle.solid),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gapPadding: 0,
                  borderSide: const BorderSide(
                      color: Colors.grey, width: 0.5, style: BorderStyle.solid),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gapPadding: 0,
                  borderSide: const BorderSide(
                      color: Colors.grey, width: 0.5, style: BorderStyle.solid),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  gapPadding: 0,
                  borderSide: BorderSide(
                      color: Colors.grey, width: 0.5, style: BorderStyle.solid),
                ),
                contentPadding: const EdgeInsets.all(5),
                hintText: hint,
                hintStyle: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w400)
                //labelText: hint,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: _function_handler,
                child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(7),
                    margin: const EdgeInsets.all(3),
                    child: Icon(Constants.ic_cross)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
