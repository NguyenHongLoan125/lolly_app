import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddLogo extends StatelessWidget {
  const AddLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/logo.png', height: 150, width: 150,),
          const SizedBox(height: 5,),
          const Text(
            'Nấu ăn cùng bạn!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white
          ),)
          
        ],
      ),
    );
  }
}

class CreateScreen extends StatelessWidget {

  final String description;
  final Widget Function(BuildContext, TextEditingController) content;
  final String btnText;
  final VoidCallback onNext;

  const CreateScreen({
    super.key,

    required this.content,
    required this.btnText,
    required this.onNext, required this.description
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const SizedBox(height: 10,),
        Text(
          description,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
        ),

        const SizedBox(height: 15,),
        content(context, controller),

        const SizedBox(height: 25,),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromRGBO(0, 116, 0, 1),
              foregroundColor: Colors.white,
              maximumSize: Size(double.infinity, 48),
            ),
              onPressed: onNext,
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
        )


      ],
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String backRoute; // dùng route name/path
  final Object? extra;    // nếu muốn truyền thêm dữ liệu

  const CustomAppBar({
    super.key,
    required this.backRoute,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(204, 255, 152, 1),
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () {
            // Sử dụng context.go thay cho pushReplacement
            context.go(backRoute, extra: extra);
          },
          child: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

