import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/components/verified/verified_widget.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/helper/show_dialogs.dart';

/// Widget to display multiple badges (max 3) with overflow count
/// Example: 🏆 🏆 🏆 +2
/// Each badge is clickable and shows badge details in a modal
class MultipleBadgesDisplayWidget extends StatelessWidget {
  const MultipleBadgesDisplayWidget({
    super.key,
    required this.badgeIds,
    this.maxBadgesToShow = 3,
  });

  final List<String> badgeIds;
  final int maxBadgesToShow;

  /// Show all badges in a bottom sheet
  void _showAllBadges(BuildContext context) {
    final dynamicViewExtensions = DynamicViewExtensions();

    CodeNoahDialogs(context).showModalNewBottom(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      barrierColor: Colors.black54,
      dynamicViewExtensions,
      'TÜM ROZETLER',
      dynamicViewExtensions.dynamicHeight(context, 0.6),
      [
        StreamBuilder<List<DocumentSnapshot>>(
          stream: _getBadgesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Rozetler yüklenirken hata oluştu',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final badges = snapshot.data!;

            if (badges.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Rozet bulunamadı',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: badges.asMap().entries.map((entry) {
                final index = entry.key;
                final badgeDoc = entry.value;
                final badgeModel = BadgeModel.fromJson({
                  'id': badgeDoc.id,
                  ...badgeDoc.data() as Map<String, dynamic>,
                });

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ListTile(
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: CachedNetworkImage(imageUrl: badgeModel.file_url),
                      ),
                      title: Text(
                        badgeModel.name,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// Get stream of all badge documents
  Stream<List<DocumentSnapshot>> _getBadgesStream() {
    return FirebaseFirestore.instance
        .collection('badge')
        .where(FieldPath.documentId, whereIn: badgeIds)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    if (badgeIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final badgesToDisplay = badgeIds.take(maxBadgesToShow).toList();
    final remainingCount = badgeIds.length - badgesToDisplay.length;
    final dynamicViewExtensions = DynamicViewExtensions();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display first N badges
        ...badgesToDisplay.asMap().entries.map((entry) {
          final badgeId = entry.value;
          final isFirst = entry.key == 0;

          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              isFirst ? 4.0 : 2.0,
              0.0,
              0.0,
              0.0,
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('badge').doc(badgeId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox.shrink();
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  final badgeModel = BadgeModel.fromJson({
                    'id': snapshot.data!.id,
                    ...snapshot.data!.data() as Map<String, dynamic>,
                  });

                  return GestureDetector(
                    onTap: () {
                      CodeNoahDialogs(context).showModalNewBottom(
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        barrierColor: Colors.black54,
                        dynamicViewExtensions,
                        'ROZET',
                        dynamicViewExtensions.dynamicHeight(context, 0.2),
                        [
                          ListTile(
                            leading: SizedBox(
                              width: 35,
                              height: 35,
                              child: CachedNetworkImage(imageUrl: badgeModel.file_url),
                            ),
                            title: Text(
                              badgeModel.name,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      );
                    },
                    child: VerifiedWidget(badgeModel: badgeModel),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        }),

        // Display remaining count if any (clickable to show all badges)
        if (remainingCount > 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
            child: GestureDetector(
              onTap: () => _showAllBadges(context),
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(4.0, 2.0, 4.0, 2.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '+$remainingCount',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Figtree',
                        color: FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
