abstract class UploadFotoState {}

class UploadFotoIdle extends UploadFotoState {}

class UploadFotoLoading extends UploadFotoState {}

class UploadFotoSuccess extends UploadFotoState {}

class UploadFotoFailure extends UploadFotoState {
  final String message;
  UploadFotoFailure(this.message);
}