import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/settings/settings_bloc.dart';

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
              _AddrTextField(value: BlocProvider.of<SettingsBloc>(context).state.url),
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
  const _AddrTextField({Key? key, this.value = ''}) : super(key: key);

  final String value;

  @override
  __AddrTextFieldState createState() => __AddrTextFieldState();
}

class __AddrTextFieldState extends State<_AddrTextField> {
  String? errText;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsUpdateFailed) {
          errText = state.err;
        } else {
          errText = null;
        }
        setState(() {});
      },
      child: ListTile(
        title: TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Адрес подключения',
            errorText: errText,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.sync),
          onPressed: () {
            BlocProvider.of<SettingsBloc>(context).add(SettingsUpdated(textController.text));
          },
          tooltip: 'Подключиться',
        ),
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
