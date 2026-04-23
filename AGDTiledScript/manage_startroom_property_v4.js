/// <reference types="@mapeditor/tiled-api" />

const MAP_LIST_FILE = "MAP.world";
const PROJECT_DIR = tiled.projectFilePath ? tiled.projectFilePath.replace(/[^\/]+$/, "") + "" : "";
const ENVIROMENT_FILE = PROJECT_DIR + "ENVIROMENT.tmx";
const START_ROOM_PROPERTY = "StartRoom";
const DEFAULT_START_ROOM = "SCREEN000.tmx";

let updatingStartRoom = false;

function getFileName(filePath) {
    return filePath.replace(/^.*[\/]/, "");
}

function getMapList() {
    try {
        let mapFile = new TextFile(PROJECT_DIR + MAP_LIST_FILE, TextFile.ReadOnly);
        let content = JSON.parse(mapFile.readAll());
        mapFile.close();
        return content.maps.map(map => map.fileName);
    } catch (error) {
        tiled.log(`Error al leer ${MAP_LIST_FILE}: ${error.message}`);
        return [];
    }
}

function getStartRoomFromEnvironment() {
    try {
        let envFile = new TextFile(ENVIROMENT_FILE, TextFile.ReadOnly);
        let match = envFile.readAll().match(/<property name="Nombre" value="(.*?)"/);
        envFile.close();
        return match ? match[1] : DEFAULT_START_ROOM;
    } catch (error) {
        tiled.log(`Error obteniendo StartRoom de ENVIROMENT.tmx: ${error.message}`);
        return DEFAULT_START_ROOM;
    }
}

function updateEnvironmentFile(mapName) {
    try {
        let envFile = new TextFile(ENVIROMENT_FILE, TextFile.ReadOnly);
        let xmlContent = envFile.readAll();
        envFile.close();

        if (xmlContent.includes(`value="${mapName}"`)) {
            tiled.log(`ENVIROMENT.tmx ya está actualizado (${mapName}). No se modifica.`);
            return;
        }

        xmlContent = xmlContent.replace(/(<property name="Nombre" value=")(.*?)"/, `$1${mapName}"`);

        let newEnvFile = new TextFile(ENVIROMENT_FILE, TextFile.WriteOnly);
        newEnvFile.write(xmlContent);
        newEnvFile.commit();
        tiled.log(`ENVIROMENT.tmx actualizado con StartRoom: ${mapName}`);
    } catch (error) {
        tiled.log(`Error actualizando ENVIROMENT.tmx: ${error.message}`);
    }
}

function ensureOnlyOneStartRoom() {
    if (updatingStartRoom) return;
    updatingStartRoom = true;

    let mapFiles = getMapList();
    let enviromentMap = getStartRoomFromEnvironment();
    let changesMade = false;

    mapFiles.forEach(mapFileName => {
        try {
            let mapFilePath = PROJECT_DIR + mapFileName;
            let mapFile = new TextFile(mapFilePath, TextFile.ReadOnly);
            let xmlContent = mapFile.readAll();
            mapFile.close();

            let shouldBeTrue = (mapFileName === enviromentMap);
            let previousValue = xmlContent.match(/<property name="StartRoom" value="(true|false)"/);

            if (previousValue && previousValue[1] === String(shouldBeTrue)) return;

            changesMade = true;

            xmlContent = xmlContent.replace(
				/(<property name="StartRoom"(?: type="bool")? value=")(true|false)"/,
				`$1${shouldBeTrue}"`
			);


            let newMapFile = new TextFile(mapFilePath, TextFile.WriteOnly);
            newMapFile.write(xmlContent);
            newMapFile.commit();
            tiled.log(`${shouldBeTrue ? "✅" : "🔴"} StartRoom en ${mapFileName} → ${shouldBeTrue}`);

            // 🔍 Verificación posterior a la escritura
            let verifyFile = new TextFile(mapFilePath, TextFile.ReadOnly);
            let verifyContent = verifyFile.readAll();
            verifyFile.close();

            let verifiedValue = verifyContent.match(/<property name="StartRoom"(?: type="bool")? value="(true|false)"/);
            if (verifiedValue) {
                if (verifiedValue[1] === String(shouldBeTrue)) {
                    tiled.log(`🔍 Verificado correctamente: StartRoom en ${mapFileName} es ${verifiedValue[1]}`);
                } else {
                    tiled.log(`⚠ Error de verificación: se esperaba ${shouldBeTrue}, pero quedó como ${verifiedValue[1]} en ${mapFileName}`);
                }
            } else {
                tiled.log(`⚠ No se encontró la propiedad StartRoom en ${mapFileName} tras guardar`);
            }

        } catch (error) {
            tiled.log(`❌ Error modificando ${mapFileName}: ${error.message}`);
        }
    });

    if (changesMade) {
        tiled.log(`✔ Se ha asegurado que solo un mapa tenga StartRoom activo.`);
    } else {
        tiled.log(`🔹 No fue necesario cambiar ningún StartRoom.`);
    }

    updatingStartRoom = false;
}

tiled.assetSaved?.connect((asset) => {
    if (updatingStartRoom) return;

    const fileName = getFileName(asset.fileName);
    if (fileName === getFileName(ENVIROMENT_FILE) || typeof asset.setProperty !== "function") return;

    let currentStartRoom = getStartRoomFromEnvironment();
    let startRoomProperty = asset.property(START_ROOM_PROPERTY);

    let isStartRoomNow = startRoomProperty === true;
    let wasStartRoomBefore = (currentStartRoom === fileName);

    console.log(`DEBUG: Guardado ${fileName} | Propiedad actual: ${startRoomProperty} | Booleano: ${isStartRoomNow} | Antes: ${wasStartRoomBefore}`);

    if (isStartRoomNow && !wasStartRoomBefore) {
        tiled.log(`✔ ${fileName} ahora es StartRoom.`);
        updateEnvironmentFile(fileName);
        ensureOnlyOneStartRoom();
    } else if (!isStartRoomNow && wasStartRoomBefore) {
        tiled.log(`✔ ${fileName} ya no es StartRoom. Se actualizará.`);
        updateEnvironmentFile(DEFAULT_START_ROOM);
        ensureOnlyOneStartRoom();
    } else {
        tiled.log("🔹 No hubo cambios en StartRoom. No se actualiza.");
    }
});
