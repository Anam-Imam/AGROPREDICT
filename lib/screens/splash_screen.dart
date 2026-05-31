import 'package:flutter/material.dart';

import '../local/pref_helper.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuthUser();
  }

  Future<void> _checkAuthUser()async {
    await Future.delayed(Duration(seconds: 2));
    final token = await PrefHelper.getToken();
    if(!mounted) return;
    if(token != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainScreen()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
