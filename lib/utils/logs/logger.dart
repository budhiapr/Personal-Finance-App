import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Logger to help with debugging
class Logger {
  static bool _logToConsole = true;
  static bool _logToFile = true;
  static final _formatter = DateFormat('dd.MM.yyyy HH:mm:ss:SSS');
  static final _logQueue = Queue<String>();
  static const _logFilename = 'dev_log.log';
  static late File _file;

  /// Flag to check if the logger is in testing mode
  @visibleForTesting
  static bool isTestingMode = false;

  /// Initializes the logger with the chosen outputs
  static Future<void> init({bool? logToConsole, bool? logToFile}) async {
    if (isTestingMode) {
      logToConsole = false;
      logToFile = false;
    }
    _logToConsole = logToConsole ?? _logToConsole;
    _logToFile = logToFile ?? _logToFile;
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$_logFilename');
  }

  /// Logs an object to the chosen outputs
  static void log(dynamic message) {
    if (message is String) {
      _logQueue.add(message);
    } else if (message is Exception) {
      _logQueue.add(message.toString());
    } else if (message is Error) {
      _logQueue
        ..add(Error.safeToString(message))
        ..add(message.stackTrace.toString());
    } else if (message is Type) {
      _logQueue.add('<----------$message---------->');
    } else if (message is FlutterErrorDetails) {
      _logQueue
        ..add(message.exception.toString())
        ..add(message.stack.toString());
    } else {
      _logQueue.add(message.toString());
    }
    _processQueue();
  }

  /// Resets the logger to its default state
  @visibleForTesting
  static void reset() {
    _logToConsole = true;
    _logToFile = true;
    _logQueue.clear();
  }

  static void _processQueue() {
    for (final message in _logQueue) {
      if (_logToConsole) {
        debugPrint(message);
      }
      if (_logToFile) {
        _writeToFile(message);
      }
    }
    _logQueue.clear();
  }

  static void _writeToFile(String message) {
    _file.writeAsStringSync(
      '${_formatter.format(DateTime.now())} - $message\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  /// Reads the logs from the file
  static File get logs => _file;

  /// Deletes the logs file
  static Future<void> deleteLogs() async {
    await _file.delete();
  }
}
