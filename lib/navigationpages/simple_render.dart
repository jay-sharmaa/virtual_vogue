import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class SimpleRender extends StatefulWidget {
  const SimpleRender({super.key});

  @override
  State<SimpleRender> createState() => _SimpleRenderState();
}

class _SimpleRenderState extends State<SimpleRender> {
  late Object _object;
  @override
  Widget build(BuildContext context) {
    return Cube(
            onSceneCreated: (Scene scene) {
              scene.world.add(
                _object = Object(
                  scale: Vector3.all(5.0),
                  rotation: Vector3(0, 0, 0),
                  position: Vector3(0, 0, 0),
                  fileName: 'assets/shirt2.obj',
                ),
              );
            },
          );
  }
}