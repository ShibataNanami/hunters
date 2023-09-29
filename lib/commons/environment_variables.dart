class EnvironmentVariables{
  static const isEmulator = bool.fromEnvironment('IS_EMULATOR', defaultValue: false);
  static const isDebug = bool.fromEnvironment('IS_DEBUG', defaultValue: false);
  static const userEmail = String.fromEnvironment('USER_EMAIL', defaultValue: '');
  static const userPass = String.fromEnvironment('USER_PASS', defaultValue: '');
  static const doSignout = bool.fromEnvironment('DO_SIGNOUT', defaultValue: false);
}