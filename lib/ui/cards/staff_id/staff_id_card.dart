import 'package:campus_mobile_experimental/core/constants/app_constants.dart';
import 'package:campus_mobile_experimental/core/data_providers/cards_data_provider.dart';
import 'package:campus_mobile_experimental/core/data_providers/user_data_provider.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaffIdCard extends StatefulWidget {
  StaffIdCard();
  @override
  _StaffIdCardState createState() => _StaffIdCardState();
}

class _StaffIdCardState extends State<StaffIdCard> {
  String cardId = "staff_id";
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      active: Provider.of<CardsDataProvider>(context).cardStates[cardId],
      hide: () => Provider.of<CardsDataProvider>(context, listen: false)
          .toggleCard(cardId),
      reload: () => reloadWebView(),
      isLoading: false,
      titleText: CardTitleConstants.titleMap[cardId],
      errorText: null,
      child: () => buildCardContent(context),
    );
  }

  var _url = "https://mobile.ucsd.edu/replatform/v1/qa/webview/staff_id.html";
  //final _url = "file:///Users/sonikaram/Downloads/staff_id_sonika.html";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  UserDataProvider _userDataProvider;
  set userDataProvider(UserDataProvider value) => _userDataProvider = value;

  Widget buildCardContent(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      _url = "https://cwo-test.ucsd.edu/WebCards/staff_id_darkmode.html";
    }

    _userDataProvider = Provider.of<UserDataProvider>(context);

    /// Verify that user is logged in
    if (_userDataProvider.isLoggedIn) {
      /// Initialize header
      final Map<String, String> header = {
        'Authorization':
            'Bearer ${_userDataProvider?.authenticationModel?.accessToken}'
      };
    }
    var tokenQueryString =
        "token=" + '${_userDataProvider.authenticationModel.accessToken}';
    var url = _url + "?" + tokenQueryString;

    return Column(
      children: <Widget>[
        Flexible(
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: url,
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
          ),
        ),
      ],
    );
  }

  void reloadWebView() {
    _webViewController?.reload();
  }
}
