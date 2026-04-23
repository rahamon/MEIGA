let ExportAGDCommand = tiled.registerAction("CompilaAGD", function(action) {
	const project = tiled.project;
	if (!project) {
		tiled.alert("No hay proyecto cargado.");
		return;
	}

	const projectDir = FileInfo.path(tiled.projectFilePath);
	const batPath = projectDir + "/GeneraAGD.bat";
	/* const resultadoPath = projectDir + "/Resultado.txt"; */
	

	tiled.log("Compilando AGD");

	const proc = new Process();
	proc.start(batPath);

});

ExportAGDCommand.text = "Compila AGD";
ExportAGDCommand.icon = "./meiga-ico.png";

tiled.extendMenu("File", [
	{ action: "CompilaAGD", before: "Save" },
	{ separator: true }
]);

let ReordenarAGDCommand = tiled.registerAction("SortBlocks", function(action) {
	const projectDir = FileInfo.path(tiled.projectFilePath);
	const batPath = projectDir + "/ReordenaBlocks.bat";

	tiled.log("Reordenando Bloques");

	const proc = new Process();
	proc.start(batPath);
});

ReordenarAGDCommand.text = "Reordena Bloques";
ReordenarAGDCommand.icon = "./meiga-ico.png";
ReordenarAGDCommand.enabled = false;

let ArmonyAGDCommand = tiled.registerAction("UpdateArmony", function(action) {
	const projectDir = FileInfo.path(tiled.projectFilePath);
	const batPath = projectDir + "/ActualizaPalette.bat";

	tiled.log("Creando Paleta");

	const proc = new Process();
	proc.start(batPath);
});
ArmonyAGDCommand.text = "Armoniza Colores";
ArmonyAGDCommand.icon = "./meiga-ico.png";
ArmonyAGDCommand.enabled = false;

// Mostrar ambos en el menú Tileset (el sistema los oculta si no están habilitados)
tiled.extendMenu("Tileset", [
	{ action: "UpdateArmony" },
	{ action: "SortBlocks" }
]);

// Actualizar disponibilidad según el asset activo
function actualizarMenuTileset() {
	const asset = tiled.activeAsset;

	if (asset && asset.fileName && asset.fileName.endsWith("Palette.tsx")) {
		ArmonyAGDCommand.enabled = true;
		ReordenarAGDCommand.enabled = false;
	} else if (asset && asset.fileName && asset.fileName.endsWith(".tsx")) {
		ArmonyAGDCommand.enabled = false;
		ReordenarAGDCommand.enabled = true;
	} else {
		ArmonyAGDCommand.enabled = false;
		ReordenarAGDCommand.enabled = false;
	}
}

// Ejecutar al inicio
actualizarMenuTileset();

// Ejecutar cuando cambie el asset activo
tiled.activeAssetChanged.connect(actualizarMenuTileset);
