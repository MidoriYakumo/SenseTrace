import QtQuick.Scene3D 2.0

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

import "Components"
import "kernel.js" as K

Scene3D {
	id: scene
	anchors.fill: parent
	//multisample: true
	focus: true
	aspects: ["logic", "input"]

	property alias rotation: phone.rotation
	property alias azimuth: phone.azimuth
	property alias position: phone.position

	property vector3d vWorldAcc: "-1,0,0"
	property vector3d vVelocity: "0,-1,0"

	Entity {
		id: rootEntity
			
		ModelRenderSettings {
		}

		ModelCamera {
			id: modelCamera
			viewport: "10x10"
		}

		InputSettings {
		}

		FlyCameraController {
			camera: modelCamera
		}

		Grid {
			size: "40x40"
			step: "1x1"
		}

		Phone {
			id: phone
			rotation: "30,30,30"
			position: "1,-1,0"
		}

		Arrow {
			value: "3,0,0"
			color: "red"
			thickness: .05
			origin: phone.position
		}

		Arrow {
			value: "0,3,0"
			color: "green"
			thickness: .05
			origin: phone.position
		}

		Arrow {
			id: aWorldAcc
			value: scene.vWorldAcc.times(.1)
			color: "coral"
			thickness: .05
			origin: phone.position
		}

		Arrow {
			id: aVelocity
			value: scene.vVelocity.times(1.)
			color: "yellow"
			thickness: .05
			origin: phone.position
		}
	}
}
