import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class BadgeActionsBottomSheetWidget extends StatelessWidget {
  const BadgeActionsBottomSheetWidget({
    super.key,
    required this.badgeIds,
    required this.badgeNames,
    required this.userCount,
  });

  final List<String> badgeIds;
  final List<String> badgeNames;
  final int userCount;

  @override
  Widget build(BuildContext context) {
    // Determine target description based on badge selection
    String targetDescription;
    if (badgeNames.contains('Tüm Kullanıcılar')) {
      targetDescription = 'tüm kullanıcılara';
    } else if (badgeNames.contains('Rozetli Kullanıcılar')) {
      targetDescription = 'rozetli kullanıcılara';
    } else {
      targetDescription = 'seçili rozet sahiplerine';
    }

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).alternate,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 20, 24, 16),
            child: Row(
              children: [
                Icon(
                  Icons.badge,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rozet Aksiyonları',
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$userCount kullanıcı • ${badgeNames.join(", ")}',
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
          ),

          Divider(height: 1, thickness: 1),

          // Action items
          _buildActionItem(
            context: context,
            icon: Icons.notifications_active,
            iconColor: FlutterFlowTheme.of(context).success,
            iconBgColor: FlutterFlowTheme.of(context).success.withOpacity(0.1),
            title: 'Bildirim Gönder',
            subtitle:
                '${targetDescription.substring(0, 1).toUpperCase()}${targetDescription.substring(1)} bildirim gönder',
            onTap: () {
              Navigator.pop(context, 'notification');
            },
          ),

          _buildActionItem(
            context: context,
            icon: Icons.message,
            iconColor: FlutterFlowTheme.of(context).primary,
            iconBgColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
            title: 'Mesaj Gönder',
            subtitle:
                '${targetDescription.substring(0, 1).toUpperCase()}${targetDescription.substring(1)} mesaj gönder',
            onTap: () {
              Navigator.pop(context, 'message');
            },
            isComingSoon: false, // ✅ Artık aktif!
          ),

          _buildActionItem(
            context: context,
            icon: Icons.campaign,
            iconColor: FlutterFlowTheme.of(context).tertiary,
            iconBgColor: FlutterFlowTheme.of(context).tertiary.withOpacity(0.1),
            title: 'Bildirim ve Mesaj Gönder',
            subtitle:
                '${targetDescription.substring(0, 1).toUpperCase()}${targetDescription.substring(1)} hem bildirim hem mesaj gönder',
            onTap: () {
              Navigator.pop(context, 'both');
            },
            isComingSoon: false, // ✅ Artık aktif!
          ),

          _buildActionItem(
            context: context,
            icon: Icons.event,
            iconColor: FlutterFlowTheme.of(context).warning,
            iconBgColor: FlutterFlowTheme.of(context).warning.withOpacity(0.1),
            title: 'Etkinlik Duyurusu Yap',
            subtitle: 'Etkinlik seçip $targetDescription duyuru gönder',
            onTap: () {
              Navigator.pop(context, 'event_announcement');
            },
            isComingSoon: false,
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),

            SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Figtree',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              color: isComingSoon
                                  ? FlutterFlowTheme.of(context).secondaryText
                                  : FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                      if (isComingSoon) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 2, 6, 2),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).accent3,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Yakında',
                            style: FlutterFlowTheme.of(context).labelSmall.override(
                                  fontFamily: 'Figtree',
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  letterSpacing: 0.0,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Figtree',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),

            // Arrow
            if (!isComingSoon)
              Icon(
                Icons.arrow_forward_ios,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
