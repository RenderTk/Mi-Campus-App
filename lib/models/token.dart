import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token.g.dart';

@CopyWith()
@JsonSerializable()
class Token {
  String? token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

  /// Decode the token payload
  Map<String, dynamic>? decode() {
    if (token == null || JwtDecoder.isExpired(token!)) return null;
    return JwtDecoder.decode(token!);
  }

  /// Check if the token is expired
  bool get isExpired {
    if (token == null) return true;
    return JwtDecoder.isExpired(token!);
  }

  /// Get the expiration date of the token
  DateTime? get expirationDate {
    if (token == null) return null;
    return JwtDecoder.getExpirationDate(token!);
  }
}
