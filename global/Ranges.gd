extends Node

func circAdd(from, to, _min = 0, _max = 2 * PI):
	var res = from + to
	var _range = _max - _min
	while res >= _max:
		res -= _range
	while res < _min:
		res += _range
	return res
	
func circSub(from, to, _min = 0, _max = 2 * PI):
	var res = from - to
	var _range = _max - _min
	while res >= _max:
		res -= _range
	while res < _min:
		res += _range
	return res

func circShortestDist(from, to, _min = 0, _max = 2 * PI):
	var a = circSub(to, from, _min, _max)
	var b = circSub(from, to, _min, _max)
	return min(a, b)
	
func circShortestDiff(from, to, _min = 0, _max = 2 * PI):
	var a = circSub(to, from, _min, _max)
	var b = circSub(from, to, _min, _max)
	if b > a:
		return a
	else:
		return -b
