//.pragma library

function d2r(x) {
	return x * Math.PI / 180
}

function r2d(x) {
	return x * 180 / Math.PI
}

function float2str(f, w) {
	if (w === undefined)
		w = 6
	var d = f>0?w:w-1
	var a = Math.abs(f)
	var r = a>=Math.pow(10,d)?f.toPrecision(d-4):a<Math.pow(10,3-d)?f.toExponential(d-4):f.toFixed(d).slice(0,w)
	while (r.length<w)
		r = ' ' + r
	return r
}

function v2d2str(v) {
	var w = 6
	return "[%1,%2]".arg(float2str(v.x, w)).arg(float2str(v.y, w))
}

function v3d2str(v) {
	var w = 5
	return "[%1,%2,%3]".arg(float2str(v.x, w)).arg(float2str(v.y, w)).arg(float2str(v.z, w))
}

var direction = Qt.vector3d(0,0,0)
var acceleration = Qt.vector3d(0,0,0)
var accRef = Qt.vector3d(0,0,0)
var velocity = Qt.vector3d(0,0,0)
var position = Qt.vector3d(0,0,0)

function fuseDirection(rotation, azimuth, dt) {
	direction = rotation
}

function transformAcceleration(lAcc) {
	acceleration = lAcc
}

var slowRatio = 1.

function sim1step(dt) {
	dt = dt / 1e3 / slowRatio
	var a = acceleration
	a.z = 0
	velocity = velocity.plus(a.times(dt))
	position = position.plus(velocity.times(dt))
}
