package dropecho.dungen.map.extensions;

typedef Rect = {
	var x:Int;
	var y:Int;
	var width:Int;
	var height:Int;
};

/**
 * @param map - The map to search on.
 * @param fromX - The starting x coordinate.
 * @param fromY - The starting y coordinate.
 * @param valueToFind - The value to find the distance to (closest tile with this value.)
 * @param [maxDistance] - The max distance to search, will return this if further/not found.
 * @returns The distance to the closest tile with the valueToFind.
 */
function distanceToValue(map:Map2d, fromX:Int, fromY:Int, valueToFind:Int, maxDistance:Int = 10) {
	var dist = 1;
	while (dist <= maxDistance) {
		if (map.get(fromX, fromY) == valueToFind) {
			return 0;
		}

		var count = map.getNeighborCount(fromX, fromY, valueToFind, dist);

		if (count > 0) {
			return dist;
		}
		dist++;
	}

	return maxDistance;
}

/**
 * Return a portion of the map, defined by the rect.
 * @param x - The start x coord of the rectangle (top left).
 * @param y - The start y coord of the rectangle (top left).
 * @param x2 - The end x coord of the rectangle (bottom right).
 * @param y2 - The end y coord of the rectangle (bottom right).
 * @param [wrap] - Should the rectangle wrap if it hits the edge of the map.
 * @return An array of ints representing the sub section of the map.
 */
function getRect(map:Map2d, rect:Rect, wrap:Bool = false):Array<Int> {
	return [
		for (j in rect.y...rect.y + rect.height) {
			for (i in rect.x...rect.x + rect.width) {
				if (wrap) {
					map.get(i % map._width, j % map._height);
				} else {
					map.get(i, j);
				}
			}
		}
	];
}

/**
 * Set a portion of the map, defined by the rectangle.
 *
 * @param map - The map to set the portion of.
 * @param rect - The rectangle defining the portion to set.
 * @param data - The value to set each contained tile to.
 */
function setRect(map:Map2d, rect:Rect, data:Int):Void {
	for (j in rect.y...rect.y + rect.height + 1) {
		for (i in rect.x...rect.x + rect.width + 1) {
			map.set(i, j, data);
		}
	}
}

/**
 * Check if the second rectangle overlaps the first.
 * @param r1 - The first rectangle to check.
 * @param r2 - The second rectangle to check.
 * @return True if the rectangles overlap.
 */
function checkOverlap(r1:Rect, r2:Rect):Bool {
	var r1p1 = {x: r1.x, y: r1.y};
	var r1p2 = {x: r1.x + r1.width, y: r1.y + r1.height};
	var r2p1 = {x: r2.x, y: r2.y};
	var r2p2 = {x: r2.x + r2.width, y: r2.y + r2.height};

	return !(r1p1.x > r2p2.x || r2p1.x > r1p2.x || r1p1.y > r2p2.y || r2p1.y > r1p2.y);
}

/**
 * Checks if the inner rectangle is contained by the outer.
 * I.E. is it completely inside of it.
 * @param r1 - The outer rectangle. 
 * @param r2 - The inner rectangle. 
 * @return true if r2 is contained by r1
 */
function contains(r1:Rect, r2:Rect):Bool {
	var r1p1 = {x: r1.x, y: r1.y};
	var r1p2 = {x: r1.x + r1.width, y: r1.y + r1.height};
	var r2p1 = {x: r2.x, y: r2.y};
	var r2p2 = {x: r2.x + r2.width, y: r2.y + r2.height};

	return (r2p2.x < r1p2.x && r2p2.y < r1p2.y && r2p1.x > r1p1.x && r2p1.y > r1p1.y);
}

function isOverlappingArray(r1, a:Array<Dynamic>) {
	for (r in a) {
		if (r == r1) {
			continue; // Ignore itself.
		}

		if (Utils.checkOverlap(r1, r)) {
			return true;
		}
	}

	return false;
}
