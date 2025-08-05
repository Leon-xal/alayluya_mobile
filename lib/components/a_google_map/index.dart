// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class AGoogleMap extends StatefulWidget {
//   double lat;
//   double lng;
//   AGoogleMap({
//     Key key,
//     this.lat = -33.852,
//     this.lng = 151.211,
//   }) : super(key: key);
//
//   @override
//   AGoogleMapState createState() => new AGoogleMapState();
// }
//
//
//
// class AGoogleMapState extends State<AGoogleMap> {
//   GoogleMapController controller;
//   BitmapDescriptor _markerIcon;
//   double _lat;
//   double _lng;
//
//   @override
//   void initState() {
//     super.initState();
//     _lat = widget.lat;
//     _lng = widget.lng;
// //    print('aaa===>${_lat}/${_lng}');
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _createMarkerImageFromAsset(context);
//
//     if(_lat != null && _lng != null){
// //      print('location2===>${_lat}/${_lng}');
//       return SizedBox(
//         width: 300.0,
//         height: 250.0,
//         child: GoogleMap(
//           myLocationButtonEnabled : false,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(_lat, _lng),
//             zoom: 13.0,
//           ),
//           markers: _createMarker(),
//           onMapCreated: _onMapCreated,
//         ),
//       );
//     }else{
//       return Container();
//     }
//
//     return Text('asd');
//   }
//
//   Set<Marker> _createMarker() {
//     // TODO(iskakaushik): Remove this when collection literals makes it to stable.
//     // https://github.com/flutter/flutter/issues/28312
//     // ignore: prefer_collection_literals
//     return <Marker>[
//       Marker(
//         markerId: MarkerId("marker_1"),
//         position: LatLng(_lat, _lng),
//         icon: _markerIcon,
//       ),
//     ].toSet();
//   }
//
//   Future<void> _createMarkerImageFromAsset(BuildContext context) async {
//     if (_markerIcon == null) {
//       final ImageConfiguration imageConfiguration =
//       createLocalImageConfiguration(context);
//       BitmapDescriptor.fromAssetImage(
//           imageConfiguration, 'assets/red_square.png')
//           .then(_updateBitmap);
//     }
//   }
//
//   void _updateBitmap(BitmapDescriptor bitmap) {
//     setState(() {
//       _markerIcon = bitmap;
//     });
//   }
//
//   void _onMapCreated(GoogleMapController controllerParam) {
//     setState(() {
//       controller = controllerParam;
//     });
//   }
// }
