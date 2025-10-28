import 'package:flutter/material.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_widgets.dart';
import 'package:sosyal_medya/service/badge_notification_service.dart';

class SendBadgeNotificationDialogWidget extends StatefulWidget {
  const SendBadgeNotificationDialogWidget({
    Key? key,
    required this.badgeIds,
    required this.badgeNames,
    required this.userCount,
  }) : super(key: key);

  final Set<String> badgeIds;
  final List<String> badgeNames;
  final int userCount;

  @override
  State<SendBadgeNotificationDialogWidget> createState() =>
      _SendBadgeNotificationDialogWidgetState();
}

class _SendBadgeNotificationDialogWidgetState extends State<SendBadgeNotificationDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final result = await BadgeNotificationService().sendNotificationToBadgeHolders(
        badgeIds: widget.badgeIds,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (!mounted) return;

      // Show result dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Row(
                  children: [
                    Icon(
                      result['success']! > 0 ? Icons.check_circle : Icons.error,
                      color: result['success']! > 0 ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bildirim Gönderildi',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✅ Başarılı: ${result['success']}',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Figtree',
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '❌ Başarısız: ${result['failed']}',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Figtree',
                            letterSpacing: 0.0,
                          ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Toplam: ${result['success']! + result['failed']!} kullanıcı',
                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Figtree',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Action button
                FFButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close result dialog
                    Navigator.of(context).pop(); // Close notification dialog
                  },
                  text: 'Tamam',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 44,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Figtree',
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bildirim Gönder',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Figtree',
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge info
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hedef Kullanıcılar:',
                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${widget.userCount} kullanıcı',
                              style: FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Figtree',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Seçili Rozetler:',
                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: widget.badgeNames
                                  .map((name) => Chip(
                                        label: Text(
                                          '🏆 $name',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        backgroundColor: FlutterFlowTheme.of(context).accent1,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Title input
                      Text(
                        'Başlık',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Bildirim başlığı...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Başlık gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // Body input
                      Text(
                        'Mesaj',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _bodyController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Bildirim mesajı...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Mesaj gerekli';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Divider(height: 1),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  TextButton(
                    onPressed: _isSending ? null : () => Navigator.of(context).pop(),
                    child: Text('İptal'),
                  ),
                  SizedBox(width: 8),

                  // Send button
                  FFButtonWidget(
                    onPressed: _isSending ? null : _sendNotification,
                    text: _isSending ? 'Gönderiliyor...' : 'Gönder',
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Figtree',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
