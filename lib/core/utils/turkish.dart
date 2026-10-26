/// Turkish case suffixes for names, following vowel harmony:
/// "Ayşe" → "Ayşe'ye", "Burak" → "Burak'a", "Cem" → "Cem'e", "Ali" → "Ali'ye".
abstract final class Turkish {
  static const _back = 'aıouAIOU';
  static const _front = 'eiöüEİÖÜ';

  static String dative(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return trimmed;
    String? lastVowel;
    for (var i = trimmed.length - 1; i >= 0; i--) {
      final c = trimmed[i];
      if (_back.contains(c) || _front.contains(c)) {
        lastVowel = c;
        break;
      }
    }
    final suffixVowel = lastVowel != null && _back.contains(lastVowel) ? 'a' : 'e';
    final last = trimmed[trimmed.length - 1];
    final endsWithVowel = _back.contains(last) || _front.contains(last);
    return "$trimmed'${endsWithVowel ? 'y' : ''}$suffixVowel";
  }
}
