import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Extras 2.0

Entity {
	id: phone

	property vector3d rotation
	property vector3d position
	property real azimuth

	property alias localMatrix: phoneTransform.matrix

	onLocalMatrixChanged: {
		root.phoneLocalMatrix = phone.localMatrix // direct pass to root
	}

	Entity {
		id: board

		CuboidMesh {
			id: phoneMesh

			xExtent: .4
			yExtent: .8
			zExtent: .06
		}

		Transform {
			id: phoneTransform

			translation: phone.position
			rotation: fromAxesAndAngles(
				Qt.vector3d(1,0,0), phone.rotation.x,
				Qt.vector3d(0,1,0), phone.rotation.y,
				Qt.vector3d(0,0,1), phone.rotation.z//+phone.azimuth
			)
		}

		PhongMaterial {
			id: phoneMaterial

			ambient: "#2e2e2e"
			diffuse: "#999999"
			specular: "black"
//			shininess: 2.
		}

		components: [phoneMesh, phoneTransform, phoneMaterial]

		Entity {
			id: screen

			PlaneMesh {
				id: screenMesh

				width: .36
				height: .64
			}

			Transform {
				id: screenTransform

				translation: Qt.vector3d(0, .05, phoneMesh.zExtent/2+1e-4)
				rotation: fromAxisAndAngle(Qt.vector3d(1,0,0), 90)
			}

			DiffuseMapMaterial {
				id: screenMaterial

				diffuse: "textures/home.png"
				ambient: "#e3e3e3"
				specular: "white"
				shininess: 12.
			}

			components: [screenMesh, screenTransform, screenMaterial]
		}
	}
}
