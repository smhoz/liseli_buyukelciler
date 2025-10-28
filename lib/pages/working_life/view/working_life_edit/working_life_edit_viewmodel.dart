import 'package:flutter/material.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/working_life/view/working_life_edit/working_life_edit_view.dart';

abstract class WorkingLifeEditViewModel extends State<WorkingLifeEditView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  final scaffoldKey = GlobalKey<FormState>();
  FocusNode? companyNameFocusNode;
  late TextEditingController companyNameTextController = TextEditingController(
    text: widget.model.company_name,
  );
  String? Function(BuildContext, String?)? schoolNameTextControllerValidator;

  FocusNode? taskNameFocusNode;
  late TextEditingController taskNameTextController = TextEditingController(
    text: widget.model.task,
  );
  String? Function(BuildContext, String?)? stateTextControllerValidator;

  late bool isWorking = widget.model.is_working;
  late DateTime selectedDateTimeStart = widget.model.date_start!.toDate();
  late DateTime selectedDateTimeEnd = widget.model.date_end!.toDate();

  Future<void> selectDateTimeStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTimeStart,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: Locale('tr', 'TR'),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeStart = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  Future<void> selectDateTimeEnd() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTimeEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: Locale('tr', 'TR'),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeEnd = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    companyNameFocusNode?.dispose();
    companyNameTextController.dispose();

    taskNameFocusNode?.dispose();
    taskNameTextController.dispose();
  }
}
