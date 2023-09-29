// dart
import 'dart:convert';

class NotificationItem {
  /// 通知ID
  final int nId;

  /// 追加情報
  final AdditionalData additionalData;
  NotificationItem(this.nId, this.additionalData);

  String toJson() {
    return jsonEncode({
      'nId': nId,
      'additionalData': additionalData
    });
  }

  static NotificationItem fromJson(String json) {
    final obj = jsonDecode(json);
    if (obj is Map<String, dynamic>) {
      if (obj['nId'] is int) {
        if (obj['additionalData'] is String) {
          return NotificationItem(obj['nId'], AdditionalData.fromJson(obj['additionalData']));
        }
      }
    }
    return NotificationItem(0, AdditionalData());
  }
}

class AdditionalData {
  String userUid;
  String documentId;
  AdditionalData({this.userUid = '', this.documentId = ''});

  String toJson() {
    final map = <String, dynamic>{};
    if (userUid.isNotEmpty) {
      map['userUid'] = userUid;
    }
    if (documentId.isNotEmpty) {
      map['documentId'] = documentId;
    }
    return jsonEncode(map);
  }

  static AdditionalData fromJson(String json) {
    final obj = jsonDecode(json);
    if (obj is Map<String, dynamic>) {
      return AdditionalData(
        userUid: obj['userUid'] is String ? obj['userUid'] : '',
        documentId: obj['documentId'] is String ? obj['documentId'] : ''
      );
    }
    return AdditionalData();
  }
}
