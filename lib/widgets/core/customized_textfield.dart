import '../../exports.dart';

class CustomizedTextField extends StatelessWidget {
  final String name;
  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? initialValue;
  final TextInputAction textInputAction;
  const CustomizedTextField(
      {super.key,
      required this.name,
      required this.hintText,
      this.suffixIcon,
      this.obscureText = false,
      this.validator,
      this.initialValue,
      required this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.screenWidth(context) * 0.9,
      child: FormBuilderTextField(
        textInputAction: textInputAction,
        validator: validator,
        initialValue: initialValue,
        name: name,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.kSecondaryColor),
        cursorColor: AppColors.kPrimaryColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(letterSpacing: 1, color: AppColors.kSecondaryColor),
          fillColor: Colors.grey[200],
          filled: true,
          enabledBorder: AppTextFieldConstants.kEnableBorder,
          focusedBorder: AppTextFieldConstants.kFocuseBorder,
          errorBorder: AppTextFieldConstants.kErrorOutlineBorder,
          focusedErrorBorder: AppTextFieldConstants.kErrorOutlineBorder,
        ),
      ),
    );
  }
}
