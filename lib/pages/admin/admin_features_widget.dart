import '../../flutter_flow/flutter_flow_icon_button.dart';
import '/components/web_components/side_nav/side_nav_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/admin/user_list_page/user_list_page_widget.dart';
import 'package:flutter/material.dart';
import 'admin_features_model.dart';
export 'admin_features_model.dart';

class AdminFeaturesWidget extends StatefulWidget {
  const AdminFeaturesWidget({super.key});

  static String routeName = 'admin_Features';
  static String routePath = '/adminFeatures';

  @override
  State<AdminFeaturesWidget> createState() => _AdminFeaturesWidgetState();
}

class _AdminFeaturesWidgetState extends State<AdminFeaturesWidget> {
  late AdminFeaturesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminFeaturesModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          buttonSize: 46.0,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 25.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Admin Özellikleri',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                letterSpacing: 0.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          wrapWithModel(
            model: _model.sideNavModel,
            updateCallback: () => safeSetState(() {}),
            child: SideNavWidget(
              selectedNav: 3,
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: 1070.0,
                ),
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(UserListPageWidget.routeName);
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: FlutterFlowTheme.of(context).primary,
                                        size: 24.0,
                                      ),
                                      SizedBox(width: 12.0),
                                      Text(
                                        'Üyeler',
                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                              fontFamily: 'Figtree',
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 18.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
