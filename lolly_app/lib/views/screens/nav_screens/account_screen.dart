import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lolly_app/controllers/authentication_controller.dart';
import 'package:lolly_app/views/screens/nav_screens/widgets/custom_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF5E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF5E3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007400)),
          onPressed: () => context.go('/home'),
        ),
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
                        context.push('/draft');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.save, color: Color(0xFF007400)),
                              const SizedBox(width: 40),
                              Text(
                                'Bản lưu nháp',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
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
                              const SizedBox(width: 40),
                              Text(
                                'Bài đã đăng',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
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
                              const SizedBox(width: 40),
                              Text(
                                'Món đã lưu',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
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
                      onTap: (){
                        context.push('/edit-profile');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.manage_accounts, color: Color(0xFF007400)),
                              const SizedBox(width: 40),
                              Text(
                                'Chỉnh sửa hồ sơ',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
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
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận đăng xuất'),
                            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Đăng xuất',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          try {
                            await Supabase.instance.client.auth.signOut();
                            if (context.mounted) {
                              context.go('/login'); // ← thay bằng route đăng nhập của bạn nếu khác
                            }
                          } catch (e) {
                            print('Lỗi khi đăng xuất: $e');
                            showCustomSnackbar(context, 'Đăng xuất thất bại');
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Icon(Icons.logout, color: Color(0xFF007400)),
                              const SizedBox(width: 40),
                              Text(
                                'Đăng xuất',
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
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


