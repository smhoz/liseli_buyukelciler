import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/education_information/view/education_information_edit/education_information_edit_view.dart';

abstract class EducationInformationEditViewModel extends State<EducationInformationEditView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();
  final scaffoldKey = GlobalKey<FormState>();
  FocusNode? schoolNameFocusNode;
  late TextEditingController schoolNameTextController = TextEditingController(
    text: widget.model.school_name ?? '',
  );
  String? Function(BuildContext, String?)? schoolNameTextControllerValidator;

  FocusNode? stateFocusNode;
  late TextEditingController stateTextController = TextEditingController(
    text: widget.model.state_name ?? '',
  );
  String? Function(BuildContext, String?)? stateTextControllerValidator;

  FocusNode? classFocusNode;
  late TextEditingController classTextController = TextEditingController(
    text: widget.model.class_name ?? '',
  );
  String? Function(BuildContext, String?)? classTextControllerValidator;

  late DateTime selectedDateTimeStart = DateTime(widget.model.date_start ?? DateTime.now().year);
  late DateTime selectedDateTimeEnd = DateTime(widget.model.date_end ?? DateTime.now().year);

  Country? selectedCountry;
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
    // Mevcut ülkeyi seç
    if (widget.model.country_code != null) {
      try {
        selectedCountry = CountryParser.parseCountryCode(widget.model.country_code!);
      } catch (e) {
        print('Ülke kodu parse edilemedi: ${widget.model.country_code}');
      }
    }
  }

  void fetchCountries() {
    countries = CountryService().getAll();
  }

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

  // Dropdown fonksiyonları kaldırıldı, artık text field kullanılıyor

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
