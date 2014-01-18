/**
 * DO NOT EDIT. This is code generated via pkg/intl/generate_localized.dart
 * This is a library that provides messages for a en locale. All the
 * messages from the main program should be duplicated here with the same
 * function name.
 */

library messages_en;
import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

class MessageLookup extends MessageLookupByLibrary {

  get localeName => 'en';
  static beer_count_message(count) => "${Intl.plural(count, zero: 'no beers', one: '$count beer', few: '$count beers', other: '$count beers')}";

  static currency_format() => "\$#,##0.00";

  static number_format() => "#,##0.###";


  final messages = const {
    "beer_count_message" : beer_count_message,
    "currency_format" : currency_format,
    "number_format" : number_format
  };
}