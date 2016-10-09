import Qt3D.Core 2.0
import Qt3D.Render 2.0

GeometryRenderer {
	id: geometry

	property vector3d p0
	property vector3d p1

	primitiveType: GeometryRenderer.Lines
	geometry: Geometry {
		boundingVolumePositionAttribute: vertexPosition

		Attribute {
			id: vertexPosition
			attributeType: Attribute.VertexAttribute
			vertexBaseType: Attribute.Float
			vertexSize: 3
			count: 2
			byteOffset: 0
			byteStride: 4 * 6
			name: defaultPositionAttributeName()
			buffer: vertexBuffer
		}

		Attribute {
			id: vertexNormal
			attributeType: Attribute.VertexAttribute
			vertexBaseType: Attribute.Float
			vertexSize: 3
			count: 2
			byteOffset: 4 * 3
			byteStride: 4 * 6
			name: defaultNormalAttributeName()
			buffer: vertexBuffer
		}
	}

	Buffer {
		id: vertexBuffer

		property vector3d d01: p1.minus(p0)

		type: Buffer.VertexBuffer
		data: new Float32Array([
			geometry.p0.x, geometry.p0.y, geometry.p0.z, 0, 0, 0,
			geometry.p1.x, geometry.p1.y, geometry.p1.z, 0, 0, 0
//			geometry.p0.x, geometry.p0.y, geometry.p0.z, -d01.x, -d01.y, -d01.z,
//			geometry.p1.x, geometry.p1.y, geometry.p1.z, d01.x, d01.y, d01.z
		])
	}
}
