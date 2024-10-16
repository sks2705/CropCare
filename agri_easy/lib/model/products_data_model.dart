import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_easy/providers/language_provider.dart';

class ProductDataModel {
  int? id;
  Map<String, String>? name; // Localized names
  Map<String, String>? category; // Localized categories
  String? imageURL;
  Map<String, String>? type; // Localized types
  Map<String, String>? desc; // Localized descriptions

  ProductDataModel({
    this.id,
    this.name,
    this.category,
    this.imageURL,
    this.type,
    this.desc,
  });

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = Map<String, String>.from(json['name']);
    category = Map<String, String>.from(json['category']);
    imageURL = json['imageUrl'];
    type = Map<String, String>.from(json['type']);
    desc = Map<String, String>.from(json['desc']);
  }

  String getLocalizedType(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    String langCode = languageProvider.locale.languageCode;
    return type?[langCode] ?? type?['en'] ?? 'Unknown';
  }

  String getLocalizedCategory(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    String langCode = languageProvider.locale.languageCode;
    return category?[langCode] ?? category?['en'] ?? 'Unknown';
  }

  String getLocalizedField(Map<String, String>? map, BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    String langCode = languageProvider.locale.languageCode;

    return map?[langCode] ?? map?['en'] ?? '';
  }
}
