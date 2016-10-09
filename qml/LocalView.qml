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
	property alias rotation: phone.rotation
	property alias azimuth: phone.azimuth

	property vector3d vLocalAcc: "1,1,1"
	property vector3d vWorldAcc: "-1,0,0"
	property vector3d vVelocity: "0,-1,0"

	Entity {
		id: rootEntity
			
		ModelRenderSettings {
		}

		ModelCamera {
			id: modelCamera
			
			position: phone.localMatrix.times(Qt.vector3d(0,0,1))
			upVector: phone.localMatrix.times(Qt.vector3d(0,1,0))
		}

		Grid {
			size: "5x5"
			step: ".1x.1"
		}

		Phone {
			id: phone
			rotation: "30,30,30"
		}

		Arrow {
			value: ".5,0,0"
			color: "red"
		}

		Arrow {
			value: "0,.5,0"
			color: "green"
		}

		Arrow {
			value: "0,0,.5"
			color: "blue"
		}

		Arrow {
			id: aLocalAcc
			value: phone.localMatrix.times(scene.vLocalAcc).times(.05)
			color: "teal"
		}

		Arrow {
			id: aWorldAcc
			value: scene.vWorldAcc.times(.05)
			color: "coral"
		}

		Arrow {
			id: aVelocity
			value: scene.vVelocity.times(.1)
			color: "yellow"
		}
	}
}
