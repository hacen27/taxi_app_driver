import 'package:flutter/material.dart';

import '../../models/trip_model.dart';
import '../../services/database_service.dart';

class BottomDraggableSheet extends StatefulWidget {
  const BottomDraggableSheet({Key? key}) : super(key: key);

  @override
  State<BottomDraggableSheet> createState() => _BottomDraggableSheetState();
}

class _BottomDraggableSheetState extends State<BottomDraggableSheet> {
  final DatabaseService _dbService = DatabaseService();
  List<Trip> _trips = [];

  void getAllTrips() {
    _dbService.getTrips().listen((List<Trip> trips) {
      setState(() {
        _trips = trips;
      });
    });
  }

  @override
  void initState() {
    getAllTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.1,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[200]!,
                offset: const Offset(0, -2),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: ListView.builder(
            controller: controller,
            itemCount: _trips.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Center(
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
                );
              }

              Trip trip = _trips[index - 1];
              return _buildTripPanel(trip);
            },
          ),
        );
      },
    );
  }

  Widget _buildTripPanel(Trip trip) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoText('From: ', trip.pickupAddress!),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoText('To: ', trip.destinationAddress!),
                  const SizedBox(height: 2),
                  _buildInfoText(
                    'Distance: ',
                    '${trip.distance!.toStringAsFixed(2)} Km',
                  ),
                ],
              ),
              Chip(
                label: Text(
                  'Cost: \$${trip.cost!.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                labelStyle: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Start Trip'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Show on Map'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String title, String info) {
    return RichText(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: info,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}