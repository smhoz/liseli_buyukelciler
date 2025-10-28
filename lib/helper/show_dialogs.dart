import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/util/base_utility.dart';

enum SnackType {
  success(Color(0xff328048), "Başarılı", Icons.check_circle),
  warning(Color(0xffFD9D42), "Uyarı", Icons.warning_rounded),
  error(Color(0xffB42318), "Hatalı", Icons.error);

  final Color color;
  final String message;
  final IconData icon;
  const SnackType(this.color, this.message, this.icon);
}

class CodeNoahDialogs {
  final BuildContext context;

  CodeNoahDialogs(this.context);

  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  void showSnack(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _onFlushPressed(Flushbar? flushbar, bool showing) async {
    if (showing) {
      await flushbar?.dismiss(true);
      return;
    } else {
      return;
    }
  }

  Future<void> showFlush({String? message, required SnackType type}) async {
    Flushbar? flushbar;
    bool showing = false;
    flushbar = Flushbar(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      icon: Icon(type.icon, color: type.color, size: 42),
      borderRadius: BorderRadius.circular(10),
      messageText: Text(
        message ?? type.message,
        style: const TextStyle(color: BaseUtility.black),
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: const Offset(4, 4),
          blurRadius: 12,
        ),
      ],
      isDismissible: true,
      duration: const Duration(milliseconds: 2000),
      backgroundColor: BaseUtility.white,
      mainButton: IconButton(
        onPressed: () async => await _onFlushPressed(flushbar, showing),
        icon: const Icon(Icons.clear),
      ),
      onStatusChanged: (status) {
        if (status == FlushbarStatus.IS_APPEARING ||
            status == FlushbarStatus.SHOWING) {
          showing = true;
        } else {
          showing = false;
        }
      },
    );

    await flushbar.show(context);
  }

  void showModalBottom(
    Widget child, {
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    showModalBottomSheet(
      context: context,
      barrierColor: barrierColor ?? Colors.transparent,
      builder: (context) => child,
      backgroundColor: backgroundColor ?? Colors.transparent,
    );
  }

  void showModalNewBottom(
    DynamicViewExtensions dynamicViewExtensions,
    String appBarText,
    double height,
    List<Widget> children, {
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    showModalBottomSheet(
      context: context,
      barrierColor: barrierColor ?? Colors.transparent,
      builder: (context) => SizedBox(
        width: dynamicViewExtensions.maxWidth(context),
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            children: <Widget>[
              // appbar
              Padding(
                padding: BaseUtility.all(
                  BaseUtility.paddingNormalValue,
                ),
                child: Row(
                  children: <Widget>[
                    // text
                    Expanded(
                      child: Text(
                        appBarText,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    // icon
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: BaseUtility.iconNormalSize,
                      ),
                    ),
                  ],
                ),
              ),
              // body
              Column(
                children: children,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: backgroundColor ?? Colors.transparent,
    );
  }

  Future<T?> showAlert<T extends Object?>(Widget child) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: LoadingAnimationWidget.hexagonDots(
          color: Colors.white,
          size: 50,
        ),
        content: child,
      ),
    );
  }

  Future<T?> showWarningAlert<T extends Object?>(
    IconData icon,
    Color color,
    String title,
    DynamicViewExtensions dynamicViewExtensions,
    Function()? funcOne,
    Function()? funcSecond,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Icon(
          icon,
          color: color,
          size: BaseUtility.iconLargeSize,
        ),
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          SizedBox(
            height: dynamicViewExtensions.dynamicHeight(
              context,
              0.08,
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: FFButtonWidget(
                      onPressed: funcOne,
                      text: 'TAMAM',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 2.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: FFButtonWidget(
                      onPressed: funcOne,
                      text: 'KAPAT',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Colors.transparent,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Figtree',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 2.0,
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
