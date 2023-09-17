import 'exports.dart';

class AppColors {
  static const kPrimaryColor = Color.fromRGBO(33, 150, 243, 1);
  static const kSecondaryColor = Color.fromRGBO(23, 26, 35, 1);

  static const kScaffoldColor = Color.fromRGBO(254, 254, 254, 1);
}

class AppAssets {
  static const logoPNG = 'assets/images/app-logo.png';
  static const privacyPNG = 'assets/images/privacy-page.png';
}

class AppTextFieldConstants {
  static final kEnableBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );

  static final kFocuseBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: AppColors.kPrimaryColor,
    ),
  );

  static final kErrorOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      color: Color.fromRGBO(244, 67, 54, 1),
    ),
  );
}

class AppData {
  static const String appName = 'Chat App';
}
