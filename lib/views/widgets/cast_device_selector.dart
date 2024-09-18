import 'package:cast/cast.dart';
import 'package:flutter/material.dart';

class CastDeviceSelector extends StatefulWidget {
  const CastDeviceSelector({Key? key, required this.onDeviceSelected}) : super(key: key);

  final Function onDeviceSelected;

  @override
  _CastDeviceSelectorState createState() => _CastDeviceSelectorState();
}

class _CastDeviceSelectorState extends State<CastDeviceSelector> {
  Future<List<CastDevice>>? _future;

  @override
  void initState() {
    super.initState();
    _startSearch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CastDevice>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No Chromecast found'));
        }

        return ListView(
          children: snapshot.data!.map((device) {
            return ListTile(
              title: Text(device.name),
              onTap: () => widget.onDeviceSelected(device),
            );
          }).toList(),
        );
      },
    );
  }

  void _startSearch() {
    _future = CastDiscoveryService().search();
  }
}
