import 'package:flutter/material.dart';

void showDialogWeebi(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("Fermer"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogWeebiOk(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        content: TextButton(
          child: const Icon(Icons.sentiment_very_satisfied),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showDialogWeebiNotOk(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        content: TextButton(
          child: const Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Fermer"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class AskAreYouSure extends StatelessWidget {
  final String text;
  const AskAreYouSure(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Text(text),
      actions: <Widget>[
        TextButton(
            child: const Text('Annuler', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, false)),
        TextButton(
            child: const Text('Valider', style: TextStyle(color: Colors.green)),
            onPressed: () => Navigator.pop(context, true))
      ],
    );
  }
}
