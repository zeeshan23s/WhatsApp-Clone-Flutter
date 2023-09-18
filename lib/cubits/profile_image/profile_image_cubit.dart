import 'dart:io';

import '../../exports.dart';

part 'profile_image_state.dart';

class ProfileImageCubit extends Cubit<ProfileImageState> {
  static final _userCollection = FirebaseFirestore.instance.collection('Users');
  static final _storage = FirebaseStorage.instance;

  ProfileImageCubit() : super(ImageInitial());

  void setProfileImage(String? image) {
    emit(ImageLoaded(image));
  }

  Future<void> updateImageURL(AppUser user, File? profileImage) async {
    emit(ImageLoading());
    try {
      String? imageRef;
      if (profileImage != null) {
        imageRef = await _uploadImage(profileImage, user.userId);
      }
      await _userCollection
          .doc(user.userId)
          .update({'profileImageURL': imageRef});
      emit(ImageLoaded(imageRef));
    } on FirebaseException catch (e) {
      emit(ImageError(e.message ?? 'Unable to update image!'));
    } catch (e) {
      emit(ImageError(e.toString()));
    }
  }

  Future<String> _uploadImage(File file, String name) async {
    final ref = _storage.ref("images/$name");
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
