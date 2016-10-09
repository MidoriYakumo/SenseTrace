import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

ApplicationWindow {
	id: app
	visible: true
	width: 450
	height: 800 + header.height

	header: ToolBar {
		contentItem: RowLayout {
			Text {
				text: "SenseTrace"
				color: "white"
				height: parent.height
				font.pixelSize: height *.5
				verticalAlignment: Qt.AlignVCenter
				padding: 6

				Layout.fillWidth: true
			}

			Text {
				text: "%1fps".arg(app.fps.toFixed(1))
				color: "white"
				height: parent.height
				font.pixelSize: height *.4
				verticalAlignment: Qt.AlignVCenter
				padding: 6
			}
		}
	}

	property real timeNow
	property real timeLast
	property real fps
	property int frameCount

	onFrameSwapped: {
		frameCount ++
		if (frameCount>20) {
			timeNow = new Date().getTime()
			fps = 1e3 * frameCount / (timeNow - timeLast + 1)
			timeLast = timeNow
			frameCount = 0
		}
	}

	Root {
		anchors.fill: parent
	}

}
