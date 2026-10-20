import 'package:intl/intl.dart';

// formata as datas no padrao brasileiro
class AppDateUtils {
  const AppDateUtils._();

  static String formatDate(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return DateFormat('dd/MM/yyyy').format(value.toLocal());
  }

  static String formatDateTime(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(
      value.toLocal(),
    );
  }
}
