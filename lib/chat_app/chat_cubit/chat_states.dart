abstract class ChatStates{}

class ChatInitialState extends ChatStates{}

class ChatGetUserDataLoadingState extends ChatStates{}

class ChatGetUserDataSuccessState extends ChatStates{}

class ChatGetUserDataErrorState extends ChatStates{}

class ChatGetAllUsersSuccessState extends ChatStates{}

class ChatGetAllUsersErrorState extends ChatStates{}

class ChatMessageSentSuccessState extends ChatStates{}

class ChatMessageSentErrorState extends ChatStates{}

class ChatGetMessageSuccessState extends ChatStates{}

class ChatImageGetSuccessfullyState extends ChatStates{}

class ChatImageGetErrorState extends ChatStates{}

class UploadImageSuccessState extends ChatStates{}

class UploadImageErrorState extends ChatStates{}

class UploadImageLoadingState extends ChatStates{}