import QtQuick 2.7

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

import "../kernel.js" as K

Entity {
	id: arrow

	property vector3d origin
	property vector3d value
	property real thickness: .01
	property color color: "red"

	QtObject {
		id: d
		
		property real length: arrow.value.length()
	}

	Entity {
		id: rod

		CuboidMesh {
			id: rodMesh

			xExtent: Math.max(d.length, arrow.thickness)
			yExtent: arrow.thickness
			zExtent: arrow.thickness
		}

		Transform {
			id: rodTransform

			translation: arrow.origin.plus(arrow.value.times(.5))
			rotation: fromAxisAndAngle(Qt.vector3d(1,0,0)
				.crossProduct(arrow.value),
				K.r2d(Math.acos(Qt.vector3d(1,0,0)
				.dotProduct(arrow.value)/d.length)))

		}

		components: [rodMesh, rodTransform, material]
	}

	Entity {
		id: cone

		ConeMesh {
			id: coneMesh

			length: 3
			rings: 2
			slices: 4
		}

		Transform {
			id: coneTransform

			translation: arrow.origin.plus(
				arrow.value.times(1.-arrow.thickness/d.length)
			)
			rotation: fromAxesAndAngles(Qt.vector3d(0,0,1), -90,
				Qt.vector3d(1,0,0).crossProduct(arrow.value),
				K.r2d(Math.acos(Qt.vector3d(1,0,0)
				.dotProduct(arrow.value)/d.length)))
			scale: arrow.thickness * 2
		}

		components: [coneMesh, coneTransform, material]
	}

	PhongMaterial {
		id: material

		ambient: arrow.color
		diffuse: "white"
		specular: "black"
	}

}
