import 'package:flutter/material.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/banner_widget.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/category_item.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/popular_dishes_widget.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/search_hover.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _LollyScreenState();
}

class _LollyScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double topOffset = 265;// cho vị trí của khung trắng

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      setState(() {
        topOffset = (265- offset).clamp(90, 265);// vị trí khi cuộn
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 60,
                      ),
                     ),
                     // Padding(
                     //   padding: const EdgeInsets.symmetric(horizontal: 10),
                     //   child: Icon(
                     //     Icons.search,
                     //     size: 35,
                     //     color: Color(0xFF007400),
                     //   ),
                     // ),
                     SearchHoverWidget(),
                   ],
                 ),

                // Banner
                BannerWidget(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width * 0.8,
                //       height: 180,
                //       alignment: Alignment.centerRight,
                //       child: BannerWidget(),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),


          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            top: topOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child:CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Danh mục',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF007400),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -15),
                          child: SizedBox(
                            height: 135,
                            child: CategoryItem(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Món ăn phổ biến',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007400),
                        ),
                      ),
                    ),
                  ),
                  PopularDishesWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
