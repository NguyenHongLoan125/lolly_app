import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/authentication_controller.dart';
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        title: FutureBuilder<String?>(
          future: getCurrentUserName(),
          builder: (context, snapshot) {
            final name = snapshot.data ?? '';
            return Text(
              name,
              style: const TextStyle(
                color: Color(0xFF007400),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          Image.asset('assets/logo.png', height: 70, width: 70),
        ],
        elevation: 0,
      ),


      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            color: Colors.white,
          ),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // context.push('/favorites');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.save, color: Color(0xFF007400)),
                              const SizedBox(width: 20),
                              Text(
                                'Bản lưu nháp',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF007400)),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.push('/posted');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.note_add, color: Color(0xFF007400)),
                              const SizedBox(width: 20),
                              Text(
                                'Bài đã đăng',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF007400)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.push('/favorites');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.favorite, color: Color(0xFF007400)),
                              const SizedBox(width: 20),
                              Text(
                                'Món đã lưu',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF007400)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            const Icon(Icons.manage_accounts, color: Color(0xFF007400)),
                            const SizedBox(width: 20),
                            Text(
                              'Chỉnh sửa hồ sơ',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: const Icon(Icons.arrow_forward_ios, size: 18, color:  Color(0xFF007400)),
                        ),
                      ],
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),

    );
  }
}


