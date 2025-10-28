import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/event/model/event_model.dart';
import '/service/event_announcement_service.dart';

class EventAnnouncementDialogWidget extends StatefulWidget {
  const EventAnnouncementDialogWidget({
    super.key,
    required this.badgeIds,
    required this.badgeNames,
    required this.userCount,
  });

  final List<String> badgeIds;
  final List<String> badgeNames;
  final int userCount;

  @override
  State<EventAnnouncementDialogWidget> createState() => _EventAnnouncementDialogWidgetState();
}

class _EventAnnouncementDialogWidgetState extends State<EventAnnouncementDialogWidget> {
  List<EventModel> _events = [];
  bool _isLoading = true;
  bool _isSending = false;
  EventModel? _selectedEvent;
  String _currentStatus = '';
  int _currentStep = 0; // 0: idle, 1: sending notifications, 2: sending messages
  int _currentProgress = 0;
  int _totalProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      print('📅 Etkinlikler yükleniyor...');

      // Sadece is_deleted filtresi kullan (index gerektirmez)
      final snapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('is_deleted', isEqualTo: false)
          .orderBy('created_at', descending: true)
          .get();

      // Client-side filtering: is_completed = false olan etkinlikleri filtrele
      final events = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return EventModel.fromJson(data);
          })
          .where((event) => event.is_completed == false)
          .toList();

      // Tarihe göre sırala (client-side)
      events.sort((a, b) {
        if (a.event_date == null && b.event_date == null) return 0;
        if (a.event_date == null) return 1;
        if (b.event_date == null) return -1;
        return a.event_date!.compareTo(b.event_date!);
      });

      print('✅ ${events.length} etkinlik yüklendi');

      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Etkinlik yükleme hatası: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendAnnouncement() async {
    if (_selectedEvent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir etkinlik seçin'),
          backgroundColor: Colors.orange,
        ),
      );
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
      final service = EventAnnouncementService();
      final result = await service.sendEventAnnouncement(
        badgeIds: widget.badgeIds,
        event: _selectedEvent!,
        onNotificationProgress: (current, total) {
          setState(() {
            _currentProgress = current;
            _totalProgress = total;
            _currentStatus = 'Bildirimler gönderiliyor...';
          });
        },
        onMessageProgress: (current, total) {
          setState(() {
            _currentStep = 2;
            _currentProgress = current;
            _totalProgress = total;
            _currentStatus = 'Mesajlar gönderiliyor...';
          });
        },
      );

      // Get old version users from result
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
          notificationSuccessCount: result['notification_success'] ?? 0,
          notificationFailedCount: result['notification_failed'] ?? 0,
          messageSuccessCount: result['message_success'] ?? 0,
          messageFailedCount: result['message_failed'] ?? 0,
          oldVersionUsers: oldVersionUsers,
        ),
      );
    } catch (e) {
      print('❌ Etkinlik duyurusu gönderme hatası: $e');

      // Check if widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Duyuru gönderilirken hata oluştu: $e'),
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
                    Center(
                      child: Text(
                        'Etkinlik Duyurusu Gönderildi',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
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
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
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
                    color: FlutterFlowTheme.of(context).warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.event,
                    color: FlutterFlowTheme.of(context).warning,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etkinlik Duyurusu',
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

            // Event selection label
            Text(
              'Etkinlik Seçin',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Figtree',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            SizedBox(height: 12),

            // Events list
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _events.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 64,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Aktif etkinlik bulunamadı',
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Figtree',
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _events.length,
                          itemBuilder: (context, index) {
                            final event = _events[index];
                            final isSelected = _selectedEvent?.id == event.id;

                            return Container(
                              margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedEvent = event;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                                          : FlutterFlowTheme.of(context).secondaryBackground,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? FlutterFlowTheme.of(context).primary
                                            : FlutterFlowTheme.of(context).alternate,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // Event image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: event.event_image,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, error, stackTrace) {
                                              return Container(
                                                width: 60,
                                                height: 60,
                                                color: FlutterFlowTheme.of(context).alternate,
                                                child: Icon(
                                                  Icons.event,
                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        SizedBox(width: 12),

                                        // Event info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.title,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Figtree',
                                                      letterSpacing: 0.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                event.event_date != null
                                                    ? dateTimeFormat(
                                                        'd/M/y', event.event_date!.toDate())
                                                    : 'Tarih belirtilmemiş',
                                                style:
                                                    FlutterFlowTheme.of(context).bodySmall.override(
                                                          fontFamily: 'Figtree',
                                                          color: FlutterFlowTheme.of(context)
                                                              .secondaryText,
                                                          letterSpacing: 0.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Selection indicator
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: FlutterFlowTheme.of(context).primary,
                                            size: 24,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),

            SizedBox(height: 24),

            // Progress indicator
            if (_isSending) ...[
              // Step indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Step 1: Notification
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _currentStep >= 1
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
                        ),
                        child: _currentStep > 1
                            ? Icon(Icons.check, color: Colors.white, size: 20)
                            : _currentStep == 1
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Icon(Icons.notifications,
                                    color: FlutterFlowTheme.of(context).secondaryText, size: 20),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Bildirim',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Figtree',
                              color: _currentStep >= 1
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),

                  // Connector line
                  Container(
                    width: 60,
                    height: 2,
                    margin: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 24),
                    color: _currentStep >= 2
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate,
                  ),

                  // Step 2: Message
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _currentStep >= 2
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).alternate,
                          shape: BoxShape.circle,
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
                            : Icon(Icons.message,
                                color: _currentStep >= 2
                                    ? Colors.white
                                    : FlutterFlowTheme.of(context).secondaryText,
                                size: 20),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mesaj',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Figtree',
                              color: _currentStep >= 2
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
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
                    onPressed: _isSending ? null : _sendAnnouncement,
                    text: _isSending ? 'Gönderiliyor...' : 'Duyuru Gönder',
                    options: FFButtonOptions(
                      height: 48,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).warning,
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
    );
  }
}
