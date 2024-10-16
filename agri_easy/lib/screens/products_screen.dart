import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:agri_easy/model/products_data_model.dart';
import 'package:agri_easy/providers/language_provider.dart';
import 'package:agri_easy/l10n/app_localizations.dart'; // Import AppLocalizations

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final appLocalizations = AppLocalizations.of(context);

        // Determine the app bar title based on the current locale
        String appBarTitle = appLocalizations.productsTitle;

        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              height: 150, // Set the height of the AppBar
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Color.fromARGB(255, 0, 100, 3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  height: 150,
                  alignment: Alignment.bottomLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent background
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Text(
                    appBarTitle,
                    style: const TextStyle(
                      fontFamily: "Lobster",
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Color.fromARGB(255, 0, 0, 0), // Text color
                    ),
                  ),
                ),
              ),
            ),
            elevation: 0,
            titleSpacing: 0,
          ),
          body: FutureBuilder<List<ProductDataModel>>(
            future: readJsonData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (snapshot.hasData) {
                var items = snapshot.data!;

                return Center(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          color: const Color.fromARGB(255, 219, 245, 219),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.getLocalizedField(
                                            product.name, context),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 1, 67, 10),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        product.getLocalizedField(
                                            product.type, context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: _getCategoryColor(
                                              context, product.category),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Text(
                                          product.getLocalizedField(
                                              product.category, context),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        product.getLocalizedField(
                                            product.desc, context),
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 69, 69, 69),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 70,
                                  left: 10,
                                  right: 10,
                                ),
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.imageURL ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }

  Color _getCategoryColor(
      BuildContext context, Map<String, String>? categoryMap) {
    final appLocalizations = AppLocalizations.of(context);

    // Retrieve the current locale's category value
    final langCode = Provider.of<LanguageProvider>(context, listen: false)
        .locale
        .languageCode;
    final category = categoryMap?[langCode] ?? '';

    if (category == appLocalizations.fertilizerCategory) {
      return Colors.green;
    } else if (category == appLocalizations.pesticideCategory) {
      return Colors.red;
    } else {
      return Colors.grey; // Default color if no match
    }
  }
}

Future<List<ProductDataModel>> readJsonData() async {
  final jsondata = await rootBundle.loadString('jsonfile/productlist.json');
  final list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => ProductDataModel.fromJson(e)).toList();
}
