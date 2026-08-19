import 'dart:math';

import 'package:course/core/utils/stroke_constants.dart';
import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/domain/usecases/get_character_usecase.dart';
import 'package:course/features/characters/domain/usecases/search_characters_usecase.dart';
import 'package:course/features/characters/presentation/widgets/stroke_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SharedLoadingWidget extends StatefulWidget {
  final String language;
  final VoidCallback? onAnimationCompleted;

  const SharedLoadingWidget({
    super.key,
    required this.language,
    this.onAnimationCompleted,
  });

  static final Map<String, List<int>> cachedCharacterIds = {};

  static Future<void> preloadCaches() async {
    try {
      final search = GetIt.I<SearchCharactersUseCase>();
      
      // Delay to let Splash Screen finish its initial heavy animation
      await Future.delayed(const Duration(milliseconds: 600));

      // Preload JA
      if ((cachedCharacterIds['ja'] ?? []).isEmpty) {
        final resJa = await search(limit: 50, lang: 'ja');
        resJa.fold((l) {}, (chars) {
          cachedCharacterIds['ja'] = chars.map((c) => c.id).toList();
        });
      }

      // Delay to split the CPU load
      await Future.delayed(const Duration(milliseconds: 300));

      // Preload ZH
      if ((cachedCharacterIds['zh'] ?? []).isEmpty) {
        final resZh = await search(limit: 50, lang: 'zh');
        resZh.fold((l) {}, (chars) {
          cachedCharacterIds['zh'] = chars.map((c) => c.id).toList();
        });
      }
    } catch (_) {}
  }

  @override
  State<SharedLoadingWidget> createState() => _SharedLoadingWidgetState();
}

class _SharedLoadingWidgetState extends State<SharedLoadingWidget> {
  List<StrokeDataEntity> _strokes = [];
  String _meaning = '';
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomCharacter();
  }

  Future<void> _fetchRandomCharacter() async {
    try {
      final getCharacterUseCase = GetIt.I<GetCharacterUseCase>();
      final searchCharactersUseCase = GetIt.I<SearchCharactersUseCase>();
      
      // Lấy danh sách ID cho ngôn ngữ này (từ cache hoặc từ API)
      List<int> validIds = SharedLoadingWidget.cachedCharacterIds[widget.language] ?? [];
      
      if (validIds.isEmpty) {
        // Lần đầu tiên gọi API search sẽ khá lâu, nên ta cho hiện fallback tạm thời
        // để màn hình không bị trống trơn.
        if (mounted) {
          setState(() {
            _strokes = StrokeConstants.sampleStrokes;
            _meaning = widget.language == 'ja' ? 'Nhé, nhỉ (Từ lóng)' : 'Nhé, nhỉ, đi (Trợ từ)';
            _isVisible = true;
          });
        }

        // Fetch từ API search
        final searchResult = await searchCharactersUseCase(
          limit: 50,
          lang: widget.language,
        );
        
        searchResult.fold(
          (failure) {},
          (characters) {
            validIds = characters.map((c) => c.id).toList();
            if (validIds.isNotEmpty) {
              SharedLoadingWidget.cachedCharacterIds[widget.language] = validIds;
            }
          },
        );
      }

      CharacterEntity? validCharacter;

      // 2. Chọn ngẫu nhiên 1 ID từ danh sách hợp lệ và gọi API lấy chi tiết
      if (validIds.isNotEmpty) {
        // Thử tối đa 3 lần đề phòng ID đó bị lỗi chi tiết
        for (int i = 0; i < 3; i++) {
          final randomId = validIds[Random().nextInt(validIds.length)];
          final result = await getCharacterUseCase(randomId);
          
          result.fold(
            (failure) {},
            (character) {
              if (character.language == widget.language && character.strokes.isNotEmpty) {
                validCharacter = character;
              }
            },
          );

          if (validCharacter != null) break;
        }
      }
      
      if (mounted) {
        if (validCharacter != null) {
          setState(() {
            _strokes = validCharacter!.strokes;
            _meaning = '${validCharacter!.charText} - ${validCharacter!.meaning}';
            _isVisible = true;
          });
        } else {
          // Fallback nếu gọi API thất bại toàn bộ
          setState(() {
            _strokes = StrokeConstants.sampleStrokes;
            _meaning = widget.language == 'ja' ? 'Nhé, nhỉ (Từ lóng)' : 'Nhé, nhỉ, đi (Trợ từ)';
            _isVisible = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _strokes = StrokeConstants.sampleStrokes;
          _meaning = widget.language == 'ja' ? 'Nhé, nhỉ (Từ lóng)' : 'Nhé, nhỉ, đi (Trợ từ)';
          _isVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              child: StrokeAnimationWidget(
                key: ValueKey(_meaning),
                strokeData: _strokes,
                size: 240,
                strokeColor: colors.primary,
                outlineColor: colors.onSurfaceVariant.withValues(alpha: 0.2),
                showGrid: false,
                showControls: false,
                loop: true,
                onAnimationCompleted: widget.onAnimationCompleted,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _meaning,
                style: textTheme.titleLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
