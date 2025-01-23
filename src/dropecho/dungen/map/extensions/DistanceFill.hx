package dropecho.dungen.map.extensions;

import dropecho.ds.Stack;
import dropecho.ds.Set;
import dropecho.dungen.Map2d;

using Lambda;

@:expose("dungen.DistanceFill")
class DistanceFill {
	public static function distanceFill(
		map:Map2d,
		valueToMeasureFrom:Int = 0,
		diagonal:Bool = true,
		maxDepth:Int = 40
	) {
		var visited = new Set<Tile2d>(map.tileToIndex);
		var stack = new Stack<Tile2d>();
		var neighbors = new Array<Tile2d>();
		var distanceMap = new Map2d(map._width, map._height);

		for (tile in map) {
			if (tile.val == valueToMeasureFrom) {
				stack.push(tile);
				distanceMap.set(tile.x, tile.y, 0);
			} else {
				distanceMap.set(tile.x, tile.y, maxDepth);
			}
		}

		while (stack.length > 0) {
			var current = stack.pop();
			visited.add(current);

			neighbors = distanceMap.getNeighbors(current.x, current.y, 1, diagonal);

			if (current.val == maxDepth) {
				var lowest = Std.int(neighbors.fold((
					t,
					val
				) -> Math.min(t.val, val), maxDepth + 1));
				distanceMap.set(current.x, current.y, Std.int(Math.min(lowest + 1, maxDepth)));
			}

			stack.pushMany(neighbors.filter(t -> !visited.exists(t)));
		}

		return distanceMap;
	}

	public static function seep(
		map:Map2d,
		valueToMeasureFrom:Int = 0,
		diagonal:Bool = true,
		maxDepth:Int = 40
	) {
		var stack = new Stack<Tile2d>();
		var neighbors = new Array<Tile2d>();
		var distanceMap = map.clone();

		for (tile in map) {
			if (tile.val == 2) {
				stack.push(tile);
			}
		}

		while (stack.length > 0) {
			var current = stack.pop();

			neighbors = distanceMap.getNeighbors(current.x, current.y, 1, diagonal);
			for (n in neighbors) {
				if (n.val == 1) {
					distanceMap.set(n.x, n.y, 2);
				}
			}
		}

		return distanceMap;
	}
}
