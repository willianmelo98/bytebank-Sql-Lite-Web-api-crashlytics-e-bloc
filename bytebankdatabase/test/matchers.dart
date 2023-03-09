import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:flutter/material.dart';

bool buscaMatcherFeature(Widget widget, String name, IconData icon) {
  if (widget is FeatureItem) {
    return widget.name == name && widget.icon == icon;
  }
  return false;
}

bool textFieldByLabelTextMatcher(Widget widget, String text) {
  if (widget is TextField) {
    return widget.decoration!.labelText == text;
  }
  return false;
}
