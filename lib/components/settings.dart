import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/services/api/api_client.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(150),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Настройки', style: Theme.of(context).textTheme.headline5),
                ),
              ),
              _AddrTextField(),
              _FileTextField(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddrTextField extends StatefulWidget {
  @override
  __AddrTextFieldState createState() => __AddrTextFieldState();
}

class __AddrTextFieldState extends State<_AddrTextField> {
  String? errText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Адрес подключения',
          errorText: errText,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.sync),
        onPressed: () async {
          try {
            final pong = await RepositoryProvider.of<ApiClient>(context).xml.loadProject(XmlLoadProjectArgs());
            setState(() {
              errText = null;
            });
          } catch (e) {
            setState(() {
              errText = e.toString();
            });
          }
        },
        tooltip: 'Подключиться',
      ),
    );
  }
}

class _FileTextField extends StatefulWidget {
  @override
  __FileTextFieldState createState() => __FileTextFieldState();
}

class __FileTextFieldState extends State<_FileTextField> {
  String? errText;
  TextEditingController fieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: fieldController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Путь до .mfd файла',
          errorText: errText,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.folder_open),
        onPressed: () async {
          try {
            final result = await FilePicker.platform.pickFiles(allowedExtensions: ['mfd'], type: FileType.custom);
            if (result != null) {
              fieldController.text = result.files.single.name!;
            }
            errText = null;
            setState(() {});
          } catch (e) {
            setState(() {
              errText = e.toString();
            });
          }
        },
        tooltip: 'Открыть',
      ),
    );
  }
}
