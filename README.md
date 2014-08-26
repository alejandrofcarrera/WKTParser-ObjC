**WKTParser**
**Well-Known-Text Parser for Objective-C**

WKTParser Library have any conversions, parsers and formats. This library allow you parser three main types of WKT data: points, lines and polygons (single, multi, 2D and 3D).
Also you can convert WKT format to MK format (2D) like MKMapPoint, Polyline, Polygon or Annotation.

=========

**Installation**

**Via xCode Project**

Open WKT Parser Project, Drag & Drop Library and Library Support group over your Project and reference at your header WKTParser.h

**Via Source Code**

Simply, add Library Folder at xCode Project and reference at your header WKTParser.h

=========


**WKT Parser Methods**


Generic method (recommended): Read input string and create WKTGeometry Class with properties of specific type. This input should be WKT Format, for example POINT (30 10).

* (WKTGeometry *) parseGeometry: NSString

Specific methods: Read input value and create WKT Type (must have dimension, 2 or 3). This input should be WKT Value, for example (30 10).

* (WKTPoint *) parsePoint: NSString Integer
* (WKTPointM *) parseMultiPoint: NSString Integer
* (WKTLine *) parseLine: NSString Integer
* (WKTLineM *) parseMultiLine: NSString Integer
* (WKTPolygon *) parsePolygon: NSString Integer
* (WKTPolygonM *) parseMultiPolygon: NSString Integer

**Common Methods (WKT Structure)**
* (BOOL) isEqual: WKT - Method to compare WKT.
* (NSString *) toWKT - Method to return WKT Representation.
* (void) copyTo: WKT - Method to clone WKT.

**Specific Conversions (WKT Structure)**

Each type allow convert itself to MapKit Structure (only 2D)

WKTPoint and WKTPointM
* MKPointAnnotation (toMapPointAnnotation)
* MKMapPoint (toMapPoint)
* NSArray of MKPointAnnotation (toMapMultiPoint)

WKTLine and WKTLineM
* MKPolyline (toMapLine)
* NSArray of MKPolyline (toMapMultiLine)

WKTPolygon and WKTPolygonM
* MKPolygon (toMapPolygon)
* NSArray of MKPolygon (toMapMultiPolygon)

=========

**Unit Tests**

Run via the Product menu > Test or CMD + U

=========

**Credits**

Alejandro Fdez. Carrera

**License**

WKTParser is available under the MIT License. See the LICENSE file for more info.