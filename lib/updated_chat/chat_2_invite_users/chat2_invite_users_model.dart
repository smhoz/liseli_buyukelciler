import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'chat2_invite_users_widget.dart' show Chat2InviteUsersWidget;
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Chat2InviteUsersModel extends FlutterFlowModel<Chat2InviteUsersWidget> {
  ///  Local state fields for this page.

  List<DocumentReference> friendsList = [];
  void addToFriendsList(DocumentReference item) => friendsList.add(item);
  void removeFromFriendsList(DocumentReference item) => friendsList.remove(item);
  void removeAtIndexFromFriendsList(int index) => friendsList.removeAt(index);
  void insertAtIndexInFriendsList(int index, DocumentReference item) =>
      friendsList.insert(index, item);
  void updateFriendsListAtIndex(int index, Function(DocumentReference) updateFn) =>
      friendsList[index] = updateFn(friendsList[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for ListView widget.

  //search
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Timer? _debounceTimer;
  String _currentSearchTerm = '';

  // Dispose flag to prevent operations after disposal
  bool _isDisposed = false;

  PagingController<DocumentSnapshot?, UsersRecord>? listViewPagingController;
  Query? listViewPagingQuery;

  // State field(s) for CheckboxListTile widget.
  Map<UsersRecord, bool> checkboxListTileValueMap = {};
  List<UsersRecord> get checkboxListTileCheckedItems =>
      checkboxListTileValueMap.entries.where((e) => e.value).map((e) => e.key).toList();

  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  ChatsRecord? updatedChatThread;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ChatsRecord? newChatThread;

  @override
  void initState(BuildContext context) {
    // Initialize the paging controller early
    listViewPagingController = _createListViewController(
      UsersRecord.collection.orderBy('display_name'),
      null,
    );
  }

  @override
  void dispose() {
    // Set dispose flag immediately
    _isDisposed = true;

    _debounceTimer?.cancel();
    textController?.dispose();

    // Safely dispose paging controller
    final controller = listViewPagingController;
    listViewPagingController = null;

    // Dispose immediately, don't wait
    try {
      controller?.dispose();
    } catch (e) {
      // Ignore disposal errors
      print('PagingController disposal error (ignored): $e');
    }
  }

  /// Additional helper methods.
  PagingController<DocumentSnapshot?, UsersRecord> setListViewController(
    Query query, {
    DocumentReference<Object?>? parent,
  }) {
    // Check if model is disposed first
    if (_isDisposed) {
      print('Model is disposed, creating temporary controller');
      // Return a temporary controller that won't cause errors
      return PagingController<DocumentSnapshot?, UsersRecord>(firstPageKey: null);
    }

    // Always return existing controller if it exists and is not in error state
    if (listViewPagingController != null && listViewPagingController!.error == null) {
      return listViewPagingController!;
    }

    // Only create new controller if none exists or current one has error
    if (listViewPagingController == null || listViewPagingController!.error != null) {
      // Dispose old controller safely if exists
      final oldController = listViewPagingController;
      listViewPagingController = null;

      // Dispose old controller immediately
      try {
        oldController?.dispose();
      } catch (e) {
        print('Old controller disposal error (ignored): $e');
      }

      // Create new controller
      listViewPagingController = _createListViewController(query, parent);
    }

    return listViewPagingController!;
  }

  PagingController<DocumentSnapshot?, UsersRecord> _createListViewController(
      Query query, DocumentReference<Object?>? parent) {
    final controller = PagingController<DocumentSnapshot?, UsersRecord>(firstPageKey: null);

    controller.addPageRequestListener(
      (nextPageMarker) async {
        // Check if model is disposed first
        if (_isDisposed) {
          print('Model is disposed, skipping pagination request');
          return;
        }

        // Check if controller is still valid before proceeding
        if (listViewPagingController != controller) {
          // Controller has been replaced or disposed, don't proceed
          print('Controller has been replaced, skipping pagination request');
          return;
        }

        // Add timeout to prevent infinite loading
        final timeoutDuration = Duration(seconds: 10);
        Timer? timeoutTimer;

        timeoutTimer = Timer(timeoutDuration, () {
          if (!_isDisposed && listViewPagingController == controller) {
            print('Pagination timeout, setting error');
            try {
              controller.error = 'Yükleme zaman aşımına uğradı. Lütfen tekrar deneyin.';
            } catch (e) {
              print('Error setting timeout error: $e');
            }
          }
        });

        try {
          List<UsersRecord> users;
          DocumentSnapshot? lastDoc;

          // If there's a search term, use filtered search
          if (_currentSearchTerm.isNotEmpty) {
            // Search in display_name and userName using fresh queries
            // Make search case-insensitive by searching both lowercase and original case
            final searchLower = _currentSearchTerm.toLowerCase();
            final searchUpper = _currentSearchTerm.toUpperCase();
            final searchCapitalized = _currentSearchTerm
                .toLowerCase()
                .replaceRange(0, 1, _currentSearchTerm[0].toUpperCase());

            // Search display_name with multiple case variations
            final displayQueries = <Future<QuerySnapshot>>[];

            // Original case search
            Query displayQuery1 = UsersRecord.collection
                .where('display_name', isGreaterThanOrEqualTo: _currentSearchTerm)
                .where('display_name', isLessThanOrEqualTo: '$_currentSearchTerm\uf8ff')
                .orderBy('display_name')
                .limit(16);
            if (nextPageMarker != null) {
              displayQuery1 = displayQuery1.startAfterDocument(nextPageMarker);
            }
            displayQueries.add(displayQuery1.get());

            // Lowercase search
            Query displayQuery2 = UsersRecord.collection
                .where('display_name', isGreaterThanOrEqualTo: searchLower)
                .where('display_name', isLessThanOrEqualTo: '$searchLower\uf8ff')
                .orderBy('display_name')
                .limit(16);
            if (nextPageMarker != null) {
              displayQuery2 = displayQuery2.startAfterDocument(nextPageMarker);
            }
            displayQueries.add(displayQuery2.get());

            // Capitalized search (Ali, Aybike gibi)
            Query displayQuery3 = UsersRecord.collection
                .where('display_name', isGreaterThanOrEqualTo: searchCapitalized)
                .where('display_name', isLessThanOrEqualTo: '$searchCapitalized\uf8ff')
                .orderBy('display_name')
                .limit(16);
            if (nextPageMarker != null) {
              displayQuery3 = displayQuery3.startAfterDocument(nextPageMarker);
            }
            displayQueries.add(displayQuery3.get());

            // Execute all display name queries
            final displayResults = await Future.wait(displayQueries);

            // Search userName with lowercase
            Query userQuery = UsersRecord.collection
                .where('userName', isGreaterThanOrEqualTo: searchLower)
                .where('userName', isLessThanOrEqualTo: '$searchLower\uf8ff')
                .orderBy('userName')
                .limit(16);

            if (nextPageMarker != null) {
              userQuery = userQuery.startAfterDocument(nextPageMarker);
            }

            final userNameQuery = await userQuery.get();

            // Combine results and remove duplicates
            final allUsers = <String, UsersRecord>{};

            // Process all display name results
            for (var queryResult in displayResults) {
              for (var doc in queryResult.docs) {
                final user = UsersRecord.fromSnapshot(doc);
                allUsers[user.reference.id] = user;
              }
            }

            // Process userName results
            for (var doc in userNameQuery.docs) {
              final user = UsersRecord.fromSnapshot(doc);
              allUsers[user.reference.id] = user;
            }

            users = allUsers.values.toList();

            // Get last document for pagination
            DocumentSnapshot? lastDisplayDoc;
            for (var queryResult in displayResults) {
              if (queryResult.docs.isNotEmpty) {
                lastDisplayDoc = queryResult.docs.last;
                break;
              }
            }

            if (lastDisplayDoc != null) {
              lastDoc = lastDisplayDoc;
            } else if (userNameQuery.docs.isNotEmpty) {
              lastDoc = userNameQuery.docs.last;
            }
          } else {
            // No search term, get all users with pagination
            Query userQuery = query.limit(16);
            if (nextPageMarker != null) {
              userQuery = userQuery.startAfterDocument(nextPageMarker);
            }

            final querySnapshot = await userQuery.get();
            users = querySnapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList();

            // Get last document for pagination
            if (querySnapshot.docs.isNotEmpty) {
              lastDoc = querySnapshot.docs.last;
            }
          }

          // Cancel timeout since operation completed successfully
          timeoutTimer.cancel();

          // Check again before appending
          if (!_isDisposed && listViewPagingController == controller) {
            final isLastPage = users.length < 16;
            controller.appendPage(users, isLastPage ? null : lastDoc);
          }
        } catch (error) {
          // Cancel timeout on error
          timeoutTimer.cancel();
          // Hata durumunda controller'a hata bildir - sadece dispose edilmemişse
          print('Pagination error: $error');

          // Triple check before setting error
          if (!_isDisposed && listViewPagingController == controller) {
            try {
              controller.error = error;
            } catch (disposeError) {
              // Controller already disposed, ignore
              print('Controller already disposed: $disposeError');
            }
          }
        }
      },
    );

    return controller;
  }

  void onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      // Check if model is disposed first
      if (_isDisposed) {
        print('Model is disposed, skipping search');
        return;
      }

      final searchValue = textController?.text ?? '';
      final trimmedValue = searchValue.trim();

      // Only update if search term actually changed
      if (_currentSearchTerm != trimmedValue) {
        _currentSearchTerm = trimmedValue;

        // Instead of creating new controller, refresh the existing one
        if (listViewPagingController != null && !_isDisposed) {
          try {
            listViewPagingController!.refresh();
          } catch (e) {
            print('Controller refresh error (ignored): $e');
            // If refresh fails, recreate controller
            _recreateController();
          }
        }
      }
    });
  }

  void _recreateController() {
    if (_isDisposed) return;

    final oldController = listViewPagingController;
    listViewPagingController = null;

    // Dispose old controller
    try {
      oldController?.dispose();
    } catch (e) {
      print('Old controller disposal error (ignored): $e');
    }

    // Create new controller
    if (!_isDisposed) {
      listViewPagingController = _createListViewController(
        UsersRecord.collection.orderBy('display_name'),
        null,
      );
    }
  }

  // userName'de arama için alternatif metod
  Future<List<UsersRecord>> searchInUserName(String searchValue) async {
    if (searchValue.isEmpty) return [];

    try {
      final querySnapshot = await UsersRecord.collection
          .where('userName', isGreaterThanOrEqualTo: searchValue)
          .where('userName', isLessThanOrEqualTo: '$searchValue\uf8ff')
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) => UsersRecord.fromSnapshot(doc)).toList();
    } catch (e) {
      print('userName araması hatası: $e');
      return [];
    }
  }

  // Debug method to check controller state
  void debugControllerState() {
    print('=== Controller Debug Info ===');
    print('_isDisposed: $_isDisposed');
    print('listViewPagingController != null: ${listViewPagingController != null}');
    if (listViewPagingController != null) {
      print('controller.error: ${listViewPagingController!.error}');
      print('controller.itemList?.length: ${listViewPagingController!.itemList?.length}');
      print('controller.nextPageKey: ${listViewPagingController!.nextPageKey}');
    }
    print('_currentSearchTerm: "$_currentSearchTerm"');
    print('=============================');
  }

  // Force refresh method to fix loading issues
  void forceRefresh() {
    print('Force refreshing controller...');
    if (!_isDisposed) {
      _recreateController();
    }
  }
}
