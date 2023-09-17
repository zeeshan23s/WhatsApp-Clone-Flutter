import 'dart:io';
import '../../exports.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  static final _userCollection = FirebaseFirestore.instance.collection('Users');
  static final _storage = FirebaseStorage.instance;

  UserCubit() : super(UserInitial());

  Future<void> checkUserInfo(String uid) async {
    emit(UserLoading());
    final appUser = await _userCollection.doc(uid).get();
    if (appUser.data() != null) {
      final userInfo = AppUser(
          userId: uid,
          userName: appUser['userName'],
          userEmail: appUser['userEmail'],
          userAbout: appUser['userAbout']);
      emit(UserLoaded(userInfo));
    } else {
      emit(UserLoaded(null));
    }
  }

  Future<void> addUserInfo(AppUser user, File? profileImage) async {
    emit(UserLoading());

    try {
      String? imageRef;
      if (profileImage != null) {
        imageRef = await _uploadImage(profileImage, user.userId);
      }
      AppUser userInfo = AppUser(
          userId: user.userId,
          userName: user.userName,
          profileImageURL: imageRef,
          userEmail: user.userEmail,
          userAbout: user.userAbout);
      await _userCollection.doc(user.userId).set(userInfo.toMap());
      emit(UserLoaded(userInfo));
    } on FirebaseException catch (e) {
      emit(UserError(e.message ?? 'Unable to Register User!'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<String> _uploadImage(File file, String name) async {
    final ref = _storage.ref("images/$name");
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateName(String uid, String name) async {
    try {
      _userCollection.doc(uid).update({'userName': name});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateAbout(String uid, String about) async {
    try {
      _userCollection.doc(uid).update({'userAbout': about});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
