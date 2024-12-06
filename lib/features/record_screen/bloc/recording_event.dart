part of 'recording_bloc.dart';

class RecordingEvent{}

class InitSendDataEvent extends RecordingEvent {
  InitSendDataEvent({
    required this.func
  });
  Function func;
}

class CalibrationEvent extends RecordingEvent {
  CalibrationEvent({
    required this.func
  });
  Function func;
}

class UpdateParamsEvent extends RecordingEvent {}
