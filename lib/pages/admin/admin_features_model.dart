import '/components/web_components/side_nav/side_nav_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'admin_features_widget.dart' show AdminFeaturesWidget;
import 'package:flutter/material.dart';

class AdminFeaturesModel extends FlutterFlowModel<AdminFeaturesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for sideNav component.
  late SideNavModel sideNavModel;

  @override
  void initState(BuildContext context) {
    sideNavModel = createModel(context, () => SideNavModel());
  }

  @override
  void dispose() {
    sideNavModel.dispose();
  }
}
