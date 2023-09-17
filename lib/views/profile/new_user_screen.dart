import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../exports.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  File? profileImage;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(
          'New User Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.kScaffoldColor),
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Responsive.screenHeight(context) * 0.02,
              horizontal: Responsive.screenWidth(context) * 0.04),
          child: Column(
            children: [
              Stack(
                children: [
                  profileImage == null
                      ? CircleAvatar(
                          radius: Responsive.screenWidth(context) * 0.18,
                          child: Image.network(
                              'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'))
                      : Container(
                          height: Responsive.screenWidth(context) * 0.36,
                          width: Responsive.screenWidth(context) * 0.36,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(profileImage!),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(
                                  Responsive.screenWidth(context) * 0.36)),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            profileImage = File(image.path);
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: Responsive.screenWidth(context) * 0.05,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.02),
              CustomizedTextField(
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(
                    r'^[a-zA-Z ]+$', // Allow alphabets and spaces
                    errorText: 'Only alphabets and spaces are allowed',
                  ),
                ]),
                name: 'name',
                hintText: 'Full Name',
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.015),
              const CustomizedTextField(
                name: 'about',
                hintText: 'About',
              ),
              SizedBox(height: Responsive.screenHeight(context) * 0.02),
              CustomizedButton(
                label: 'Save',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AuthState authState =
                        BlocProvider.of<AuthCubit>(context).state;
                    if (authState is Authenticated) {
                      final userCubit = BlocProvider.of<UserCubit>(context);
                      userCubit.addUserInfo(
                          AppUser(
                              userId: authState.user.uid,
                              userName:
                                  _formKey.currentState!.fields['name']!.value,
                              userEmail: authState.user.email!,
                              userAbout: _formKey
                                  .currentState!.fields['about']!.value),
                          profileImage);
                    }
                  }
                },
                backgroundColor: AppColors.kPrimaryColor,
                foregroundColor: AppColors.kScaffoldColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
