import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/services/api/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'project_bloc.dart';
part 'project_event.dart';
part 'project_model.dart';
part 'project_state.dart';
