import 'dart:io';

import 'package:chat_app/cubits/profile_image/profile_image_cubit.dart';
import 'package:chat_app/exports.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTab extends StatelessWidget {
  final AppUser appUser;
  const ProfileTab({super.key, required this.appUser});

  @override
  Widget build(BuildContext context) {
    AuthState authState = BlocProvider.of<AuthCubit>(context).state;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.screenHeight(context) * 0.02,
        horizontal: Responsive.screenWidth(context) * 0.04,
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(appUser.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot user = snapshot.data!;
            return Column(
              children: [
                Stack(
                  children: [
                    BlocConsumer<ProfileImageCubit, ProfileImageState>(
                        listener: (context, state) {
                      if (state is ImageInitial) {
                        final profileImageCubit =
                            BlocProvider.of<ProfileImageCubit>(context);
                        profileImageCubit
                            .setProfileImage(appUser.profileImageURL);
                      }
                    }, builder: (context, state) {
                      if (state is ImageLoading) {
                        return Container(
                          height: Responsive.screenWidth(context) * 0.36,
                          width: Responsive.screenWidth(context) * 0.36,
                          decoration: BoxDecoration(
                            color: AppColors.kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                Responsive.screenWidth(context) * 0.36),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        );
                      } else {
                        return user['profileImageURL'] == null
                            ? CircleAvatar(
                                radius: Responsive.screenWidth(context) * 0.18,
                                child: Image.network(
                                    'https://icons.iconarchive.com/icons/papirus-team/papirus-status/512/avatar-default-icon.png'),
                              )
                            : Container(
                                height: Responsive.screenWidth(context) * 0.36,
                                width: Responsive.screenWidth(context) * 0.36,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(user['profileImageURL']),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(
                                      Responsive.screenWidth(context) * 0.36),
                                ),
                              );
                      }
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          File? profileImage;
                          final ImagePicker picker = ImagePicker();
                          await picker
                              .pickImage(source: ImageSource.gallery)
                              .then((value) {
                            if (value != null) {
                              profileImage = File(value.path);
                            }
                            final profileImageCubit =
                                BlocProvider.of<ProfileImageCubit>(context);
                            profileImageCubit.updateImageURL(
                                appUser, profileImage);
                          });
                        },
                        child: CircleAvatar(
                          radius: Responsive.screenWidth(context) * 0.05,
                          child: const Icon(Icons.camera_alt),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.025),
                profileField(
                  context: context,
                  prefixIcon: const Icon(Icons.person_outline),
                  fieldName: 'Name',
                  fieldValue: user['userName'],
                  tailingWidget: IconButton(
                    onPressed: () => CustomizedModelSheets.bottomSheet(
                      context: context,
                      child: _editProfileFields(
                          context: context,
                          title: 'Enter your name',
                          field: CustomizedTextField(
                            initialValue: user['userName'],
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.match(
                                r'^[a-zA-Z ]+$', // Allow alphabets and spaces
                                errorText:
                                    'Only alphabets and spaces are allowed',
                              ),
                            ]),
                            name: 'name',
                            hintText: 'Full Name',
                            textInputAction: TextInputAction.done,
                          ),
                          updateFieldName: 'name'),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.015),
                profileField(
                  context: context,
                  prefixIcon: const Icon(Icons.info_outline),
                  fieldName: 'About',
                  fieldValue: user['userAbout'],
                  tailingWidget: IconButton(
                    onPressed: () => CustomizedModelSheets.bottomSheet(
                      context: context,
                      child: _editProfileFields(
                          context: context,
                          title: 'Tell us about yourself',
                          field: CustomizedTextField(
                            initialValue: user['userAbout'],
                            name: 'about',
                            hintText: 'About',
                            textInputAction: TextInputAction.done,
                          ),
                          updateFieldName: 'about'),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                ),
                SizedBox(height: Responsive.screenHeight(context) * 0.015),
                authState is Authenticated
                    ? profileField(
                        context: context,
                        prefixIcon: const Icon(Icons.email_outlined),
                        fieldName: 'Email',
                        fieldValue: authState.user.email!,
                      )
                    : const SizedBox()
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
            );
          }
        },
      ),
    );
  }

  Widget profileField(
      {required BuildContext context,
      required Icon prefixIcon,
      required String fieldName,
      required String fieldValue,
      Widget? tailingWidget}) {
    return Column(
      children: [
        Row(
          children: [
            prefixIcon,
            SizedBox(width: Responsive.screenWidth(context) * 0.025),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Responsive.screenHeight(context) * 0.005),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fieldName,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: Responsive.screenHeight(context) * 0.005),
                    Text(
                      fieldValue,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            tailingWidget ?? const SizedBox()
          ],
        ),
        Divider(color: Colors.grey[200])
      ],
    );
  }

  Widget _editProfileFields(
      {required BuildContext context,
      required String title,
      required Widget field,
      required String updateFieldName}) {
    final formKey = GlobalKey<FormBuilderState>();
    return FormBuilder(
      key: formKey,
      child: SizedBox(
        height: Responsive.screenHeight(context) * 0.65,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Responsive.screenHeight(context) * 0.04,
                  horizontal: Responsive.screenWidth(context) * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: Responsive.screenHeight(context) * 0.02),
                  field,
                  SizedBox(height: Responsive.screenHeight(context) * 0.01),
                  CustomizedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final userCubit = BlocProvider.of<UserCubit>(context);
                        if (updateFieldName == 'name') {
                          userCubit.updateName(appUser.userId,
                              formKey.currentState!.fields['name']!.value);
                        } else {
                          userCubit.updateAbout(appUser.userId,
                              formKey.currentState!.fields['about']!.value);
                        }
                        Navigator.pop(context);
                      }
                    },
                    label: 'Save',
                    backgroundColor: AppColors.kPrimaryColor,
                    foregroundColor: AppColors.kScaffoldColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
