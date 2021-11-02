import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:newzly/catagory.dart';
import 'package:newzly/model.dart';
import 'package:newzly/newsview.dart';
// import 'package:carousel_slider/carousel_controller.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool visible = true;
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
 List<String> navBarItem = ["Top News", "India","Education","Sports","Finance","Stock Market", "health" ];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i=0;
    String url = "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=8a76312235e2411f9ff2f59fd257a724";
    Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
          // newsModelListCarousel.sublist(0,5);
        }
        catch(e){
          print(e);
        }
      }
    });
  }
  // setState(() {
  // data["articles"].forEach((element) {
  // NewsQueryModel newsQueryModel = new NewsQueryModel();
  // newsQueryModel = NewsQueryModel.fromMap(element);
  // newsModelList.add(newsQueryModel);
  // setState(() {
  // isLoading = false;
  // });
  //
  // });
  // });
  getNewsofIndia() async {
    Map element;
    int i=0;
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=8a76312235e2411f9ff2f59fd257a724";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
          // newsModelListCarousel.sublist(0,5);
        }
       catch(e){
        print(e);
      }
    }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("corona");
    getNewsofIndia();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ,
      // ),
      appBar: AppBar(
        leading: Icon(Icons.featured_play_list),
        title: Text('Newsly'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(query: searchController.text,)));
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(query: searchController.text,)));
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
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (context , index)
                  {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>Category(query: navBarItem[index])));
                        // print(navBarItem[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(navBarItem[index],
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ),
                    );
                  },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: isLoading ?Container(child: Center(child: CircularProgressIndicator()),height: 200,) :
              CarouselSlider(
                  items: newsModelList.map((item){
                    return Builder(builder: (BuildContext context){
                      try{
                      return InkWell(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(item.newsUrl) ));
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(vertical: 15),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(item.newsImg,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [Colors.black12.withOpacity(0),
                                          Colors.black,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(item.newsHead,style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      }
                      catch(e)
                      {
                        print(e);
                        return Container();
                      }
                        // InkWell(
                        //   onTap: (){
                        //     print("Agee to dekho ");
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 5,vertical: 14),
                        //     decoration: BoxDecoration(
                        //         color: item
                        //     ),
                        //   ),
                        // );
                    });
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    // enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                  ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Latest News",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,),),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                      itemCount: isLoading ? 12 : newsModelListCarousel.length,
                      itemBuilder: (context , index){
                      try{
                        return isLoading ?Container(child: Center(child: CircularProgressIndicator()),height: 200,) :
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(newsModelListCarousel[index].newsUrl) ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(newsModelListCarousel[index].newsImg,
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
                                            colors: [Colors.black12.withOpacity(0),
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
                                            Text(newsModelListCarousel[index].newsHead,
                                            style: TextStyle(
                                              color: Colors.white ,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            ),
                                            Text(newsModelListCarousel[index].newsDes.length>50 ? "${newsModelListCarousel[index].newsDes.substring(0,55)}..." : newsModelListCarousel[index].newsDes ,
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
                      }
                      catch(e)
                      {
                        print(e);
                        return Container();
                      }
                  }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed:(){  //TODO:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Category(query: "India")));
                        }, child: Text("SHOW MORE"),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // final List items = [];
}
