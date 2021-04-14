import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/settings/settings_bloc.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(150),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Settings', style: Theme.of(context).textTheme.headline6),
                trailing: const CloseButton(),
              ),
              const SizedBox(height: 20),
              _AddrTextField(value: BlocProvider.of<SettingsBloc>(context).state.url),
              // _FileTextField(),
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
            border: const OutlineInputBorder(),
            labelText: 'Address',
            hintText: 'default: http//localhost:8080',
            errorText: errText,
          ),
        ),
        trailing: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsUpdateInProgress) {
              return const CircularProgressIndicator();
            }
            return IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                BlocProvider.of<SettingsBloc>(context).add(SettingsUpdated(textController.text));
              },
              tooltip: 'Connect and save',
            );
          },
        ),
      ),
    );
  }
}
//
// class _FileTextField extends StatefulWidget {
//   @override
//   __FileTextFieldState createState() => __FileTextFieldState();
// }
//
// class __FileTextFieldState extends State<_FileTextField> {
//   String? errText;
//   TextEditingController fieldController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: TextField(
//         controller: fieldController,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           labelText: 'Путь до .mfd файла',
//           errorText: errText,
//         ),
//       ),
//       trailing: IconButton(
//         icon: Icon(Icons.folder_open),
//         onPressed: () async {
//           try {
//             final result = await FilePicker.platform.pickFiles(allowedExtensions: ['mfd'], type: FileType.custom);
//             if (result != null) {
//               fieldController.text = result.files.single.name!;
//             }
//             errText = null;
//             setState(() {});
//           } catch (e) {
//             setState(() {
//               errText = e.toString();
//             });
//           }
//         },
//         tooltip: 'Открыть',
//       ),
//     );
//   }
// }
