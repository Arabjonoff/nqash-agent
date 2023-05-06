import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    change(index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: 40,
                    height: 40,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
          Expanded(child: PageView.builder(
            itemCount: data.length,
            controller: pageController,
            scrollDirection: Axis.horizontal,
              onPageChanged: (_index) {
                setState(() {
                  _selectedIndex = _index;
                });
              },
              itemBuilder: (context,index){
            return data[index];
          }))
        ],
      ),
    );
  }
  change(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 270),
        curve: Curves.easeIn,
      );
    });
  }
  List<Widget> data = [
     Container(color: Colors.purple,),
     Container(color: Colors.red,),
     Container(color: Colors.deepOrange,),
     Container(color: Colors.amber,),
     Container(color: Colors.cyan,),
  ];
  int _selectedIndex = 0;
}
