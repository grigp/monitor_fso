import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monitor_fso/repositories/source/abstract_driver.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class ProcessControlBloc
    extends Bloc<RecordingEvent, RecordingState> {
  ProcessControlBloc(this.process) : super(RecordingState()) {
    on<InitSendDataEvent>((event, emit) async {
      try {
        final pp = await process.init(event.func);
        emit(ProcessGetFreq(freq: pp.freq, min: pp.min, max: pp.max));

      } catch (e) {
        emit(ProcessGetValueFailure(exception: e));
      }
    });

    on<CalibrationEvent>((event, emit) async {
      try {
        await process.calibrate(event.func);
      } catch (e) {

      }
    });

    on<UpdateParamsEvent>((event, emit) async {
      try {
        await process.getSettings();
      } catch (e) {

      }
    });
  }

  final AbstractDriver process;
}
