import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  
  static const LatLng _center = const LatLng(6.4676929, 100.5067673);
  
  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Dropped',
          snippet: '',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: homepage(),
      );
  }}
      
  class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}
  
  

class _homepageState extends State<homepage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<Marker> myMarker = [];
  String _currentAddress;
  double latitude,longitude;
  LatLng tappedPoint;
    final state = _MyAppState();
    List<Marker> _markers = <Marker>[];

  @override
  void initState() {
      getCurrentLocation(_MyAppState._center,);
            myMarker = [];
            myMarker.add(
            Marker(
            markerId: MarkerId(_MyAppState._center.toString()),
            position: _MyAppState._center,
            
           )
         );
          super.initState();
        }
      
               @override
                Widget build(BuildContext context) {
                  double height = MediaQuery.of(context).size.height*(2/3);
                  return Scaffold(
                    
              appBar: AppBar(
                title: Text('Lab 3 GMAP'),
                backgroundColor: Colors.green[700],
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                  height: height,
                  child: GoogleMap(
                    onMapCreated: state._onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _MyAppState._center,
                      zoom: 17.0,
                    ),
                    mapType: state._currentMapType,
                    markers: Set.from(myMarker),
                    onCameraMove: state._onCameraMove,
                    onTap: _handleTap,
                  ),
                  ),
                   Center(
                     child: Column(
                    children: <Widget>[
                       Column(
                        children: <Widget> [
                          
                          Align( alignment: Alignment.center ,child: Text('Latitude: '+latitude.toString(),)),
                          Align( alignment: Alignment.center ,child: Text('Longitude: '+longitude.toString(),)),
                          Align( alignment: Alignment.center ,child: Text('Address: '+_currentAddress.toString(),)),
                        ],
                      ),
                      
                    ] 
                  )
                 
                   )],
              ),
               
            );
            }
      
        _handleTap(tappedPoint) {
          getCurrentLocation(tappedPoint);
          print(tappedPoint);
          setState(() {
            latitude = tappedPoint.latitude;
            longitude = tappedPoint.longitude;
            myMarker = [];
            myMarker.add(
            Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            
           )
         );
          });
        }
      
        void getCurrentLocation(tappedPoint) async {
           try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          tappedPoint.latitude, tappedPoint.longitude);
      latitude = tappedPoint.latitude;
      longitude = tappedPoint.longitude;
     
  final coordinates = new Coordinates(latitude, longitude);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);

  var first = addresses.first;

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${first.addressLine}";
      });
    } catch (e) {
      print(e);
    }
          print(tappedPoint);
        }
}
