import QtQuick 2.7

import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Entity {
	id: grid

	property size size: "10x10"
	property size step: "1x1"
	property color color: "purple"

	QtObject {
		id: d

		property real hWidth: grid.size.width/2
		property real hHeight: grid.size.height/2
	}

	NodeInstantiator {
		id: xArray
		model: size.width / step.width + 1
		delegate: Entity {
			LineGeometry {
				id: xLine

				p0: Qt.vector3d(-d.hWidth+index*step.width, -d.hHeight, 0)
				p1: Qt.vector3d(-d.hWidth+index*step.width, +d.hHeight, 0)
			}

			components: [xLine, material]
		}
	}

	NodeInstantiator {
		id: yArray
		model: size.height / step.height + 1
		delegate: Entity {
			LineGeometry {
				id: yLine

				p0: Qt.vector3d(-d.hWidth, -d.hHeight+index*step.height, 0)
				p1: Qt.vector3d(+d.hWidth, -d.hHeight+index*step.height, 0)
			}

			components: [yLine, material]
		}
	}

	PhongMaterial {
		id: material

		ambient: grid.color
		diffuse: "white"
		specular: "black"
	}
}
