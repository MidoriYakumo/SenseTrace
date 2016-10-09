import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import "kernel.js" as K

Item {
	id: root
	height: 800
	width: 450

	property matrix4x4 phoneLocalMatrix

	SensorHub {
		id: hub

		debug: false
		onReady: {
//			K.fuseDirection(hub.rotation, hub.azimuth, hub.dt)
//			K.transformAcceleration(hub.acceleration)
			K.acceleration = phoneLocalMatrix.times(hub.acceleration).minus(K.accRef)
			K.sim1step(hub.dt)

			kernelBinding.direction = K.direction
			kernelBinding.acceleration = K.acceleration
			kernelBinding.velocity = K.velocity
			kernelBinding.position = K.position
		}
	}

	Item {
		id: kernelBinding

		property vector3d direction
		property vector3d acceleration
		property vector3d velocity
		property vector3d position
	}

	Loader {
		id: view3d
		anchors.fill: parent
		sourceComponent: hub.active?localView:worldView //nearView
	}

	Rectangle {
//		anchors.fill: infoGrid
//		anchors.margins: -8
		anchors.top: infoGrid.top
		width: parent.width
		height: infoGrid.height + 8
		color: "#a0ececec"
	}

	GridLayout {
		id: infoGrid
		anchors {
			horizontalCenter: parent.horizontalCenter
			top: parent.top
			margins: 8
		}

		columns: 6

		Text {
			text: "URL:%1".arg(hub.url)
			Layout.columnSpan: 6
			Layout.alignment: Qt.AlignHCenter
		}

		Text {
			text: "ROT:%1".arg(K.v3d2str(hub.rotation))
			Layout.columnSpan: 3
		}

		Text {
			text: "LAC:%1".arg(K.v3d2str(hub.acceleration))
			Layout.columnSpan: 3
		}

		Text {
			text: "WAC:%1".arg(K.v2d2str(kernelBinding.acceleration))
			Layout.columnSpan: 2
		}

		Text {
			text: "VEL:%1".arg(K.v2d2str(kernelBinding.velocity))
			Layout.columnSpan: 2
		}

		Text {
			text: "POS:%1".arg(K.v2d2str(kernelBinding.position))
			Layout.columnSpan: 2
		}
	}

//	Rectangle {
//		anchors.fill: controlGrid
//		anchors.margins: -8
//		color: "#a0ececec"
//	}

	GridLayout {
		id: controlGrid
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
			margins: 8
		}

		columns: 12

		Button {
			text: "DIR"
			onClicked: hub.calibDirection()
			Layout.columnSpan: 3
		}

		Button {
			text: "ACC" // WAC
			onClicked: {
				hub.calibAcceleration()
				K.accRef = K.accRef.plus(K.acceleration)
			}
			Layout.columnSpan: 3
		}

		Button {
			text: "VEL"
			onClicked: K.velocity = Qt.vector3d(0,0,0)
			Layout.columnSpan: 3
		}

		Button {
			text: "POS"
			onClicked: K.position = Qt.vector3d(0,0,0)
			Layout.columnSpan: 3
		}

		Button {
			text: "ALL"
			onClicked: {
				hub.calibAll()
				K.acceleration = Qt.vector3d(0,0,0)
				K.velocity = Qt.vector3d(0,0,0)
				K.position = Qt.vector3d(0,0,0)
			}
			Layout.columnSpan: 3
		}

		TextField {
			id: serverIp
			Layout.columnSpan: 6
			Layout.fillWidth: true
		}

		Button {
			text: "Connect"
			enabled: hub.server === ""
			Layout.columnSpan: 3
			onClicked: hub.server = serverIp.text
		}
	}

	Settings {
		id: settings
		property alias server: serverIp.text
	}


	Component {
		id: nearView
		NearView {
			rotation: hub.rotation
			azimuth: hub.azimuth
			vLocalAcc: hub.acceleration
			vWorldAcc: kernelBinding.acceleration
			vVelocity: kernelBinding.velocity
		}
	}

	Component {
		id: localView
		LocalView {
			rotation: hub.rotation
			azimuth: hub.azimuth
			vLocalAcc: hub.acceleration
			vWorldAcc: kernelBinding.acceleration
			vVelocity: kernelBinding.velocity
		}
	}

	Component {
		id: worldView
		WorldView {
			rotation: hub.rotation
			azimuth: hub.azimuth
			position: kernelBinding.position
			vWorldAcc: kernelBinding.acceleration
			vVelocity: kernelBinding.velocity
		}
	}

	Component.onCompleted: {
		if (settings.server) {
			hub.server = serverIp.text
		}
	}
}
