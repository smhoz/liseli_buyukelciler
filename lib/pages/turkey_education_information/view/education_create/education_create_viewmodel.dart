import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/education_information/model/school_model/school_model.dart';
import 'package:sosyal_medya/pages/turkey_education_information/view/education_create/education_create_view.dart';
import 'package:sosyal_medya/pages/turkey_education_information/view/education_create/widgets/school_selection_bottom_sheet.dart';

enum EducationCreateType { highSchool, university }

abstract class EducationCreateViewModel extends State<EducationCreateView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  EducationCreateType? selectEducationType = EducationCreateType.university;

  late bool isEducation = false;

  final scaffoldKey = GlobalKey<FormState>();
  FocusNode? schoolNameFocusNode;
  TextEditingController schoolNameTextController = TextEditingController();
  String? Function(BuildContext, String?)? schoolNameTextControllerValidator;

  FocusNode? chapterFocusNode;
  TextEditingController chapterTextController = TextEditingController();
  String? Function(BuildContext, String?)? chapterTextControllerValidator;

  DateTime selectedDateTimeEntry = DateTime.now();
  DateTime selectedDateTimeGraduation = DateTime.now();

  SchoolModel? selectedSchool;
  List<SchoolModel> schools = [];
  List<SchoolModel> filteredSchools = [];
  bool isSchoolLoading = true;

  // Update filtered schools based on education type
  void updateFilteredSchools() {
    if (selectEducationType == EducationCreateType.highSchool) {
      // Lise için is_education_type = false
      filteredSchools = schools.where((school) => school.is_education_type == false).toList();
      print('Lise seçildi. Filtrelenmiş okul sayısı: ${filteredSchools.length}');
    } else {
      // Üniversite için is_education_type = true
      filteredSchools = schools.where((school) => school.is_education_type == true).toList();
      print('Üniversite seçildi. Filtrelenmiş okul sayısı: ${filteredSchools.length}');
    }
  }

  // Show school selection bottom sheet
  Future<void> showSchoolSelectionBottomSheet() async {
    final result = await showModalBottomSheet<SchoolModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SchoolSelectionBottomSheet(
        schools: filteredSchools,
        selectedSchool: selectedSchool,
        title: selectEducationType == EducationCreateType.highSchool
            ? 'Lise Seçin'
            : 'Üniversite Seçin',
      ),
    );

    if (result != null) {
      setState(() {
        selectedSchool = result;
      });
    }
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
  void initState() {
    super.initState();
    fetchSchool();
  }

  Future<void> fetchSchool() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('school')
          .where('is_deleted', isEqualTo: false)
          .get();

      schools = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;

        return SchoolModel.fromJson(data);
      }).toList();

      print('Toplam okul sayısı: ${schools.length}');
      print('Lise sayısı: ${schools.where((s) => s.is_education_type == false).length}');
      print('Üniversite sayısı: ${schools.where((s) => s.is_education_type == true).length}');

      setState(() {
        updateFilteredSchools();
        isSchoolLoading = false;
      });
    } catch (e) {
      print("Okullar çekme hatası: $e");
      setState(() {
        isSchoolLoading = false;
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
