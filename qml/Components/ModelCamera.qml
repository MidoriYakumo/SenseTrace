import QtQuick 2.7

import Qt3D.Render 2.0

Camera {
	property size viewport: "1x1"

	QtObject {
		id: d

		property real viewScale: Math.min(scene.width/viewport.width, scene.height/viewport.height) * 2
	}

	right: scene.width/d.viewScale
	top: scene.height/d.viewScale
	left: -right
	bottom: -top

	projectionType: CameraLens.OrthographicProjection
	position: "0,0,1"
	viewCenter: "0,0,0"
	upVector: "0,1,0"
//	nearPlane: -1
}
