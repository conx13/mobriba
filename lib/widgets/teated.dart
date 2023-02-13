import 'package:flutter/material.dart';

class YldTeated {
  static naita(BuildContext context,
      {required String message, required bool err}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            err ? Icons.error : Icons.done_all,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(message),
        ],
      ),
      backgroundColor: err
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).primaryColor,
    ));
  }
}
