import 'package:flutter/material.dart';
import 'package:flutter_application_1/genmodel.dart';
import 'package:flutter_application_1/remote_service.dart';
import 'package:responsive_gridview/responsive_gridview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Catalog',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Product Catalog Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool loading = false;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  String searchKeyword = "";

  Data? cdata;
  List<Product>? products = [];
  int skip = 0;
  int limit = 20;
  int? total = 0;
  int currentpage = 0;
  double totalpage = 0;


  @override
  void initState() {
    super.initState();
    _loadDatas();//get data from API
    scrollController.addListener(_loadDataNext);
    
    
  }

  Future<void> _loadDatas() async {
    if (loading){
      return;
    }

    setState(() {
      loading = true;
    });
    cdata = await RemoteService().getData(searchKeyword,limit,skip);
    total = cdata?.total;

    products?.addAll(cdata!.products) ;
    setState(() {
      loading = false;
    });
  }

  void _loadDataNext() {
    print('loadNext');
    // skip = skip+limit;
    // if(skip < total!){
      if(scrollController.offset == scrollController.position.maxScrollExtent
          && !scrollController.position.outOfRange){
        currentpage++;
        skip = products!.length;
        print('productLen =${products?.length} skip = $skip, total = $total');
        if(skip < total!){
        _loadDatas();
        }
      }
      
    // }
    
  }

  void _searchData(String query){
    print('search searchController = $searchController.text.toString()');
    searchKeyword = query;
    products!.clear();
    skip = 0;
    _loadDatas();
  }

  void _searchClear(){
    searchKeyword = "";
    products!.clear();
    searchController.clear();
    skip = 0;
    _loadDatas();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          SearchBar(
            controller: searchController,
            leading: const Icon(Icons.search),
            hintText: "Search",
            onSubmitted: (query){
              print("search = $query");
              _searchData(query);
            },
            trailing: [
              if (searchController.text.isNotEmpty)
                IconButton(
                  onPressed: _searchClear, 
                  icon: const Icon(Icons.clear)
                )
            ]
          ),
          Flexible(
            child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: ResponsiveGridView.builder(
            minItemWidth: 120,
            horizontalSpacing: 10,
            verticalSpacing: 10,
            itemCount: products!.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                height: 210,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.grey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network(
                          products![index].thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Container(
                        height: 82,
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            Container(
                              child: 
                                Text(
                                  maxLines: 2,
                                  overflow:TextOverflow.ellipsis,
                                  softWrap: true,
                                  products![index].title, 
                                  style: TextStyle(fontSize: 12),
                                  )
                            ),
                            Container(
                              child: 
                                Text(
                                  ('RM${products![index].price}'), 
                                    style: TextStyle(fontSize: 12),
                                  ),
                            ),
                        
                            Container(
                              height: 15,
                              child: 
                                ElevatedButton(
                                  onPressed: () {
                                    print("button clicked");
                                    
                                  },
                                  child: Text(
                                    'Details',
                                    style: TextStyle(fontSize: 8)
                                  )
                                )
                            )
                        ],
                        ),
                      )
                    ] 
                  ),
                ),
                
              );
            },
          ),
          ),
          ),
          if(loading)
          const CircularProgressIndicator(color: Colors.black),



        ],
      ),
    );
  }
}
