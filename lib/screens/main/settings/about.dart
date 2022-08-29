import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:app_word/widgets/global/icon_button_widget.dart';
import 'package:app_word/widgets/global/scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_donation_buttons/flutter_donation_buttons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimplePageScaffold(
      title: "About",
      padding: 25,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StaggeredGrid.count(
            crossAxisCount: 1,
            mainAxisSpacing: 25,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/App_Logo.png",
                    width: ScreenUtil.getSize(context).width / 2,
                  ),
                ],
              ),
              // const Text(
              //   "Team Starvation",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          Column(
            children: [
              IconButtonWidget(
                icon: Container(
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 32.5,
                  ),
                  // decoration: BoxDecoration(
                  //   color: CupertinoColors.systemYellow,
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: Image.asset(
                    "assets/PayPal.png",
                    width: ScreenUtil.getSize(context).width / 3,
                  ),
                ),
                //backgroundColor: Colors.amber,
                onPressed: () => launchUrl(
                  Uri.parse(
                    "https://www.paypal.com/donate?hosted_button_id=492UNJ9QPTDUE",
                  ),
                  mode: LaunchMode.platformDefault,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              IconButtonWidget(
                icon: Image.asset(
                  "assets/BuyMeACoffee.png",
                  width: ScreenUtil.getSize(context).width / 2,
                ),
                onPressed: () => launchUrl(
                  Uri.parse("https://www.buymeacoffee.com/GiacoLenzo2109"),
                  mode: LaunchMode.platformDefault,
                ),
              )
            ],
          ),
          StaggeredGrid.count(
            crossAxisCount: 1,
            children: [
              Text(
                "Made by",
                style: TextStyle(
                  color: ThemesUtil.getPrimaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              ButtonWidget(
                text: "@GiacoLenzo2109",
                textColor: ThemesUtil.getPrimaryColor(context),
                backgroundColor: Colors.transparent,
                onPressed: () => launchUrl(
                  Uri.parse("https://github.com/GiacoLenzo2109"),
                  mode: LaunchMode.platformDefault,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ],
      ),
      scrollable: false,
    );
  }
}
