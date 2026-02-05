import '../../config/app_config.dart';
import 'chat_repository.dart';
import 'local_chat_repository.dart';
import 'remote_chat_repository.dart';

class ChatRepositoryFactory {
  const ChatRepositoryFactory._();

  static ChatRepository create() {
    if (AppConfig.useRemoteChat) {
      return RemoteChatRepository();
    }
    return LocalChatRepository();
  }
}
