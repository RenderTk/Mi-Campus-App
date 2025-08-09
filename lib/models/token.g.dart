// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TokenCWProxy {
  Token token(String? token);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Token(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Token(...).copyWith(id: 12, name: "My name")
  /// ```
  Token call({String? token});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfToken.copyWith(...)` or call `instanceOfToken.copyWith.fieldName(value)` for a single field.
class _$TokenCWProxyImpl implements _$TokenCWProxy {
  const _$TokenCWProxyImpl(this._value);

  final Token _value;

  @override
  Token token(String? token) => call(token: token);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `Token(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// Token(...).copyWith(id: 12, name: "My name")
  /// ```
  Token call({Object? token = const $CopyWithPlaceholder()}) {
    return Token(
      token: token == const $CopyWithPlaceholder()
          ? _value.token
          // ignore: cast_nullable_to_non_nullable
          : token as String?,
    );
  }
}

extension $TokenCopyWith on Token {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfToken.copyWith(...)` or `instanceOfToken.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TokenCWProxy get copyWith => _$TokenCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) =>
    Token(token: json['token'] as String?);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'token': instance.token,
};
