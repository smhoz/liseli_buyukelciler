import '/components/admin_user_list_item/admin_user_list_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'user_list_page_widget.dart' show UserListPageWidget;
import 'package:flutter/material.dart';

class UserListPageModel extends FlutterFlowModel<UserListPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for AdminUserListItem dynamic component.
  late FlutterFlowDynamicModels<AdminUserListItemModel> userListModels;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State field(s) for badge filter (multiple selection)
  Set<String> selectedBadgeIds = {};
  bool showOnlyUsersWithBadges = false;

  @override
  void initState(BuildContext context) {
    userListModels = FlutterFlowDynamicModels(() => AdminUserListItemModel());
  }

  @override
  void dispose() {
    userListModels.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
