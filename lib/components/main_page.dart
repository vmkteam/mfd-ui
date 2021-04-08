import 'package:flutter/material.dart';
import 'package:mfdui/components/settings.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MFDUI'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Настройки',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => Settings(),
            ),
          ),
        ],
      ),
    );
  }
}
