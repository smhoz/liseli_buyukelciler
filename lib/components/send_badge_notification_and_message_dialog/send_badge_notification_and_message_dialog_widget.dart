import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/service/badge_notification_service.dart';
import '/service/system_chat_service.dart';

class SendBadgeNotificationAndMessageDialogWidget extends StatefulWidget {
  const SendBadgeNotificationAndMessageDialogWidget({
    super.key,
    required this.badgeIds,
    required this.badgeNames,
    required this.userCount,
  });

  final List<String> badgeIds;
  final List<String> badgeNames;
  final int userCount;

  @override
  State<SendBadgeNotificationAndMessageDialogWidget> createState() =>
      _SendBadgeNotificationAndMessageDialogWidgetState();
}

class _SendBadgeNotificationAndMessageDialogWidgetState
    extends State<SendBadgeNotificationAndMessageDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;
  String _currentStatus = '';
  int _currentStep = 0; // 0: idle, 1: sending notifications, 2: sending messages
  int _currentProgress = 0;
  int _totalProgress = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendNotificationAndMessage() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
      _currentStep = 1;
      _currentProgress = 0;
      _totalProgress = 0;
      _currentStatus = 'Bildirimler gönderiliyor...';
    });

    try {
      // Send notification with progress tracking
      final notificationService = BadgeNotificationService();
      final notificationResult = await notificationService.sendNotificationToBadgeHolders(
        badgeIds: widget.badgeIds.toSet(),
        title: _titleController.text,
        body: _messageController.text,
        onProgress: (current, total) {
          setState(() {
            _currentProgress = current;
            _totalProgress = total;
            _currentStatus = 'Bildirimler gönderiliyor...';
          });
        },
      );

      // Update status for messages
      setState(() {
        _currentStep = 2;
        _currentProgress = 0;
        _totalProgress = 0;
        _currentStatus = 'Mesajlar gönderiliyor...';
      });

      // Send message with progress tracking
      final systemChatService = SystemChatService();
      final messageResult = await systemChatService.sendMessageToBadgeHolders(
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

      // Get old version users from message result
      final oldVersionUsers = (messageResult['oldVersionUsers'] as List?)
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
          notificationSuccessCount: notificationResult['success'] ?? 0,
          notificationFailedCount: notificationResult['failed'] ?? 0,
          messageSuccessCount: messageResult['success'] ?? 0,
          messageFailedCount: messageResult['failed'] ?? 0,
          oldVersionUsers: oldVersionUsers,
        ),
      );
    } catch (e) {
      print('❌ Bildirim ve mesaj gönderme hatası: $e');

      // Check if widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gönderim sırasında hata oluştu: $e'),
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
    required int notificationSuccessCount,
    required int notificationFailedCount,
    required int messageSuccessCount,
    required int messageFailedCount,
    List<Map<String, String>> oldVersionUsers = const [],
  }) {
    final overallSuccess = notificationSuccessCount > 0 && messageSuccessCount > 0;

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
                        color: overallSuccess
                            ? FlutterFlowTheme.of(context).success.withOpacity(0.1)
                            : FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        overallSuccess ? Icons.check_circle : Icons.error,
                        color: overallSuccess
                            ? FlutterFlowTheme.of(context).success
                            : FlutterFlowTheme.of(context).error,
                        size: 32,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Title
                    Text(
                      'Gönderim Tamamlandı',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Outfit',
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),

                    SizedBox(height: 16),

                    // Notification Results
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification section
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: FlutterFlowTheme.of(context).success,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Bildirim',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildResultRow(
                            icon: Icons.check_circle,
                            iconColor: FlutterFlowTheme.of(context).success,
                            label: 'Başarılı',
                            count: notificationSuccessCount,
                          ),
                          if (notificationFailedCount > 0) ...[
                            SizedBox(height: 8),
                            _buildResultRow(
                              icon: Icons.error,
                              iconColor: FlutterFlowTheme.of(context).error,
                              label: 'Başarısız',
                              count: notificationFailedCount,
                            ),
                          ],

                          SizedBox(height: 16),
                          Divider(height: 1, thickness: 1),
                          SizedBox(height: 16),

                          // Message section
                          Row(
                            children: [
                              Icon(
                                Icons.message,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Mesaj',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Figtree',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          _buildResultRow(
                            icon: Icons.check_circle,
                            iconColor: FlutterFlowTheme.of(context).success,
                            label: 'Başarılı',
                            count: messageSuccessCount,
                          ),
                          if (messageFailedCount > 0) ...[
                            SizedBox(height: 8),
                            _buildResultRow(
                              icon: Icons.error,
                              iconColor: FlutterFlowTheme.of(context).error,
                              label: 'Başarısız',
                              count: messageFailedCount,
                            ),
                          ],
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
        Icon(icon, color: iconColor, size: 16),
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
        constraints: BoxConstraints(maxWidth: 500),
        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.campaign,
                      color: FlutterFlowTheme.of(context).tertiary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bildirim ve Mesaj Gönder',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${widget.userCount} kullanıcı • ${widget.badgeNames.join(", ")}',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Figtree',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Title field
              Text(
                'Bildirim Başlığı',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Örn: Yeni Duyuru',
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
                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir başlık girin';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Message field
              Text(
                'Mesaj',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
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
                  contentPadding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Figtree',
                      letterSpacing: 0.0,
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir mesaj girin';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),

              // Progress indicator (shown when sending)
              if (_isSending) ...[
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Progress steps
                      Row(
                        children: [
                          // Step 1: Notifications
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentStep >= 1
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).secondaryBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 2,
                                    ),
                                  ),
                                  child: _currentStep == 1
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Icon(
                                          _currentStep > 1 ? Icons.check : Icons.notifications,
                                          color: _currentStep >= 1
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).primary,
                                          size: 20,
                                        ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Bildirim',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                        fontWeight:
                                            _currentStep == 1 ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Connector line
                          Expanded(
                            child: Container(
                              height: 2,
                              color: _currentStep >= 2
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).alternate,
                            ),
                          ),

                          // Step 2: Messages
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _currentStep >= 2
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context).secondaryBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _currentStep >= 2
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context).alternate,
                                      width: 2,
                                    ),
                                  ),
                                  child: _currentStep == 2
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Icon(
                                          Icons.message,
                                          color: _currentStep >= 2
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context).secondaryText,
                                          size: 20,
                                        ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Mesaj',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                        fontWeight:
                                            _currentStep == 2 ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

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
                SizedBox(height: 24),
              ],

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: _isSending
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
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
                      onPressed: _isSending ? null : _sendNotificationAndMessage,
                      text: _isSending ? 'Gönderiliyor...' : 'Gönder',
                      options: FFButtonOptions(
                        height: 48,
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).tertiary,
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
            ],
          ),
        ),
      ),
    );
  }
}
