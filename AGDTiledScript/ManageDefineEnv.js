/// <reference types="@mapeditor/tiled-api" />

const ENV_FILE = "ENVIROMENT.tmx";
const PROJECT_DIR = tiled.projectFilePath.replace(/[^/]+$/, "");
// const PROJECT_DIR = FileInfo.path(tiled.projectFilePath) + "/" ;

const OUTPUT_FILE = "DEFINEWINDOW.agd";
const MAP_LIST_FILE = "MAP.world";
const CELL_SIZE = 8;
const EXCLUDED_FILE = ENV_FILE;

function getFileName(filePath) {
    return filePath.replace(/^.*[\/]/, "");
}

function loadEnvironmentMap() {
    const envPath = PROJECT_DIR + ENV_FILE;
    let envMap = tiled.open(envPath);
    if (!envMap) {
        tiled.log(`No se pudo abrir ${ENV_FILE}`);
        return null;
    }
    return envMap;
}

function getDefineWindowLayer(envMap) {
    const envGroup = envMap.layers.find(layer => layer.isGroupLayer && layer.name === "Enviroment");
    if (!envGroup) {
        tiled.log("No se encontró el grupo 'Enviroment' en el mapa.");
        return null;
    }
    return envGroup.layers.find(layer => layer.isObjectLayer && layer.name === "DEFINEWINDOW");
}

function lockTVObject(objectLayer) {
    const tvObject = objectLayer.objects.find(obj => obj.id === 5 && obj.name === "TV");
    if (tvObject) {
        tvObject.locked = true;
        tiled.log("Objeto TV bloqueado correctamente.");
    }
}

function getMapList() {
    const mapListPath = PROJECT_DIR + MAP_LIST_FILE;
    try {
        const mapFile = new TextFile(mapListPath, TextFile.ReadOnly);
        const content = mapFile.readAll();
        mapFile.close();
        const worldData = JSON.parse(content);
        return worldData.maps.map(map => map.fileName).filter(fileName => fileName !== EXCLUDED_FILE);
    } catch (error) {
        tiled.log(`Error al leer ${MAP_LIST_FILE}: ${error.message}`);
        return [];
    }
}

function readPreviousDimensions() {
    const outputPath = PROJECT_DIR + OUTPUT_FILE;
    try {
        const inputFile = new TextFile(outputPath, TextFile.ReadOnly);
        const content = inputFile.readAll().trim();
        inputFile.close();
        
        const match = content.match(/DEFINEWINDOW (\d+) (\d+) (\d+) (\d+)/);
        if (match) {
            return {
                y: parseInt(match[1]),
                x: parseInt(match[2]),
                alto: parseInt(match[3]),
                ancho: parseInt(match[4])
            };
        }
    } catch (error) {
        tiled.log(`No se pudo leer ${OUTPUT_FILE}, asumiendo dimensiones nuevas.`);
    }
    return null;
}

function resizeMapsDirectly(yCeldas, xCeldas, altoCeldas, anchoCeldas) {
    if (!tiled.confirm("Redimensionar todas las pantallas según DEFINEWINDOW?")) {
        tiled.log("Redimensionado cancelado.");
        return;
    }

    getMapList().forEach(mapFileName => {
        const mapPath = PROJECT_DIR + mapFileName;
        try {
            let mapFile = new TextFile(mapPath, TextFile.ReadOnly);
            let xmlContent = mapFile.readAll();
            mapFile.close();

            // Actualizar ancho/alto del mapa
            xmlContent = xmlContent.replace(
                /(width=")\d+(" height=")\d+(" tilewidth)/,
                `$1${anchoCeldas}$2${altoCeldas}$3`
            );

            // Modificar capa DEFINETILES
            xmlContent = xmlContent.replace(
                /(<layer[^>]+name="DEFINETILES"[^>]*width=")\d+(" height=")\d+(")/,
                `$1${anchoCeldas}$2${altoCeldas}$3`
            );

            // Modificar datos internos: buscar bloque <data>...</data> de esa capa
            xmlContent = xmlContent.replace(
                /(<layer[^>]+name="DEFINETILES"[^>]*>\s*<data[^>]*>)([^<]*)(<\/data>)/,
                (match, prefix, dataContent, suffix) => {
                    let cells = dataContent.trim().split(",").map(x => x.trim()).filter(x => x !== "");
                    let targetSize = anchoCeldas * altoCeldas;

                    if (cells.length < targetSize) {
                        cells = cells.concat(Array(targetSize - cells.length).fill("1"));
                    } else if (cells.length > targetSize) {
                        cells = cells.slice(0, targetSize);
                    }

                    return `${prefix}${cells.join(",")}${suffix}`;
                }
            );

            let newMapFile = new TextFile(mapPath, TextFile.WriteOnly);
            newMapFile.write(xmlContent);
            newMapFile.commit();

            tiled.log(`Redimensionado: ${mapFileName} a ${anchoCeldas}x${altoCeldas} celdas.`);
        } catch (error) {
            tiled.log(`Error modificando ${mapFileName}: ${error.message}`);
        }
    });
}


function saveDefineWindow(windowObject) {
    const anchoCeldas = windowObject.width / CELL_SIZE;
    const altoCeldas = windowObject.height / CELL_SIZE;
    const xCeldas = windowObject.x / CELL_SIZE;
    const yCeldas = windowObject.y / CELL_SIZE;
    const outputContent = `DEFINEWINDOW ${yCeldas} ${xCeldas} ${altoCeldas} ${anchoCeldas}\n`;
    const outputPath = PROJECT_DIR + OUTPUT_FILE;
    
    const prevDimensions = readPreviousDimensions();
    
    try {
        const outputFile = new TextFile(outputPath, TextFile.WriteOnly);
        outputFile.write(outputContent);
        outputFile.commit();
        tiled.log(`Guardado: ${OUTPUT_FILE}, DEFINEWINDOW ${yCeldas} ${xCeldas} ${altoCeldas} ${anchoCeldas}`);
        
        if (!prevDimensions || prevDimensions.ancho !== anchoCeldas || prevDimensions.alto !== altoCeldas || 
            prevDimensions.x !== xCeldas || prevDimensions.y !== yCeldas) {
            resizeMapsDirectly(yCeldas, xCeldas, altoCeldas, anchoCeldas);
        }
    } catch (error) {
        tiled.log(`Error guardando ${OUTPUT_FILE}: ${error.message}`);
    }
}

tiled.assetSaved?.connect((asset) => {
    if (getFileName(asset.fileName) !== ENV_FILE) return;
    
    let envMap = loadEnvironmentMap();
    if (!envMap) return;
    
    const defineWindowLayer = getDefineWindowLayer(envMap);
    if (!defineWindowLayer) return;
    
    lockTVObject(defineWindowLayer);
    const windowObject = defineWindowLayer.objects.find(obj => obj.id === 1 && obj.name === "WINDOW");
    if (windowObject) {
        saveDefineWindow(windowObject);
    }
});

let envMap = loadEnvironmentMap();
if (envMap) {
    const defineWindowLayer = getDefineWindowLayer(envMap);
    if (defineWindowLayer) {
        lockTVObject(defineWindowLayer);
    }
}
