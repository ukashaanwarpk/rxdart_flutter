import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';

@immutable
abstract class AuthStatus {
  const AuthStatus();
}

@immutable
class AuthStatusLoggedOut implements AuthStatus {
  const AuthStatusLoggedOut();
}

@immutable
class AuthCommand {
  final String email;
  final String password;

  const AuthCommand({required this.email, required this.password});
}

@immutable
class LoginCommand extends AuthCommand {
  const LoginCommand({required super.email, required super.password});
}

extension Loading<E> on Stream<E> {
  Stream<E> setLoading(bool isLoading, {required Sink<bool> onSink}) =>
      doOnEach((_) => onSink.add(isLoading));
}
