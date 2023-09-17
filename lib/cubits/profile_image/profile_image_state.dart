part of 'profile_image_cubit.dart';

abstract class ProfileImageState {}

class ImageInitial extends ProfileImageState {}

class ImageLoading extends ProfileImageState {}

class ImageLoaded extends ProfileImageState {
  final String? profileImage;
  ImageLoaded(this.profileImage);
}

class ImageError extends ProfileImageState {
  final String error;
  ImageError(this.error);
}
