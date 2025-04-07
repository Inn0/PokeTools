String capitalizeFirst(String text) {
  if (text.isEmpty) return text;
  if (text[0] == text[0].toUpperCase()) return text;
  return text[0].toUpperCase() + text.substring(1);
}