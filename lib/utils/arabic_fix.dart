class ArabicFixer {
  static String fix(String text) {
    return text
        .split('\n')
        .map((line) {
          return line
              .split(' ')
              .map((word) => word.split('').reversed.join())
              .join(' ');
        })
        .join('\n');
  }
}
