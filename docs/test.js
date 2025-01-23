var ctx = document.querySelector('#canvas').getContext('2d');
var buttons = document.querySelector('#buttons');

console.log(dungen);

function makeButton(func) {
  var button = document.createElement('button');
  button.innerText = func.name;
  button.onclick = func;
  buttons?.appendChild(button);
}

let colors;
let mapScale = 6;
var mapWidth = 128;
var mapHeight = 128;

function drawMap(map) {
  ctx.clearRect(0, 0, 1024, 1024);

  map._mapData.forEach(function (tile, i) {
    var pos = map.IndexToXY(i);
    ctx.fillStyle = colors[tile];
    ctx.fillRect(pos.x * mapScale, pos.y * mapScale, mapScale, mapScale);
  });
}

var bsp = new dungen.BSPGenerator({
  height: mapWidth,
  width: mapHeight,
  depth: 5,
  //   ratio: 0.7,
  minWidth: 10,
  minHeight: 10,
});

var roomGenParams = {
  padding: 2,
  minWidth: 10,
  minHeight: 10,
};

var caparam = new dungen.CA_PARAMS();
caparam.width = mapWidth;
caparam.height = mapHeight;
caparam.useOtherType = false;
caparam.start_fill_percent = 62;
caparam.steps[0].invert = true;
caparam.steps[1].invert = true;

let seed = '0';
let generatedMap = null;

function generateColorsGrayscale() {
  colors = [];
  var start = [1, 2, 3, 4, 5, 6, 7, 8, 9, 'a', 'b', 'c', 'd', 'e', 'f'];
  var second = [0, 9];

  for (var s of start) {
    for (var sec of second) {
      colors.push(`#${s}${sec}${s}${sec}${s}${sec}`);
    }
  }
}

let cacheColors = {};
function generateRandomColors(depth = 2) {
  if (cacheColors[depth]) {
    colors = cacheColors[depth];
    return;
  }

  colors = [];
  for (var i = 0; i < 512; i++) {
    colors.push('#' + Math.random().toString(16).substr(2, 6));
  }
  colors[0] = '#000';
  for (var i = 1; i < depth; i++) {
    colors[i] = '#777';
  }

  cacheColors[depth] = [...colors];
}
function generateNewSeed() {
  seed = Math.round(Math.random() * 99999999).toString();
  colors = ['#333', '#aaa', '#000'];
  generate();
  drawMap(generatedMap);
}

function generate() {
  bsp.seed = seed;
  caparam.seed = seed;
  generatedMap = dungen.RoomGenerator.buildRooms(bsp.generate(), roomGenParams);

  console.log(generatedMap);
  //   generatedMap = dungen.CAGenerator.generate(caparam);
  return generatedMap;
}

function distanceFill() {
  generate();
  for (var i = 0; i < generatedMap._mapData.length; i++) {
    generatedMap._mapData[i] = generatedMap._mapData[i] == 2 ? 0 : generatedMap._mapData[i];
  }
  var distanceMap = dungen.DistanceFill.distanceFill(generatedMap);

  generateColorsGrayscale();
  drawMap(distanceMap);
}

function seep() {
  generate();
  generatedMap = generatedMap || generate();
  var distanceMap = dungen.DistanceFill.distanceFill(generatedMap);
  distanceMap = dungen.DistanceFill.seep(distanceMap);

  generateColorsGrayscale();
  drawMap(distanceMap);
}

let regionDepth = 2;
function regions() {
  generate();
  let regionMap = new dungen.RegionMap(generatedMap, regionDepth);

  generateRandomColors(regionDepth);
  drawMap(regionMap);
}

function removeIslands() {
  generate();
  let islandMap = dungen.RegionManager.removeIslandsBySize(generatedMap, 8);
  let regionMap = new dungen.RegionMap(islandMap, regionDepth);

  generateRandomColors(regionDepth);
  drawMap(regionMap);
}

function removeIslandsAndFillAlcoves() {
  generate();
  let regionMap = new dungen.RegionMap(generatedMap, regionDepth);
  regionMap = dungen.RegionManager.fillAlcoves(regionMap, regionDepth);

  generateRandomColors(regionDepth);
  drawMap(regionMap);
}

makeButton(generateNewSeed);
makeButton(distanceFill);
makeButton(seep);
makeButton(regions);
makeButton(removeIslands);
makeButton(removeIslandsAndFillAlcoves);
