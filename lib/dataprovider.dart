import 'package:mossorotaximotorista/datamodels/history.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String earnings = '0';
  int tripPassengerCount = 0;
  int tripDocumentCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripPassengerHistory = [];
  List<History> tripDocumentHistory = [];

  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripPassengerCount(int newTripPassengerCount) {
    tripPassengerCount = newTripPassengerCount;
    notifyListeners();
  }

  void updateTripDocumentCount(int newTripDocumentCount) {
    tripDocumentCount = newTripDocumentCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripPassengerHistory(History historyItem) {
    tripPassengerHistory.add(historyItem);
    notifyListeners();
  }

  void updateTripDocumentHistory(History historyItem) {
    tripDocumentHistory.add(historyItem);
    notifyListeners();
  }

  void clearTripPassengerHistory() {
    tripPassengerHistory.clear();
    notifyListeners();
  }

  void clearTripDocumentHistory() {
    tripDocumentHistory.clear();
    notifyListeners();
  }
}
