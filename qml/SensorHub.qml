import QtQuick 2.7
import QtSensors 5.3
import QtWebSockets 1.0
//import Qt.WebSockets 1.0

import "kernel.js" as K

Item {
	id: hub

	property bool debug: true
	property int port: 1234
	property string server
	property bool active: server === "" //
	property string url: active?wServer.url:wClient.url

	property int dataRate: debug?2:50
	property int dataFreshness: 0
	property int readyBits: rot.freshnessBit | acc.freshnessBit

	property real timestamp
	property real timeLast: timestamp
	property real dt: timestamp - timeLast

	property var rotRaw: rotRef  // Qt.vector3d cannot be serialized, suck!
	property vector3d rotRef
	property vector3d rotation: reading2v3d(rotRaw).minus(rotRef)

	property var accRaw: accRef
	property vector3d accRef
	property vector3d acceleration: reading2v3d(accRaw).minus(accRef)

	property real aziRaw
	property real aziRef
	property real azimuth: aziRaw - aziRef

	signal ready()

	function reading2v3d(reading) {
		return Qt.vector3d(reading.x, reading.y, reading.z)
	}

	function calibRotation(vec) {
		if (vec === undefined)
			vec = reading2v3d(rotRaw)
		rotRef = vec
	}

	function calibAcceleration(vec) {
		if (vec === undefined)
			vec = reading2v3d(accRaw)
		accRef = vec
	}

	function calibAzimuth(v) {
		if (v === undefined)
			v = aziRaw
		aziRef = v
	}

	function calibDirection() {
		calibRotation()
		calibAzimuth()
	}

	function calibAll() {
		calibAcceleration()
		calibDirection()
	}

	RotationSensor {
		id: rot

		active: hub.active
		dataRate: hub.dataRate

		property int freshnessBit: 1

		onReadingChanged: {
			if (hub.dataFreshness & freshnessBit)
				return;
			hub.rotRaw = reading
			hub.timestamp = new Date().getTime()
			if (debug)
				console.log(hub.dt, "rot", K.v3d2str(hub.rotRaw))
			hub.dataFreshness |= freshnessBit
		}
	}

	Accelerometer {
		id: acc

		active: hub.active
		dataRate: hub.dataRate

		property int freshnessBit: 2

		onReadingChanged: {
			if (hub.dataFreshness & freshnessBit)
				return;
			hub.accRaw = reading
			hub.timestamp = new Date().getTime()
			if (debug)
				console.log(hub.dt, "acc", K.v3d2str(hub.accRaw))
			hub.dataFreshness |= freshnessBit
		}
	}

	Compass {
		id: ari

		active: hub.active
		dataRate: hub.dataRate

		property int freshnessBit: 4

		onReadingChanged: {
			if (hub.dataFreshness & freshnessBit)
				return;
			hub.aziRaw = reading.azimuth
			hub.timestamp = new Date().getTime()
			if (debug)
				console.log(hub.dt, "ari", hub.aziRaw)
			hub.dataFreshness |= freshnessBit
		}
	}

	WebSocketServer {
		id: wServer
		name: "SenseHubServer"
		host: "0.0.0.0"
		port: hub.port
		listen: hub.active
		accept: true

		property var clients: []

		onClientConnected: {
			if (debug)
				console.log("server.onClientConnected:", webSocket)
			webSocket.onTextMessageReceived.connect(function(message) { // setting
//				if (debug)
//					console.log("server.received:", message)
				var data = JSON.parse(message)
				for (var p in data) {
					hub[p] = data[p]
				}
			});
			clients.push(webSocket)
		}

		onErrorStringChanged: {
			if (debug && errorString)
				console.log("server.errorString:", errorString)
		}
	}

	WebSocket {
		id: wClient
		active: false

		onStatusChanged: {
			if (debug)
				console.log("client(%1).onStatusChanged:".arg(url),
					["WebSockets.Connecting", "WebSockets.Open",
					"WebSockets.Closing", "WebSockets.Closed",
					"WebSockets.Error"][status])

			switch (status) {
			case WebSocket.Error:
			case WebSocket.Closed:
				hub.server = ""
				break
			case WebSocket.Open:
				var pList = ["dataRate"/*, "debug"*/] // dataRate not work???
				var r = {}
				pList.forEach(function(p){
					r[p] = hub[p]
				})
				sendTextMessage(JSON.stringify(r))
				break
			}
		}

		onTextMessageReceived: {  // data
//			if (debug)
//				console.log("client.received:", message)
			var data = JSON.parse(message)
			for (var p in data) {
				hub[p] = data[p]
			}
			ready()
		}

		onErrorStringChanged: {
			if (debug && errorString)
				console.log("client.errorString:", errorString)
		}
	}

	onServerChanged: {
//		wClient.active = false
		if (hub.server !== "") {
			wClient.active = true
			wClient.url = "ws://%1:%2".arg(hub.server).arg(hub.port)
		}
		else
			wClient.active = false
	}

	onDataFreshnessChanged: {
		if ((dataFreshness & readyBits) !== readyBits)
			return;

		ready()

		if (wServer.clients) {
			var pList = ["dt", "timestamp", "rotRaw", "accRaw", "aziRaw"]
			var r = {}
			pList.forEach(function(p){
				r[p] = hub[p]
			})
			wServer.clients.forEach(function (ws){
				ws.sendTextMessage(JSON.stringify(r))
			})
		}

		timeLast = timestamp
		dataFreshness = 0
	}

	Component.onCompleted: {
		if (!rot.hasZ) {
			console.log("Rotation sensor not work :(.")
		}
	}
}
