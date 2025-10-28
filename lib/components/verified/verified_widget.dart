import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/backend/schema/badge_model/badge_model.dart';
import 'package:sosyal_medya/util/base_utility.dart';

class VerifiedWidget extends StatelessWidget {
  const VerifiedWidget({
    super.key,
    required this.badgeModel,
  });

  final BadgeModel badgeModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BaseUtility.left(
        BaseUtility.paddingSmallValue,
      ),
      child: SizedBox(
        width: 28,
        height: 28,
        child: CachedNetworkImage(imageUrl: badgeModel.file_url),
      ),
    );
  }
}
