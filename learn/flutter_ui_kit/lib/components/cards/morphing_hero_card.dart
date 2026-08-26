import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class MorphingHeroCard extends StatelessWidget {
  final Widget closedWidget;
  final Widget openWidget;
  final Color closedColor;

  const MorphingHeroCard({
    super.key,
    required this.closedWidget,
    required this.openWidget,
    this.closedColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      closedElevation: 5.0,
      openElevation: 0.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      closedColor: closedColor,
      openColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 600),
      
      // Lúc thẻ đang đóng (Hiển thị trên List)
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return InkWell(
          onTap: openContainer,
          child: closedWidget,
        );
      },
      
      // Lúc thẻ bung to ra (Màn hình chi tiết)
      openBuilder: (BuildContext context, VoidCallback _) {
        return openWidget;
      },
    );
  }
}
