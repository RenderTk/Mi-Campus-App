// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CalendarEventCWProxy {
  CalendarEvent id(int? id);

  CalendarEvent uid(String uid);

  CalendarEvent summary(String summary);

  CalendarEvent description(String? description);

  CalendarEvent dtstamp(DateTime? dtstamp);

  CalendarEvent dtstart(DateTime dtstart);

  CalendarEvent dtend(DateTime dtend);

  CalendarEvent categories(String? categories);

  CalendarEvent classType(String? classType);

  CalendarEvent lastModified(DateTime? lastModified);

  CalendarEvent createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CalendarEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CalendarEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  CalendarEvent call({
    int? id,
    String uid,
    String summary,
    String? description,
    DateTime? dtstamp,
    DateTime dtstart,
    DateTime dtend,
    String? categories,
    String? classType,
    DateTime? lastModified,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCalendarEvent.copyWith(...)` or call `instanceOfCalendarEvent.copyWith.fieldName(value)` for a single field.
class _$CalendarEventCWProxyImpl implements _$CalendarEventCWProxy {
  const _$CalendarEventCWProxyImpl(this._value);

  final CalendarEvent _value;

  @override
  CalendarEvent id(int? id) => call(id: id);

  @override
  CalendarEvent uid(String uid) => call(uid: uid);

  @override
  CalendarEvent summary(String summary) => call(summary: summary);

  @override
  CalendarEvent description(String? description) =>
      call(description: description);

  @override
  CalendarEvent dtstamp(DateTime? dtstamp) => call(dtstamp: dtstamp);

  @override
  CalendarEvent dtstart(DateTime dtstart) => call(dtstart: dtstart);

  @override
  CalendarEvent dtend(DateTime dtend) => call(dtend: dtend);

  @override
  CalendarEvent categories(String? categories) => call(categories: categories);

  @override
  CalendarEvent classType(String? classType) => call(classType: classType);

  @override
  CalendarEvent lastModified(DateTime? lastModified) =>
      call(lastModified: lastModified);

  @override
  CalendarEvent createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CalendarEvent(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CalendarEvent(...).copyWith(id: 12, name: "My name")
  /// ```
  CalendarEvent call({
    Object? id = const $CopyWithPlaceholder(),
    Object? uid = const $CopyWithPlaceholder(),
    Object? summary = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? dtstamp = const $CopyWithPlaceholder(),
    Object? dtstart = const $CopyWithPlaceholder(),
    Object? dtend = const $CopyWithPlaceholder(),
    Object? categories = const $CopyWithPlaceholder(),
    Object? classType = const $CopyWithPlaceholder(),
    Object? lastModified = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return CalendarEvent(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      uid: uid == const $CopyWithPlaceholder() || uid == null
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String,
      summary: summary == const $CopyWithPlaceholder() || summary == null
          ? _value.summary
          // ignore: cast_nullable_to_non_nullable
          : summary as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      dtstamp: dtstamp == const $CopyWithPlaceholder()
          ? _value.dtstamp
          // ignore: cast_nullable_to_non_nullable
          : dtstamp as DateTime?,
      dtstart: dtstart == const $CopyWithPlaceholder() || dtstart == null
          ? _value.dtstart
          // ignore: cast_nullable_to_non_nullable
          : dtstart as DateTime,
      dtend: dtend == const $CopyWithPlaceholder() || dtend == null
          ? _value.dtend
          // ignore: cast_nullable_to_non_nullable
          : dtend as DateTime,
      categories: categories == const $CopyWithPlaceholder()
          ? _value.categories
          // ignore: cast_nullable_to_non_nullable
          : categories as String?,
      classType: classType == const $CopyWithPlaceholder()
          ? _value.classType
          // ignore: cast_nullable_to_non_nullable
          : classType as String?,
      lastModified: lastModified == const $CopyWithPlaceholder()
          ? _value.lastModified
          // ignore: cast_nullable_to_non_nullable
          : lastModified as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $CalendarEventCopyWith on CalendarEvent {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCalendarEvent.copyWith(...)` or `instanceOfCalendarEvent.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CalendarEventCWProxy get copyWith => _$CalendarEventCWProxyImpl(this);
}
