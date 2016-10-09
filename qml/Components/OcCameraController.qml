import Qt3D.Core 2.0
import Qt3D.Render 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0

Entity {
	id: root

	property Camera camera

	KeyboardDevice {
		id: keyboard
	}

	LogicalDevice {
		enabled: true
		actions: Action {
			id: click
			ActionInput {
				sourceDevice: mouse
				buttons: [MouseEvent.LeftButton]
			}
		}
		axes: [
			Axis {
				id: xAxis
				AnalogAxisInput {
					sourceDevice: mouse
					axis: MouseDevice.X
				}
			}, 
			Axis {
				id: yAxis
				AnalogAxisInput {
					sourceDevice: mouse
					axis: MouseDevice.Y
				}
			}
		]
	}

	MouseDevice {
		id: mouse
		sensitivity: 0.05
	}

	FrameAction {
		id: frameAction

		onTriggered: {
			if (click.active) {
				root.camera.panAboutViewCenter(xAxis.value * -1e2 * dt)
				root.camera.tiltAboutViewCenter(yAxis.value * -1e2 * dt)
			}
		}
	}
}
