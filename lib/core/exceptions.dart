class FailedException implements Exception {
  final String message;
  FailedException(this.message);

  @override
  String toString()=> "FailedException: $message";
}

class RepoException implements Exception {
  final String message;

  RepoException(this.message);

  @override
  String toString() => "RepoException: $message";
}