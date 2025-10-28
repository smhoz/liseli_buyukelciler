import 'package:flutter/material.dart';
import 'package:sosyal_medya/backend/schema/index.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_util.dart';
import 'package:sosyal_medya/pages/event/event_viewmodel.dart';
import 'package:sosyal_medya/pages/event/model/event_model.dart';
import 'package:sosyal_medya/pages/event/view/event_detail/event_detail_view.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  static String routeName = 'main_Event';
  static String routePath = '/mainEvent';

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends EventViewModel {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
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
                'Etkinlikler',
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where('is_deleted', isEqualTo: false)
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              List<EventModel> eventList = snapshot.data!.docs.map((DocumentSnapshot document) {
                final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return EventModel.fromJson(data);
              }).toList();

              return eventList.isEmpty
                  ? Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_outlined,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 90.0,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                            child: Text(
                              'Etkinlik Bulunmuyor',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(32.0, 8.0, 32.0, 0.0),
                            child: Text(
                              'Görünüşe göre yakın zamanda bir etkinlik bulunmuyor.',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Figtree',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: eventList.where((model) => model.is_completed == false).length,
                      itemBuilder: (context, index) {
                        final model = eventList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailView(
                                  eventModel: model,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            margin: EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  // event image
                                  SizedBox(
                                    width: dynamicViewExtensions.maxWidth(context),
                                    height: dynamicViewExtensions.dynamicHeight(context, 0.2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        image: DecorationImage(
                                          image: NetworkImage(model.event_image),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // event information
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: <Widget>[
                                        // title
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              model.title,
                                              textAlign: TextAlign.left,
                                              style:
                                                  Theme.of(context).textTheme.titleMedium!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        // create at
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Text(
                                                'Etkinlik Tarihi: ${model.event_date!.toDate().day.toString().padLeft(2, '0')}.${model.event_date!.toDate().month.toString().padLeft(2, '0')}.${model.event_date!.toDate().year.toString().padLeft(2, '0')} - ${model.event_date!.toDate().hour.toString().padLeft(2, '0')}:${model.event_date!.toDate().minute.toString().padLeft(2, '0')}',
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context).textTheme.bodyMedium!),
                                          ),
                                        ),
                                        // explanation
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Text(
                                              model.explanation,
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context).textTheme.bodyMedium!,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
