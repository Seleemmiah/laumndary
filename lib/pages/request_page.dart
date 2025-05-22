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

  Set<Marker> _markers = {};

  final _addressController = TextEditingController();
  TimeOfDay? _pickupTime;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    LocationData _locationData = await location.getLocation();
    final userLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    setState(() {
      _currentPosition = userLatLng;
      _loadMarkers();
    });
  }

  void _loadMarkers() {
    if (_currentPosition == null) return;

    Set<Marker> markers = {};
    for (var shop in laundryShops) {
      markers.add(
        Marker(
          markerId: MarkerId(shop['name']),
          position: LatLng(
            _currentPosition!.latitude + shop['lat'],
            _currentPosition!.longitude + shop['lng'],
          ),
          infoWindow: InfoWindow(title: shop['name']),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  void _selectPickupTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _pickupTime = time;
      });
    }
  }

  void _confirmPickup() {
    if (_addressController.text.isEmpty || _pickupTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    // Proceed to confirmation or backend logic
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pickup Confirmed"),
        content: Text(
            "We'll pick up your laundry at ${_addressController.text} by ${_pickupTime!.format(context)}"),
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
            Text("Select Laundry Type",
                style: Theme.of(context).textTheme.titleMedium),
            DropdownButton<String>(
              items: [
                DropdownMenuItem(
                    value: 'Wash & Fold', child: Text('Wash & Fold')),
                DropdownMenuItem(
                    value: 'Dry Cleaning', child: Text('Dry Cleaning')),
                DropdownMenuItem(value: 'Iron Only', child: Text('Iron Only')),
              ],
              onChanged: (val) {},
              hint: Text('Choose Type'),
            ),
            SizedBox(height: 16),

            Text("Your Address",
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText: "Enter your address"),
            ),
            SizedBox(height: 16),

            Text("Pickup Time", style: Theme.of(context).textTheme.titleMedium),
            ElevatedButton(
              onPressed: _selectPickupTime,
              child: Text(_pickupTime == null
                  ? "Select Time"
                  : _pickupTime!.format(context)),
            ),

            SizedBox(height: 24),
            Text("Nearby Laundry Shops",
                style: Theme.of(context).textTheme.titleMedium),
            Container(
              height: 250,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: _currentPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      myLocationEnabled: true,
                      markers: _markers,
                    ),
            ),

            // Shop list below map
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: laundryShops.length,
              itemBuilder: (context, index) {
                final shop = laundryShops[index];
                return ListTile(
                  leading: Icon(Icons.local_laundry_service),
                  title: Text(shop['name']),
                  subtitle: Text(shop['address']),
                );
              },
            ),

            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _confirmPickup,
                child: Text("Confirm Pickup"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
