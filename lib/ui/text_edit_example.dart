import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mfdui/ui/ui.dart';

// Use this widget to see and debug how MFDTextEdit can work.
class _TextEditExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rand = Random(DateTime.now().millisecondsSinceEpoch);
    return Column(
      children: [
        const SizedBox(width: 150, child: MFDTextEdit()),
        const MFDTextEdit(
          decorationOptions: TextEditDecorationOptions(maxItemsShow: 2),
          items: [
            MFDSelectItem(
              value: 'aaa',
              child: ListTile(
                title: Text('aaa'),
              ),
            ),
            MFDSelectItem(
              value: 'bbb',
              child: ListTile(
                title: Text('bbb'),
              ),
            ),
            MFDSelectItem(
              value: 'ccc',
              child: ListTile(
                title: Text('ccc'),
              ),
            ),
          ],
        ),
        SizedBox(
            width: 250,
            child: MFDTextEdit<MFDLoadResult>(
              itemsLoader: (value) => Future.value(
                List.generate(rand.nextInt(5), (index) => MFDLoadResult((rand.nextInt(100000) + 10000).toString())),
              ),
              itemBuilder: (context, query, value) => MFDSelectItem(value: value.value, child: Text(value.value ?? '')),
            )),
        SizedBox(
            width: 250,
            child: MFDTextEdit<MFDLoadResult>(
              decoration: InputDecoration(labelText: 'working'),
              decorationOptions: const TextEditDecorationOptions(showDoneButton: true),
              itemsLoader: (value) => Future.value(
                List.generate(rand.nextInt(5), (index) => MFDLoadResult((rand.nextInt(100000) + 10000).toString())),
              ),
              itemBuilder: (context, query, value) => MFDSelectItem(value: value.value, child: Text(value.value ?? '')),
            )),
        SizedBox(
            width: 260,
            child: MFDTextEdit<MFDLoadResult>(
              decoration: InputDecoration(labelText: 'default (submit)'),
              decorationOptions: const TextEditDecorationOptions(showDoneButton: true),
              itemsLoader: (value) => Future.value(
                List.generate(6, (index) => MFDLoadResult((index * 10000).toString())),
              ),
              preload: true,
              itemBuilder: (context, query, value) => MFDSelectItem(value: value.value, child: Text(value.value ?? '')),
            )),
        SizedBox(
            width: 240,
            child: MFDTextEdit<MFDLoadResult>(
              decoration: InputDecoration(labelText: 'replate'),
              decorationOptions: const TextEditDecorationOptions(
                showDoneButton: true,
                selectBehavior: MFDTextEditItemSelectBehavior.replace,
              ),
              itemsLoader: (value) => Future.value(
                List.generate(10, (index) => MFDLoadResult((index * 10000).toString())),
              ),
              preload: true,
              itemBuilder: (context, query, value) => MFDSelectItem(value: value.value, child: Text(value.value ?? '')),
            )),
        SizedBox(
            width: 260,
            child: MFDTextEdit<MFDLoadResult>(
              decoration: InputDecoration(labelText: 'complete'),
              decorationOptions: const TextEditDecorationOptions(
                showDoneButton: true,
                selectBehavior: MFDTextEditItemSelectBehavior.complete,
                hideUnfocusedBorder: true,
              ),
              itemsLoader: (value) => Future.value(
                List.generate(10, (index) => MFDLoadResult((index * 10000).toString())),
              ),
              preload: true,
              itemBuilder: (context, query, value) => MFDSelectItem(value: value.value, child: Text(value.value ?? '')),
            )),
      ],
    );
  }
}
