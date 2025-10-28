import 'package:flutter/material.dart';
import 'package:sosyal_medya/pages/event/view/event_detail/event_detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class EventDetailViewModel extends State<EventDetailView> {
  late final String mapUrl = widget.eventModel.address_url;

  Future<void> openMap() async {
    final Uri uri = Uri.parse(mapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Web Bağlantısı açılamadı: $mapUrl';
    }
  }
}
