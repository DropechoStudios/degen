package dropecho.dungen.map.extensions;

import dropecho.dungen.Map2d;
import dropecho.dungen.map.extensions.Utils.distanceToValue;

function distanceFill(map:Map2d, valueToFind:Int = 0, maxDistance:Int = 10) {
	var distanceMap = new Map2d(map._width, map._height);

	for (x in 0...distanceMap._width) {
		for (y in 0...distanceMap._height) {
			var dist = distanceToValue(map, x, y, valueToFind, maxDistance);
			distanceMap.set(x, y, dist);
		}
	}

	return distanceMap;
}
// function seep(map:Map2d, valueToMeasureFrom:Int = 0, diagonal:Bool = true, maxDepth:Int = 40) {
//   var stack = new Stack<Tile2d>();
//   var neighbors = new Array<Tile2d>();
//   var distanceMap = map.clone();
//
//   for (tile in map) {
//     if (tile.val == 2) {
//       stack.push(tile);
//     }
//   }
//
//   while (stack.length > 0) {
//     var current = stack.pop();
//
//     neighbors = distanceMap.getNeighbors(current.x, current.y, 1, diagonal);
//     for (n in neighbors) {
//       if (n.val == 1) {
//         distanceMap.set(n.x, n.y, 2);
//       }
//     }
//   }
//
//   return distanceMap;
// }
