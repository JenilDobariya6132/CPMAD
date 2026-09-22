import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> translations = {
    'en': {
      'appTitle': 'Student Information',
      'home': 'Home',
      'students': 'Students',
      'addStudent': 'Add Student',
      'calculator': 'Calculator',
      'language': 'Language',
      'english': 'English',
      'gujarati': 'Gujarati',
      'hindi': 'Hindi',
      'name': 'Name',
      'email': 'Email',
      'age': 'Age',
      'course': 'Course',
      'marks': 'Marks',
      'date': 'Date',
      'enterName': 'Enter name',
      'enterEmail': 'Enter email',
      'enterAge': 'Enter age',
      'enterCourse': 'Enter course',
      'enterMarks': 'Enter marks',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'studentAdded': 'Student added successfully',
      'studentDeleted': 'Student deleted',
      'noStudents': 'No students available',
      'requiredName': 'Please enter name',
      'requiredEmail': 'Please enter email',
      'requiredAge': 'Please enter age',
      'requiredCourse': 'Please enter course',
      'requiredMarks': 'Please enter marks',
      'selectLanguage': 'Select Language',
      'studentInformation': 'Student Information',
      'calculatorTitle': 'Calculator',
      'number1': 'Number 1',
      'number2': 'Number 2',
      'addition': 'Addition',
      'subtraction': 'Subtraction',
      'multiplication': 'Multiplication',
      'division': 'Division',
      'calculate': 'Calculate',
      'result': 'Result',
      'enterNumbers': 'Please enter both numbers',
      'cannotDivide': 'Cannot divide by zero',
    },
    'gu': {
      'appTitle': 'વિદ્યાર્થી માહિતી',
      'home': 'હોમ',
      'students': 'વિદ્યાર્થીઓ',
      'addStudent': 'વિદ્યાર્થી ઉમેરો',
      'calculator': 'કેલ્ક્યુલેટર',
      'language': 'ભાષા',
      'english': 'અંગ્રેજી',
      'gujarati': 'ગુજરાતી',
      'hindi': 'હિન્દી',
      'name': 'નામ',
      'email': 'ઈમેલ',
      'age': 'ઉંમર',
      'course': 'અભ્યાસક્રમ',
      'marks': 'ગુણ',
      'date': 'તારીખ',
      'enterName': 'નામ દાખલ કરો',
      'enterEmail': 'ઈમેલ દાખલ કરો',
      'enterAge': 'ઉંમર દાખલ કરો',
      'enterCourse': 'અભ્યાસક્રમ દાખલ કરો',
      'enterMarks': 'ગુણ દાખલ કરો',
      'save': 'સાચવો',
      'cancel': 'રદ કરો',
      'delete': 'કાઢી નાખો',
      'edit': 'ફેરફાર કરો',
      'studentAdded': 'વિદ્યાર્થી સફળતાપૂર્વક ઉમેરાયો',
      'studentDeleted': 'વિદ્યાર્થી કાઢી નાખ્યો',
      'noStudents': 'કોઈ વિદ્યાર્થી ઉપલબ્ધ નથી',
      'requiredName': 'કૃપા કરીને નામ દાખલ કરો',
      'requiredEmail': 'કૃપા કરીને ઈમેલ દાખલ કરો',
      'requiredAge': 'કૃપા કરીને ઉંમર દાખલ કરો',
      'requiredCourse': 'કૃપા કરીને અભ્યાસક્રમ દાખલ કરો',
      'requiredMarks': 'કૃપા કરીને ગુણ દાખલ કરો',
      'selectLanguage': 'ભાષા પસંદ કરો',
      'studentInformation': 'વિદ્યાર્થી માહિતી',
      'calculatorTitle': 'કેલ્ક્યુલેટર',
      'number1': 'નંબર 1',
      'number2': 'નંબર 2',
      'addition': 'સરવાળો',
      'subtraction': 'બાદબાકી',
      'multiplication': 'ગુણાકાર',
      'division': 'ભાગાકાર',
      'calculate': 'ગણતરી કરો',
      'result': 'પરિણામ',
      'enterNumbers': 'કૃપા કરીને બંને નંબર દાખલ કરો',
      'cannotDivide': 'શૂન્યથી ભાગાકાર કરી શકાતો નથી',
    },
    'hi': {
      'appTitle': 'छात्र जानकारी',
      'home': 'होम',
      'students': 'छात्र',
      'addStudent': 'छात्र जोड़ें',
      'calculator': 'कैलकुलेटर',
      'language': 'भाषा',
      'english': 'अंग्रेज़ी',
      'gujarati': 'गुजराती',
      'hindi': 'हिन्दी',
      'name': 'नाम',
      'email': 'ईमेल',
      'age': 'उम्र',
      'course': 'पाठ्यक्रम',
      'marks': 'अंक',
      'date': 'तारीख',
      'enterName': 'नाम दर्ज करें',
      'enterEmail': 'ईमेल दर्ज करें',
      'enterAge': 'उम्र दर्ज करें',
      'enterCourse': 'पाठ्यक्रम दर्ज करें',
      'enterMarks': 'अंक दर्ज करें',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'studentAdded': 'छात्र सफलतापूर्वक जोड़ा गया',
      'studentDeleted': 'छात्र हटा दिया गया',
      'noStudents': 'कोई छात्र उपलब्ध नहीं है',
      'requiredName': 'कृपया नाम दर्ज करें',
      'requiredEmail': 'कृपया ईमेल दर्ज करें',
      'requiredAge': 'कृपया उम्र दर्ज करें',
      'requiredCourse': 'कृपया पाठ्यक्रम दर्ज करें',
      'requiredMarks': 'कृपया अंक दर्ज करें',
      'selectLanguage': 'भाषा चुनें',
      'studentInformation': 'छात्र जानकारी',
      'calculatorTitle': 'कैलकुलेटर',
      'number1': 'संख्या 1',
      'number2': 'संख्या 2',
      'addition': 'जोड़',
      'subtraction': 'घटाव',
      'multiplication': 'गुणा',
      'division': 'भाग',
      'calculate': 'गणना करें',
      'result': 'परिणाम',
      'enterNumbers': 'कृपया दोनों संख्याएं दर्ज करें',
      'cannotDivide': 'शून्य से विभाजित नहीं कर सकते',
    },
  };

  String translate(String key) {
    return translations[locale.languageCode]?[key] ??
        translations['en']![key] ??
        key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'gu', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return false;
  }
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get tr {
    return Localizations.of<AppLocalizations>(
          this,
          AppLocalizations,
        ) ??
        AppLocalizations(const Locale('en'));
  }
}
