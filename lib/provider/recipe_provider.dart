import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_app/models/recipe_model.dart';
import 'package:http/http.dart' as http;

class RecipeProvider with ChangeNotifier {
  String query = "";
  bool _loading = false;
  bool get loading => _loading;

  List<RecipeModel> _recipeList = [];

  List<RecipeModel> get recipeList => _recipeList;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<RecipeModel>> getRecipes(String query) async {
    setLoading(true);
    String url =
        "https://api.edamam.com/search?q=$query&app_id=c4852d41&app_key=015d13d3e7c367e4cd1739f71f279c65";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setLoading(false);
      Map<String, dynamic> data = jsonDecode(response.body.toString());

      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
      });
      notifyListeners();
      print(recipeList);
      return recipeList;
    } else {
      throw Exception('Failed to load the Data');
    }
  }
}
