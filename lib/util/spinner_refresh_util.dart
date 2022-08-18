import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SpinnerRefreshUtil {
  static Widget buildSpinnerOnlyRefreshIndicator(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {
    const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Opacity(
          opacity: opacityCurve
              .transform(min(pulledExtent / refreshIndicatorExtent, 1.0)),
          child: const CupertinoActivityIndicator(radius: 14.0),
        ),
      ),
    );
  }
}
