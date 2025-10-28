import 'package:flutter/material.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/turkey_education_information/view/education_create/education_create_viewmodel.dart';
import 'package:sosyal_medya/pages/turkey_education_information/view/education_edit/education_edit_view.dart';

abstract class EducationEditViewModel extends State<EducationEditView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  EducationCreateType? selectEducationType = EducationCreateType.university;

  late bool isEducation = widget.model.is_continues ?? false;

  final scaffoldKey = GlobalKey<FormState>();
  FocusNode? schoolNameFocusNode;
  late TextEditingController schoolNameTextController = TextEditingController(
    text: widget.model.school_name ?? '',
  );
  String? Function(BuildContext, String?)? schoolNameTextControllerValidator;

  FocusNode? chapterFocusNode;
  late TextEditingController chapterTextController = TextEditingController(
    text: widget.model.chapter ?? '',
  );
  String? Function(BuildContext, String?)? chapterTextControllerValidator;

  late DateTime selectedDateTimeEntry = DateTime(widget.model.date_entry ?? DateTime.now().year);
  late DateTime selectedDateTimeGraduation =
      DateTime(widget.model.date_graduation ?? DateTime.now().year);

  // Artık text field kullanıyor, dropdown kodları kaldırıldı

  @override
  void initState() {
    super.initState();
    // Text field kullanıldığı için dropdown işlemleri kaldırıldı
  }

  Future<void> selectDateTimeEntry() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTimeEntry,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      locale: const Locale('tr', 'TR'),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeEntry = DateTime(pickedDate.year);
      });
    }
  }

  Future<void> selectDateTimeGraduation() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTimeGraduation,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      locale: Locale('tr', 'TR'),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeGraduation = DateTime(pickedDate.year);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    schoolNameFocusNode?.dispose();
    schoolNameTextController.dispose();

    chapterFocusNode?.dispose();
    chapterTextController.dispose();
  }
}
