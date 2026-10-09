/// Pure, UI-independent form validators (easy to unit test).
class Validators {
  Validators._();

  static String? name(String? input) {
    final value = input?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your full name';
    if (value.length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r"^[A-Za-z][A-Za-z .'-]*$").hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  /// Indian mobile number: 10 digits starting with 6-9.
  static String? phone(String? input) {
    final value = (input ?? '').replaceAll(RegExp(r'\s+'), '');
    if (value.isEmpty) return 'Please enter your phone number';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? address(String? input) {
    final value = input?.trim() ?? '';
    if (value.isEmpty) return 'Please enter your service address';
    if (value.length < 10) {
      return 'Add house no., street and a landmark (min 10 characters)';
    }
    return null;
  }
}
