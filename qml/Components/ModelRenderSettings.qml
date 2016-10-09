import Qt3D.Render 2.0

RenderSettings {
	activeFrameGraph: ClearBuffers {
		buffers: ClearBuffers.ColorDepthBuffer
		clearColor: "skyblue"
		RenderSurfaceSelector {
			CameraSelector {
				camera: modelCamera
			}
		}
	}
}