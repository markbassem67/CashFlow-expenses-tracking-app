extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


extension NameCapitalizer on String {
  String capitalizeName() {
    if (trim().isEmpty) return this;

    // Split into words (handles middle names too)
    final parts = trim().split(' ');

    return parts
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
