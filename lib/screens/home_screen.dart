import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_app/models/recipe_model.dart';
import 'package:food_app/provider/recipe_provider.dart';
import 'package:food_app/screens/recipe_screen.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textController = TextEditingController();
  // String query = "";

  // String applicationId = "c4852d41";
  // String applicationKey = "015d13d3e7c367e4cd1739f71f279c65";

  // List<RecipeModel> recipeList = [];

  // Future<List<RecipeModel>> getRecipe(String query) async {
  //   String url =
  //       "https://api.edamam.com/search?q=$query&app_id=c4852d41&app_key=015d13d3e7c367e4cd1739f71f279c65";
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> data = jsonDecode(response.body.toString());

  //     data["hits"].forEach((element) {
  //       RecipeModel recipeModel = RecipeModel();
  //       recipeModel = RecipeModel.fromMap(element["recipe"]);
  //       recipeList.add(recipeModel);
  //     });
  //     setState(() {});
  //     print(recipeList);
  //     return recipeList;
  //   } else {
  //     throw Exception('Failed to load the Data');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff213A50),
                  Color(0xff071930),
                ],
                begin: FractionalOffset.topRight,
                end: FractionalOffset.bottomLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: kIsWeb
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        'FoodRecipe ',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      Text(
                        'App',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Text(
                    'What would you like to cook today?',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Just Enter Ingredients you have and we will show the best recipe for you',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Ingridients",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Consumer<RecipeProvider>(builder: (context, val, child) {
                        return InkWell(
                          onTap: () {
                            if (textController.text
                                .toString()
                                .trim()
                                .isNotEmpty) {
                              val.getRecipes(textController.text.toString());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please Enter the valid input'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffA2834D),
                                  Color(0xffBC9A5F),
                                ],
                                begin: FractionalOffset.topRight,
                                end: FractionalOffset.bottomLeft,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Consumer<RecipeProvider>(builder: (context, val, child) {
                    return GridView(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      children: List.generate(val.recipeList.length, (index) {
                        return RecipeTile(
                            title: val.recipeList[index].label!,
                            desc: val.recipeList[index].source!,
                            imgUrl: val.recipeList[index].image!,
                            url: val.recipeList[index].url!);
                      }),
                    );
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  String title;
  String desc;
  String imgUrl;
  String url;

  RecipeTile(
      {super.key,
      required this.title,
      required this.desc,
      required this.imgUrl,
      required this.url});

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              print(widget.url);
              _launchURL(widget.url);
            } else {
              print(widget.url + "this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeScreen(openUrl: widget.url),
                  ));
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white30, Colors.white],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.bottomLeft,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          widget.desc,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
