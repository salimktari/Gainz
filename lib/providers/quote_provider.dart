import 'package:gainz/services/service_quote.dart';

class QuoteProvider {
  final ServiceQuote service = ServiceQuote();
  String? quote;

  Future<void> loadQuote() async {
    final String q = await service.quote();
    quote = q;
  }
}
