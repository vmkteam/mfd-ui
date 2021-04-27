import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/attributes/attributes_table.dart';
import 'package:mfdui/components/searches/searches_table.dart';

class WorkArea extends StatefulWidget {
  @override
  _WorkAreaState createState() => _WorkAreaState();
}

class _WorkAreaState extends State<WorkArea> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkAreaBloc, WorkAreaState>(
      builder: (context, state) {
        if (state is WorkAreaSelectInProgress) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(state.entityName),
                primary: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey.shade300,
                elevation: 1,
                pinned: true,
              ),
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        if (state is WorkAreaSelectSuccess) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(state.entity.name),
                primary: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey.shade300,
                elevation: 1,
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: TextEditingController(text: state.entity.table),
                      decoration: const InputDecoration(
                        labelText: 'Table',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => BlocProvider.of<WorkAreaBloc>(context).add(
                        EntityTableChanged(value),
                      ),
                    ),
                  ),
                ]),
              ),
              AttributesTable(waBloc: BlocProvider.of<WorkAreaBloc>(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 56)),
              SearchesTable(waBloc: BlocProvider.of<WorkAreaBloc>(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        }
        return Container();
      },
    );
  }
}
