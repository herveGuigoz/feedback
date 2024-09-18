part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class CommentRequestedEvent extends AppEvent {
  const CommentRequestedEvent();
}

class ViewRequestedEvent extends AppEvent {
  const ViewRequestedEvent();
}

class BrowseRequestedEvent extends AppEvent {
  const BrowseRequestedEvent();
}
