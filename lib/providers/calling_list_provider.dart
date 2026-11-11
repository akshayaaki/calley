import 'package:flutter/material.dart';
import '../models/calling_list_model.dart';
import '../models/call_lead_model.dart';
import '../services/calling_list_service.dart';
import '../core/utils/local_storage.dart';

class CallingListProvider with ChangeNotifier {
  final CallingListService _service;

  List<CallingListModel> _lists = [];
  CallingListModel? _selectedList;
  CallingListDetailsModel? _listDetails;

  bool _isLoadingLists = false;
  bool _isLoadingDetails = false;
  String? _errorMessage;

  // Active Dialing Session state
  int _activeLeadIndex = 0;

  List<CallingListModel> get lists => _lists;
  CallingListModel? get selectedList => _selectedList;
  CallingListDetailsModel? get listDetails => _listDetails;
  bool get isLoadingLists => _isLoadingLists;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get errorMessage => _errorMessage;

  int get activeLeadIndex => _activeLeadIndex;
  CallLeadModel? get currentLead {
    if (_listDetails == null || _listDetails!.calls.isEmpty) return null;
    if (_activeLeadIndex < 0 || _activeLeadIndex >= _listDetails!.calls.length) return null;
    return _listDetails!.calls[_activeLeadIndex];
  }

  CallingListProvider({CallingListService? service})
      : _service = service ?? CallingListService();

  Future<void> fetchLists(String userId) async {
    _isLoadingLists = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched = await _service.getLists(userId: userId);
      _lists = fetched;

      // Check if we already have an active list persisted
      final savedListId = await LocalStorage.getActiveListId();
      if (savedListId != null) {
        final match = _lists.where((l) => l.id == savedListId).firstOrNull;
        if (match != null) {
          _selectedList = match;
        }
      }

      _isLoadingLists = false;
      notifyListeners();

      if (_selectedList != null) {
        await fetchListDetails(_selectedList!.id);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingLists = false;
      notifyListeners();
    }
  }

  Future<void> selectList(CallingListModel list) async {
    _selectedList = list;
    await LocalStorage.saveActiveListId(list.id);
    notifyListeners();
    await fetchListDetails(list.id);
  }

  Future<void> fetchListDetails(String listId) async {
    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final details = await _service.getListDetails(listId: listId);
      _listDetails = details;
      _activeLeadIndex = 0;
      _isLoadingDetails = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void nextLead() {
    if (_listDetails != null && _activeLeadIndex < _listDetails!.calls.length - 1) {
      _activeLeadIndex++;
      notifyListeners();
    }
  }

  void previousLead() {
    if (_activeLeadIndex > 0) {
      _activeLeadIndex--;
      notifyListeners();
    }
  }

  void setLeadIndex(int index) {
    if (_listDetails != null && index >= 0 && index < _listDetails!.calls.length) {
      _activeLeadIndex = index;
      notifyListeners();
    }
  }

  void updateCurrentLeadStatus({required String status, String? feedback}) {
    if (_listDetails == null || currentLead == null) return;

    final lead = currentLead!;
    final oldStatus = lead.status;
    lead.status = status;
    lead.feedback = feedback ?? lead.feedback;

    // Adjust counts
    int pending = _listDetails!.pending;
    int called = _listDetails!.called;
    int rescheduled = _listDetails!.rescheduled;

    if (oldStatus == 'pending') pending = (pending > 0) ? pending - 1 : 0;
    if (oldStatus == 'called') called = (called > 0) ? called - 1 : 0;
    if (oldStatus == 'rescheduled') rescheduled = (rescheduled > 0) ? rescheduled - 1 : 0;

    if (status == 'pending') pending++;
    if (status == 'called') called++;
    if (status == 'rescheduled') rescheduled++;

    _listDetails = _listDetails!.copyWith(
      pending: pending,
      called: called,
      rescheduled: rescheduled,
    );

    notifyListeners();
  }

  void reset() {
    _selectedList = null;
    _listDetails = null;
    _activeLeadIndex = 0;
    notifyListeners();
  }
}

