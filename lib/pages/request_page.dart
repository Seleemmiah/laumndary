import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RequestPickupPage extends StatefulWidget {
  @override
  _RequestPickupPageState createState() => _RequestPickupPageState();
}

class _RequestPickupPageState extends State<RequestPickupPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  final _addressController = TextEditingController();
  TimeOfDay? _pickupTime;
  String? _selectedLaundryType;

  final List<Map<String, dynamic>> laundryShops = [
    {
      "name": "QuickWash Laundry",
      "lat": 0.001,
      "lng": 0.001,
      "address": "12 Allen Ave, Ikeja"
    },
    {
      "name": "Sparkle Cleaners",
      "lat": -0.001,
      "lng": -0.001,
      "address": "5 University Rd, Akoka"
    },
    {
      "name": "FreshSpin Laundry",
      "lat": 0.002,
      "lng": -0.001,
      "address": "2 Market St, Yaba"
    }
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final location = Location();

      // Check if service is enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location service is disabled.')),
          );
          return;
        }
      }

      // Check permission
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      final locData = await location.getLocation();

      if (locData.latitude == null || locData.longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get current location.')),
        );
        return;
      }

      final currentLatLng = LatLng(locData.latitude!, locData.longitude!);

      final newMarkers = <Marker>{
        Marker(
          markerId: MarkerId('user'),
          position: currentLatLng,
          infoWindow: InfoWindow(title: 'You are here'),
        ),
      };

      for (var shop in laundryShops) {
        final shopLatLng = LatLng(
          currentLatLng.latitude + shop['lat'],
          currentLatLng.longitude + shop['lng'],
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId(shop['name']),
            position: shopLatLng,
            infoWindow:
                InfoWindow(title: shop['name'], snippet: shop['address']),
          ),
        );
      }

      setState(() {
        _currentPosition = currentLatLng;
        _markers = newMarkers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _selectPickupTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => _pickupTime = time);
    }
  }

  void _confirmPickup() {
    if (_addressController.text.isEmpty ||
        _pickupTime == null ||
        _selectedLaundryType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the details')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pickup Confirmed"),
        content: Text(
            "Laundry type: $_selectedLaundryType\nAddress: ${_addressController.text}\nTime: ${_pickupTime!.format(context)}"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Pickup")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Laundry Type"),
            DropdownButton<String>(
              value: _selectedLaundryType,
              isExpanded: true,
              hint: Text("Choose Type"),
              items: ['Wash & Fold', 'Dry Cleaning', 'Iron Only']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedLaundryType = value),
            ),
            SizedBox(height: 16),
            Text("Your Address"),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText: "Enter your address"),
            ),
            SizedBox(height: 16),
            Text("Pickup Time"),
            ElevatedButton(
              onPressed: _selectPickupTime,
              child: Text(_pickupTime == null
                  ? "Select Time"
                  : _pickupTime!.format(context)),
            ),
            SizedBox(height: 16),
            Text("Nearby Laundry Shops"),
            Container(
              height: 250,
              child: _currentPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      markers: _markers,
                    ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmPickup,
              child: Text("Confirm Pickup"),
            )
          ],
        ),
      ),
    );
  }
}
