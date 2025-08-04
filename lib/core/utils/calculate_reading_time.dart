int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  // speed = distance (word count) / time (word per minute);

  final readingTime = wordCount / 225;

  return readingTime.ceil();
}
