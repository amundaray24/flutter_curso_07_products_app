import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _ColorBox(),
          const _HeaderIcon(),
          child
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {

  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {

  const _ColorBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height) * 0.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.blue,
          ]
        )
      ),
      child: Stack(
        children: const [
          Positioned(top: 90, left: 30, child: _Bubble(color: Colors.lightBlue,),),
          Positioned(top: -40, left: -30, child: _Bubble(color: Colors.lightBlue,),),
          Positioned(top: -50, right: -20, child: _Bubble(color: Colors.lightBlue,),),
          Positioned(bottom: -50, left: 10, child: _Bubble(color: Colors.lightBlue,),),
          Positioned(bottom: 120, right: 20, child: _Bubble(color: Colors.lightBlue,),),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {

  final Color color;

  const _Bubble({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color
      ),
    );
  }
}
