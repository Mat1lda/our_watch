import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class MainPage extends ConsumerWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return buildUI();
  }

  Widget buildUI(){
    return Scaffold();
  }

}