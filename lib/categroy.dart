import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_app/model.dart';
import 'package:news_app/NewsView.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url = "";
    if (query == "Top News" || query == "News") {
      url =
          "https://newsapi.org/v2/top-headlines?country=in&apiKey=8c6ba25d516f4825b960c74b20be457d";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=tesla&from=2022-1-05&sortBy=&apiKey=8c6ba25d516f4825b960c74b20be457d";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
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
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOP NEWS"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.Query,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height - 250,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                            newsModelList[index].newsDes.length >
                                                    50
                                                ? "${newsModelList[index].newsDes.substring(0, 50)}..."
                                                : newsModelList[index].newsDes,
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
                      }),

                                    
               Container(
                 child: Center(
                   child: ElevatedButton(  
                     style: ElevatedButton.styleFrom(
                       padding: EdgeInsets.all(10),
                     ),
                     child: Text('Back',style: TextStyle(fontWeight: FontWeight.bold),),
                     onPressed: (){
                       Navigator.pop(context, MaterialPageRoute(builder: (context)=> Category(Query: '',)));
                     },
                   ),
                 ),
               )
                ],
              ),
            ),
            
          ),
        );
      
    
  }
}
