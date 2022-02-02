

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/categroy.dart';
import 'package:news_app/model.dart';
import 'package:http/http.dart';
import 'package:news_app/NewsView.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:news_app/next_page.dart';
// import 'package:news_app/next_page.dart';




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "TOP NEWS",
    "SPORTS",
    "POLITICS",
    "ENTERTAINMENT",
    "BUSINESS",
    "TECHNOLOGY",
    
  ];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=2022-01-07&sortBy=&apiKey=8c6ba25d516f4825b960c74b20be457d";
    Response response = await get(Uri.parse(url));
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
        } catch (e) {
          print(e);
        }
      }
    });
  }

  getNewsbyprovider(String provider) async {
    String url =
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=8c6ba25d516f4825b960c74b20be457d";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("corona");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("News App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Category(
                                      Query: searchController.text,
                                    )));
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
                        if(value == ""){
                          print("object");
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Category(
                                      Query: value,
                                    )));
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search"),
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
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category(
                                    Query: navBarItem[index],
                                  )));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          navBarItem[index],
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
                // margin: EdgeInsets.symmetric(vertical: 5),
                child: isLoading
                    ? Container(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()))
                    : CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          autoPlay: true,
                          // enableInfiniteScroll: true,
                          enlargeCenterPage: true,
                        ),
                        items: newsModelList.map((instance) {
                          return Builder(builder: (BuildContext context) {
                            try {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 15),
                                
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Newsview(instance.newsUrl)) );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              instance.newsImg,
                                              fit: BoxFit.fitHeight,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.grey.withOpacity(0),
                                                    Colors.grey,
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 14),
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    instance.newsHead,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              );
                              
                            } catch (e) {
                              print(e);
                              return Container();
                            }
                          });
                        }).toList(),
                      )),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "LATEST NEWS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Container(
                          height: MediaQuery.of(context).size.height - 450,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: newsModelList.length,
                          itemBuilder: (context, index) {
                            try{
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                             
                                child: InkWell(
                                  onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=> Newsview(newsModelList[index].newsUrl)) );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)),
                                    elevation: 1.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            newsModelList[index].newsImg,
                                            fit: BoxFit.fitWidth,
                                            width: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 18,
                                              vertical: 18,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsModelList[index].newsHead,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  newsModelList[index]
                                                              .newsDes
                                                              .length >
                                                          50
                                                      ? "${newsModelList[index].newsDes.substring(0, 50)}..."
                                                      : newsModelList[index]
                                                          .newsDes,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              
                            );

                  
                            
                            }catch(e){print(e); return Container();}
                          }),
               Container(
                 child: Center(
                   child: ElevatedButton(  
                     style: ElevatedButton.styleFrom(
                       padding: EdgeInsets.all(10),
                       shadowColor: Colors.black,
                     ),
                     child: Text('Next',style: TextStyle(fontWeight: FontWeight.bold),),
                     
                     onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Category(Query: '',)));
                     },
                   ),
                 ),
               )
                ],
              ),
            ),

           
           
          ],
        ),
      ),
    );
  }

}

next_page() {
}






