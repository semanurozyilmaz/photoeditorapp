class Stickers{
  List<List<String>> list() {
    return [
      face(),
      hand()
    ];
  }

  List <String> face(){
    List<String> list = [];
    for(int i = 1; i <= 25; i ++){
      list.add('assets/stickers/face$i.png');
    }
    return list;
  }

  List <String> hand(){
    List<String> list = [];
    for(int i = 1; i <= 27; i ++){
      list.add('assets/stickers/hand$i.png');
    }
    return list;
  }
}