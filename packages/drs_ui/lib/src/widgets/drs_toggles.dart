import 'package:flutter/material.dart';

/// A labelled on/off row. Unlike `SwitchListTile`, the screen reader gets a
/// single focus stop ("Notifications, On for this device, switch, on")
/// instead of the row plus an unnamed switch, and the whole row is the tap
/// target.
class DrsSwitchTile extends StatelessWidget {
  const DrsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.secondary,
    this.contentPadding,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool value;

  /// null = disabled.
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    child: ListTile(
      contentPadding: contentPadding,
      leading: secondary,
      title: title,
      subtitle: subtitle,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: ExcludeSemantics(
        child: Switch.adaptive(value: value, onChanged: onChanged),
      ),
    ),
  );
}

/// A labelled checkbox row with a single screen-reader focus stop
/// ("Cow Milk, 1 L, checkbox, checked").
class DrsCheckTile extends StatelessWidget {
  const DrsCheckTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
    this.contentPadding,
  });

  final Widget title;
  final Widget? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) => Semantics(
    checked: value,
    child: ListTile(
      contentPadding: contentPadding,
      title: title,
      subtitle: subtitle,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      trailing: ExcludeSemantics(
        child: Checkbox.adaptive(
          value: value,
          onChanged: onChanged == null ? null : (v) => onChanged!(v ?? false),
        ),
      ),
    ),
  );
}
