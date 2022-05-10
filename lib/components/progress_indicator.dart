import 'package:flutter/material.dart';

showProgressIndicator(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height - 400,
              width: width - 400,
              child: const CircularProgressIndicator()
            );
          }
        )
      );
    },
  );
}
