import 'package:flutter/material.dart';

import 'package:sosyal_medya/auth/firebase_auth/auth_util.dart';
import 'package:sosyal_medya/backend/backend.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/pages/education_information/model/state_model/state_model.dart';
import 'package:sosyal_medya/pages/event/model/event_model.dart';
import 'package:sosyal_medya/pages/event/view/event_detail/event_detail_viewmodel.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({
    super.key,
    required this.eventModel,
  });

  final EventModel eventModel;

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends EventDetailViewModel {
  late bool isJoinStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: responsiveVisibility(
        context: context,
        tabletLandscape: false,
        desktop: false,
      )
          ? AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              title: Text(
                'Etkinlik Hakkında',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                    ),
              ),
              centerTitle: false,
              elevation: 0.0,
            )
          : null,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // body
            Expanded(
              child: ListView(
                children: <Widget>[
                  // image
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          image: DecorationImage(
                            image: NetworkImage(widget.eventModel.event_image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // created at
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range_outlined,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 21,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${widget.eventModel.event_date!.toDate().day.toString().padLeft(2, '0')}.${widget.eventModel.event_date!.toDate().month.toString().padLeft(2, '0')}.${widget.eventModel.event_date!.toDate().year.toString().padLeft(2, '0')} - ${widget.eventModel.event_date!.toDate().hour.toString().padLeft(2, '0')}:${widget.eventModel.event_date!.toDate().minute.toString().padLeft(2, '0')}',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // title
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.eventModel.title,
                        style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  // location
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: FlutterFlowTheme.of(context).secondary,
                            size: 21,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('state')
                                    .doc(widget.eventModel.state_id)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const SizedBox();
                                  }

                                  if (snapshot.hasData) {
                                    final stateData = snapshot.data!.data()
                                        as Map<String, dynamic>;
                                    final StateModel stateModel =
                                        StateModel.fromJson(stateData);
                                    return Text(
                                      '${stateModel.name}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // sub title
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.eventModel.explanation,
                        style: FlutterFlowTheme.of(context).bodyMedium,
                      ),
                    ),
                  ),
                  // google map
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: GestureDetector(
                      onTap: () => openMap(),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // icon
                              Icon(
                                Icons.link,
                                color: Colors.white,
                                size: 21,
                              ),
                              // title
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Web Bağlantısına Git",
                                  style: TextStyle(
                                    color: Colors.white,
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
            ),
            // footer button
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('event_user')
                  .where('event_id', isEqualTo: widget.eventModel.id)
                  .where('user_id', isEqualTo: currentUserReference)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                bool isJoined =
                    snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                return GestureDetector(
                  onTap: widget.eventModel.is_completed == true
                      ? () {}
                      : () async {
                          if (isJoined) {
                            final docId = snapshot.data!.docs.first.id;
                            await FirebaseFirestore.instance
                                .collection('event_user')
                                .doc(docId)
                                .delete();
                          } else {
                            await FirebaseFirestore.instance
                                .collection('event_user')
                                .add({
                              'id': null,
                              'event_id': widget.eventModel.id,
                              'user_id': currentUserReference,
                              'created_at': FieldValue.serverTimestamp(),
                            }).then((val) {
                              val.update({'id': val.id});
                            });
                          }

                          setState(() {});
                        },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Text(
                        widget.eventModel.is_completed == true
                            ? 'Etkinlik İptal Edildi'
                            : isJoined
                                ? 'Etkinliğe Katıldınız (İptal Et)'
                                : 'Etkinliğe Katıl',
                        style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
