import 'package:campus_mobile_experimental/core/constants/app_constants.dart';
import 'package:campus_mobile_experimental/core/data_providers/cards_data_provider.dart';
import 'package:campus_mobile_experimental/core/data_providers/shuttle_data_provider.dart';
import 'package:campus_mobile_experimental/core/data_providers/user_data_provider.dart';
import 'package:campus_mobile_experimental/core/models/shuttle_arrival_model.dart';
import 'package:campus_mobile_experimental/core/models/shuttle_stop_model.dart';
import 'package:campus_mobile_experimental/core/services/bottom_navigation_bar_service.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/card_container.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/dots_indicator.dart';
import 'package:campus_mobile_experimental/ui/cards/shuttle/shuttle_display.dart';
import 'package:campus_mobile_experimental/ui/reusable_widgets/container_view.dart';
import 'package:campus_mobile_experimental/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ManageShuttleView extends StatelessWidget {
  ShuttleDataProvider _shuttleDataProvider = ShuttleDataProvider();

  @override
  Widget build(BuildContext context) {
    _shuttleDataProvider = Provider.of<ShuttleDataProvider>(context);
    return Stack(children: <Widget>[
      ContainerView(
        child: buildLocationsList(context),
      ),
      buildAddStopsButton(context),
    ]);
  }

  Widget buildLocationsList(BuildContext context) {
    if(_shuttleDataProvider.stopsToRender.isEmpty) {
      return(
        Center(
          child: Text("No saved stops.")
        )
      );
    }
    else {
      return ReorderableListView(
        children: createList(context),
        onReorder: _onReorder,
      );
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    List<ShuttleStopModel> newOrder = _shuttleDataProvider.stopsToRender;
    List<ShuttleStopModel> toRemove = List<ShuttleStopModel>();

    for (ShuttleStopModel item in newOrder) {
      if (_shuttleDataProvider.stopsToRender == null) {
        toRemove.add(item);
      }
    }
    newOrder.removeWhere((element) => toRemove.contains(element));
    ShuttleStopModel item = newOrder.removeAt(oldIndex);
    newOrder.insert(newIndex, item);
    List<int> orderedStopNames = List<int>();
    for (ShuttleStopModel item in newOrder) {
      orderedStopNames.add(item.id);
    }
    _shuttleDataProvider.reorderStops(orderedStopNames);
  }

  List<Widget> createList(BuildContext context) {
    List<Widget> list = List<Widget>();
    print("is called");
      for (ShuttleStopModel model in _shuttleDataProvider.stopsToRender) {
        if (model != null) {
          list.add(ListTile(
            key: Key(model.id.toString()),
            title: Text(
              model.name,
            ),
            leading: Icon(
              Icons.reorder,
            ),
            /*trailing: Switch(
            value: Provider.of<ShuttleStopModel>(context)
                .locationViewState[model.locationName],
            activeColor: Theme.of(context).buttonColor,
            onChanged: (_) {
              _shuttleDataProvider.toggleLocation(model.locationName);
            },
          ),*/
          ));
        }
      }
    return list;
  }

  Widget buildAddStopsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 40.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: ColorPrimary,
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.AddShuttleStopsView);
          },
        ),
      ),
    );
  }
}
