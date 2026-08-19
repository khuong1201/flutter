import 'dart:convert';
import 'package:course/features/characters/domain/entities/character_entity.dart';

class StrokeConstants {
  static const String _baJson = r'''[{"id":21,"characterId":4,"order":1,"medianPath":"[[80,574],[114,542],[118,528],[156,280]]","outlinePath":"M 140 567 Q 127 574 91 582 Q 78 586 73 581 Q 66 574 75 556 Q 106 475 121 347 Q 122 308 143 281 Q 162 256 168 273 Q 177 295 173 336 L 168 375 Q 152 496 149 534 C 146 564 146 564 140 567 Z"},{"id":22,"characterId":4,"order":2,"medianPath":"[[156,542],[160,555],[279,594],[301,590],[325,567],[292,439],[265,417]]","outlinePath":"M 315 414 Q 337 517 366 549 Q 391 579 364 594 Q 342 606 311 624 Q 289 636 241 604 Q 205 586 140 567 C 111 558 120 525 149 534 Q 213 555 246 564 Q 273 571 280 561 Q 290 552 280 507 Q 270 462 258 411 C 251 382 309 385 315 414 Z"},{"id":23,"characterId":4,"order":3,"medianPath":"[[179,343],[190,362],[259,388],[316,396],[333,392]]","outlinePath":"M 173 336 Q 260 366 333 382 Q 343 385 343 394 Q 343 401 315 414 L 258 411 L 257 411 Q 209 390 168 375 C 140 365 145 326 173 336 Z"}]''';

  static List<StrokeDataEntity> get sampleStrokes {
    final List<dynamic> list = jsonDecode(_baJson);
    return list.map((e) => StrokeDataEntity(
      order: e['order'],
      medianPath: e['medianPath'],
      outlinePath: e['outlinePath'],
    )).toList();
  }
}
