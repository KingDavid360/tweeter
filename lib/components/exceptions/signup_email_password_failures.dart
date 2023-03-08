class SignupWithEmailAndPasswordFailures {
  final String message;

  const SignupWithEmailAndPasswordFailures(
      [this.message = "An unknown error occurred."]);

  factory SignupWithEmailAndPasswordFailures.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupWithEmailAndPasswordFailures(
            'Please enter a strong password.');
      case 'invalid-email':
        return const SignupWithEmailAndPasswordFailures(
            'Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignupWithEmailAndPasswordFailures(
            'Account has already been created for this email.');
      case 'operation-not-allowed':
        return const SignupWithEmailAndPasswordFailures(
            'Operation is not allowed, please contact support.');
      case 'user-disabled':
        return const SignupWithEmailAndPasswordFailures(
            'This user has been disabled, please contact support for help.');
      default:
        return const SignupWithEmailAndPasswordFailures();
    }
  }
}
