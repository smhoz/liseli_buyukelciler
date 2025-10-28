import '/flutter_flow/flutter_flow_util.dart';
import 'assign_badge_bottom_sheet_widget.dart' show AssignBadgeBottomSheetWidget;
import 'package:flutter/material.dart';

class AssignBadgeBottomSheetModel extends FlutterFlowModel<AssignBadgeBottomSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for selected badges (multiple selection)
  Set<String> selectedBadgeIds = {};

  // State field(s) for search TextField widget.
  FocusNode? searchFocusNode;
  TextEditingController? searchController;
  String? Function(BuildContext, String?)? searchControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFocusNode?.dispose();
    searchController?.dispose();
  }
}
