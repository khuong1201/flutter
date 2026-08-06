class AppValidator {
  AppValidator._();

  static String? required(
    String? value, {
    required String message,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  static String? email(
    String? value, {
    required String emptyMessage,
    required String invalidMessage,
  }) {
    final error = required(
      value,
      message: emptyMessage,
    );

    if (error != null) {
      return error;
    }

    final emailRegex = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return invalidMessage;
    }

    return null;
  }

  static String? password(
    String? value, {
    required String emptyMessage,
    required String invalidMessage,
    int minLength = 6,
  }) {
    final error = required(
      value,
      message: emptyMessage,
    );

    if (error != null) {
      return error;
    }

    if (value!.length < minLength) {
      return invalidMessage;
    }

    return null;
  }

  static String? confirmPassword(
    String? value, {
    required String password,
    required String emptyMessage,
    required String mismatchMessage,
  }) {
    final error = required(
      value,
      message: emptyMessage,
    );

    if (error != null) {
      return error;
    }

    if (value != password) {
      return mismatchMessage;
    }

    return null;
  }

  static String? fullName(
    String? value, {
    required String emptyMessage,
    required String invalidMessage,
  }) {
    final error = required(
      value,
      message: emptyMessage,
    );

    if (error != null) {
      return error;
    }

    if (value!.trim().length < 2) {
      return invalidMessage;
    }

    return null;
  }
}