import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/service/system_chat_service.dart';

class SendBadgeMessageDialogWidget extends StatefulWidget {
  const SendBadgeMessageDialogWidget({
    super.key,
    required this.badgeIds,
    required this.badgeNames,
    required this.userCount,
  });

  final List<String> badgeIds;
  final List<String> badgeNames;
  final int userCount;

  @override
  State<SendBadgeMessageDialogWidget> createState() => _SendBadgeMessageDialogWidgetState();
}

class _SendBadgeMessageDialogWidgetState extends State<SendBadgeMessageDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isSending = false;
  String _currentStatus = '';
  int _currentProgress = 0;
  int _totalProgress = 0;
  List<String> _failedUsers = []; // Users who couldn't receive message due to old version

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
      _currentProgress = 0;
      _totalProgress = 0;
      _currentStatus = 'Mesajlar gönderiliyor...';
    });

    try {
      final systemChatService = SystemChatService();
      final result = await systemChatService.sendMessageToBadgeHolders(
        badgeIds: widget.badgeIds,
        message: _messageController.text,
        onProgress: (current, total) {
          setState(() {
            _currentProgress = current;
            _totalProgress = total;
            _currentStatus = 'Mesajlar gönderiliyor...';
          });
        },
      );

      // Get old version users
      final oldVersionUsers = (result['oldVersionUsers'] as List?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [];

      // Check if widget is still mounted before using context
      if (!mounted) return;

      // Close current dialog
      Navigator.pop(context);

      // Show result dialog
      await showDialog(
        context: context,
        builder: (dialogContext) => _buildResultDialog(
          dialogContext: dialogContext,
          successCount: result['success'] ?? 0,
          failedCount: result['failed'] ?? 0,
          oldVersionUsers: oldVersionUsers,
        ),
      );
    } catch (e) {
      print('❌ Mesaj gönderme hatası: $e');

      // Check if widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mesaj gönderilirken hata oluştu: $e'),
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

  Widget _buildResultDialog({
    required BuildContext dialogContext,
    required int successCount,
    required int failedCount,
    List<Map<String, String>> oldVersionUsers = const [],
  }) {
    final totalCount = successCount + failedCount;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: successCount > 0
                            ? FlutterFlowTheme.of(context).success.withOpacity(0.1)
                            : FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        successCount > 0 ? Icons.check_circle : Icons.error,
                        color: successCount > 0
                            ? FlutterFlowTheme.of(context).success
                            : FlutterFlowTheme.of(context).error,
                        size: 32,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Title
                    Text(
                      'Mesaj Gönderildi',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    SizedBox(height: 16),

                    // Results
                    Container(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildResultRow(
                            icon: Icons.check_circle,
                            iconColor: FlutterFlowTheme.of(context).success,
                            label: 'Başarılı',
                            count: successCount,
                          ),
                          if (failedCount > 0) ...[
                            SizedBox(height: 12),
                            _buildResultRow(
                              icon: Icons.error,
                              iconColor: FlutterFlowTheme.of(context).error,
                              label: 'Başarısız',
                              count: failedCount,
                            ),
                          ],
                          SizedBox(height: 12),
                          Divider(height: 1, thickness: 1),
                          SizedBox(height: 12),
                          _buildResultRow(
                            icon: Icons.people,
                            iconColor: FlutterFlowTheme.of(context).primary,
                            label: 'Toplam',
                            count: totalCount,
                          ),
                        ],
                      ),
                    ),

                    // Old version users warning
                    if (oldVersionUsers.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).warning,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: FlutterFlowTheme.of(context).warning,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Eski Versiyon Kullanan Kullanıcılar',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Figtree',
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              '${oldVersionUsers.length} kullanıcı eski uygulama versiyonu kullandığı için mesaj alamadı. Bu kullanıcıların uygulamayı güncellemesi gerekiyor:',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            SizedBox(height: 12),
                            Container(
                              constraints: BoxConstraints(maxHeight: 150),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: oldVersionUsers.map((user) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 16,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              '${user['name']} (v${user['version']})',
                                              style:
                                                  FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Figtree',
                                                        letterSpacing: 0.0,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // OK button (fixed at bottom)
            FFButtonWidget(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              text: 'Tamam',
              options: FFButtonOptions(
                width: double.infinity,
                height: 48,
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Figtree',
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                elevation: 0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 8),
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Figtree',
                letterSpacing: 0.0,
              ),
        ),
        Spacer(),
        Text(
          '$count kullanıcı',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Figtree',
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
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
            // Header
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mesaj Gönder',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${widget.userCount} kullanıcıya mesaj gönderilecek',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Figtree',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected badges
                      Text(
                        'Seçili Rozetler',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.badgeNames
                            .map((name) => Chip(
                                  label: Text(name),
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                  labelStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Figtree',
                                        color: FlutterFlowTheme.of(context).primary,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ))
                            .toList(),
                      ),

                      SizedBox(height: 24),

                      // Message input
                      Text(
                        'Mesaj',
                        style: FlutterFlowTheme.of(context).labelMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Mesajınızı buraya yazın...',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Figtree',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir mesaj girin';
                          }
                          if (value.length < 3) {
                            return 'Mesaj en az 3 karakter olmalıdır';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Divider(height: 1, thickness: 1),

            // Progress indicator
            if (_isSending) ...[
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                child: Column(
                  children: [
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _totalProgress > 0 ? _currentProgress / _totalProgress : null,
                        minHeight: 8,
                        backgroundColor: FlutterFlowTheme.of(context).alternate,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Status text
                    Column(
                      children: [
                        Text(
                          _currentStatus,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Figtree',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        if (_totalProgress > 0) ...[
                          SizedBox(height: 8),
                          Text(
                            '$_currentProgress/$_totalProgress (${((_currentProgress / _totalProgress) * 100).toInt()}%)',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Figtree',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1),
            ],

            // Actions
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _isSending ? null : () => Navigator.pop(context),
                      text: 'İptal',
                      options: FFButtonOptions(
                        height: 48,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Figtree',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _isSending ? null : _sendMessage,
                      text: 'Gönder',
                      icon: Icon(
                        Icons.send,
                        size: 20,
                      ),
                      options: FFButtonOptions(
                        height: 48,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Figtree',
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        elevation: 0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
