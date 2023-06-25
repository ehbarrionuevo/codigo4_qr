import 'package:codigo4_qr/models/qr_model.dart';

class Data {
  static final Data _instance = Data._();
  Data._();
  factory Data() {
    return _instance;
  }

  List<QrModel> _qrList = [];

  int getQrListLength() => _qrList.length;

  void addQr(QrModel model) {
    _qrList.add(model);
  }

  QrModel getValue(int index) {
    return _qrList[index];
  }
}
