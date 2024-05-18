import '../model/texture.dart';

class Textures{
  List<Texture> list() {
    return <Texture> [
      Texture(
        name: 'T1',
        path: 'assets/images/texture1.jpg'
      ),
      Texture(
          name: 'T2',
          path: 'assets/images/texture2.jpg'
      ),
      Texture(
          name: 'T3',
          path: 'assets/images/texture3.jpg'
      ),
      Texture(
          name: 'T4',
          path: 'assets/images/texture4.jpg'
      ),
      Texture(
          name: 'T5',
          path: 'assets/images/texture5.jpg'
      )
    ];
  }
}