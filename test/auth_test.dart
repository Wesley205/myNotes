import 'package:nova/services/auth/auth_exceptions.dart';
import 'package:nova/services/auth/auth_provider.dart';
import 'package:nova/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized at the beginning', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot logout if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 secs',
      () async {
        await provider.initialize();
        expect(provider._isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create user should delegate to login function', () async {
      await provider.initialize();

      //Test invalid email
      final badEmailUser = provider.createUser(
        email: 'john@doe.com',
        password: 'anypassword',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
          
      //Test invalid password
      final badPasswordUser =
          provider.createUser(email: "someone@doe.com", password: "john");
        expect(badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()));


      //Test Valid user creation
      final user = await provider.createUser(email: 'wesley.com', password: 'tonwe');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () async {
  
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'passowrd');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'john@doe.com') throw UserNotFoundAuthException();
    if (password == 'john') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: '');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

 @override
Future<void> sendEmailVerification() async {
  if (!isInitialized) throw NotInitializedException(); // Ensure provider is initialized
  final user = _user; // Access the current user
  if (user == null) throw UserNotFoundAuthException(); // Ensure user exists

  // Update the user with verified email
  _user = AuthUser(isEmailVerified: true, email: 'someone@doe.com',);
}
}
