import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:newzly/model.dart';
import 'package:newzly/newsview.dart';

class Category extends StatefulWidget {
  final String query;
  Category({required this.query});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url="";
    if(widget.query == "India")
      {
        url ="https://newsapi.org/v2/top-headlines?country=in&apiKey=8a76312235e2411f9ff2f59fd257a724";
      }
    else{
      url = "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=8a76312235e2411f9ff2f59fd257a724";
    }
    Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try {
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          // newsModelListCarousel.sublist(0,5);
        }
        catch(e){
          print(e);
        }
      }
      );
    }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newzly'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.black12, borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Category(query: searchController.text,)));
                        }
                      },
                      child: Container(
                        child: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if(value == "")
                          {
                            print("Blank Statement");
                          }
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Category(query: searchController.text,)));
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Your News Here"
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                      widget.query,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 39,
                      ),
                    )),
                  ],
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isLoading ?12 : newsModelListCarousel.length,
                  itemBuilder: (context, index) {
                    return isLoading ? Container(child: Center(child: CircularProgressIndicator()),height: 200,) :
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(newsModelListCarousel[index].newsUrl) ));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  newsModelListCarousel[index].newsImg,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black12.withOpacity(0),
                                        Colors.black,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        newsModelListCarousel[index].newsHead,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        newsModelListCarousel[index]
                                                    .newsDes
                                                    .length >
                                                50
                                            ? "${newsModelListCarousel[index].newsDes.substring(0, 10)}..."
                                            : newsModelListCarousel[index]
                                                .newsDes,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              // Container(
              //   padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton(onPressed:(){}, child: Text("SHOW MORE"),),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
