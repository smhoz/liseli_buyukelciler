import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/education_information/model/school_model/school_model.dart';
import 'package:sosyal_medya/pages/education_information/model/state_model/state_model.dart';
import 'package:sosyal_medya/pages/education_information/view/education_information_create/education_information_create_view.dart';

abstract class EducationInformationCreateViewModel extends State<EducationInformationCreateView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  final scaffoldKey = GlobalKey<FormState>();
  FocusNode? schoolNameFocusNode;
  TextEditingController schoolNameTextController = TextEditingController();
  String? Function(BuildContext, String?)? schoolNameTextControllerValidator;

  FocusNode? stateFocusNode;
  TextEditingController stateTextController = TextEditingController();
  String? Function(BuildContext, String?)? stateTextControllerValidator;

  FocusNode? classFocusNode;
  TextEditingController classTextController = TextEditingController();
  String? Function(BuildContext, String?)? classTextControllerValidator;

  DateTime selectedDateTimeStart = DateTime.now();
  DateTime selectedDateTimeEnd = DateTime.now();

  SchoolModel? selectedSchool;
  List<SchoolModel> schools = [];
  bool isSchoolLoading = true;

  StateModel? selectedState;
  List<StateModel> states = [];
  bool isStateLoading = true;

  Country? selectedCountry;
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    fetchSchool();
    fetchStates();
    fetchCountries();
  }

  Future<void> selectDateTimeStart() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTimeStart,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: Locale('tr', 'TR'),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeStart = DateTime(pickedDate.year);
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
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDateTimeEnd = DateTime(pickedDate.year);
      });
    }
  }

  Future<void> fetchSchool() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('school')
          .where('is_deleted', isEqualTo: false)
          .get();

      schools = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Eğer doc.id'yi de kullanmak istiyorsanız:
        data['id'] = doc.id;

        return SchoolModel.fromJson(data);
      }).toList();

      setState(() {
        isSchoolLoading = false;
      });
    } catch (e) {
      print("Okullar çekme hatası: $e");
      setState(() {
        isSchoolLoading = false;
      });
    }
  }

  Future<void> fetchStates() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('state')
          .where('is_deleted', isEqualTo: false)
          .get();

      states = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        data['id'] = doc.id;

        return StateModel.fromJson(data);
      }).toList();

      setState(() {
        isStateLoading = false;
      });
    } catch (e) {
      print("Okullar çekme hatası: $e");
      setState(() {
        isStateLoading = false;
      });
    }
  }

  void fetchCountries() {
    // country_picker paketinden tüm ülkeleri al
    countries = CountryService().getAll();
  }

  // Show country selection bottom sheet
  void showCountrySelectionBottomSheet() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Ülke ara...',
          hintText: 'Ülke adı girin',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    schoolNameFocusNode?.dispose();
    schoolNameTextController.dispose();

    stateFocusNode?.dispose();
    stateTextController.dispose();

    classFocusNode?.dispose();
    classTextController.dispose();
  }
}
