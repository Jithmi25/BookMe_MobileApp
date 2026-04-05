class UserRoles {
  const UserRoles._();

  static const String customer = 'customer';
  static const String provider = 'provider';

  static const List<String> all = [customer, provider];

  static bool isValid(String value) {
    return all.contains(value);
  }
}
