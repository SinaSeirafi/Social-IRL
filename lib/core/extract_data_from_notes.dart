List<String> extractDataFromNotes(String? notes, String pattern) {
  if (notes == null) return [];

  List<String> textSplitted = notes.split(" ");

  List<String> wordsThatStartWithPattern = [];

  for (var item in textSplitted) {
    if (item.startsWith(pattern)) {
      wordsThatStartWithPattern.add(item.substring(1));
    }
  }

  return wordsThatStartWithPattern;
}
