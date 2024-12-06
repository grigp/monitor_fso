
import 'dart:io';

import '../defines.dart';


enum ChaningMode {mdForward, mdBacward}

abstract class AbstractDriver{
  Future<DataParams> init(Function func);
  Future<int> getCounter();

  Future<void> calibrate(Function func);
  Future<void> setMode(ChaningMode md);
  Future<void> getSettings();


}