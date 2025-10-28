import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyal_medya/pages/create_activity/model/acitivity_model.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'create_activity_view.dart' show CreateActivityView;
import 'package:flutter/material.dart';

abstract class CreateActivityViewModel extends State<CreateActivityView> {
  ///  State fields for stateful widgets in this page.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  ActivityModel? selectedActivity;
  List<ActivityModel> activity = [];
  bool isActivityLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('activity')
          .where('is_deleted', isEqualTo: false)
          .get();

      activity = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;

        return ActivityModel.fromJson(data);
      }).toList();

      setState(() {
        isActivityLoading = false;
      });
    } catch (e) {
      print("Aktivite çekme hatası: $e");
      setState(() {
        isActivityLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
