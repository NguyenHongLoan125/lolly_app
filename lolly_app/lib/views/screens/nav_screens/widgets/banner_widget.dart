import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lolly_app/controllers/banner_controller.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();
  final PageController _pageController = PageController(); // giữ nguyên controller
  int _currentPage = 0;
  List<String> _banners = [];

  @override
  void initState() {
    super.initState();

    // Lắng nghe dữ liệu từ Stream và cập nhật state 1 lần duy nhất
    _bannerController.getBannerUrls().listen((data) {
      setState(() {
        _banners = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        child: _banners.isEmpty
            ? const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        )
            : Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CachedNetworkImage(
                      imageUrl: _banners[index],
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 180,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
            _buildPageIndicator(_banners.length),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          return Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _currentPage == index ? Color(0xFF007400) : Color(0xFFECF5E3),
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF007400)),
            ),
          );
        }),
      ),
    );
  }
}
