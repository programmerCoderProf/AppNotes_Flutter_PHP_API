import 'package:app2/constant/message.dart';

validInput(String value, int min, int max) {
  if (value.length > max) return MessageInputMax + " " + "${max}";
  if (value.isEmpty) return MessageInputEmpty;
  if (value.length < min) return MessageInputMin + " " + "${min}";
}
