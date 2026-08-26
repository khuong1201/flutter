import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class TinderSwipeDeck extends StatefulWidget {
  final List<Widget> cards;

  const TinderSwipeDeck({
    super.key,
    required this.cards,
  });

  @override
  State<TinderSwipeDeck> createState() => _TinderSwipeDeckState();
}

class _TinderSwipeDeckState extends State<TinderSwipeDeck> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      // Thư viện hỗ trợ sẵn cảm giác vuốt thẻ 3D xếp lớp chồng chéo lên nhau
      child: CardSwiper(
        controller: controller,
        cardsCount: widget.cards.length,
        onSwipe: (int previousIndex, int? currentIndex, CardSwiperDirection direction) {
          debugPrint('Đã quẹt thẻ số $previousIndex về hướng $direction');
          return true; // Cho phép quẹt
        },
        onUndo: (int? previousIndex, int currentIndex, CardSwiperDirection direction) {
          debugPrint('Đã hoàn tác thẻ $currentIndex');
          return true;
        },
        numberOfCardsDisplayed: 3, // Hiển thị 3 thẻ xếp lớp
        backCardOffset: const Offset(40, 40), // Các thẻ sau thụt xuống góc phải
        padding: const EdgeInsets.all(24.0),
        cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: widget.cards[index],
          );
        },
      ),
    );
  }
}
