#include "LanguageManager.h"

LanguageManager& LanguageManager::instance() {
    static LanguageManager instance;
    return instance;
}

LanguageManager::LanguageManager() {
    currentLanguage = "en";
    
    languageNames["en"] = "🇺🇸 English";
    languageNames["es_ve"] = "🇻🇪 Español (VE)";
    languageNames["fr"] = "🇫🇷 Français";
    
    QMap<QString, QString> en;
    en["drag_drop"] = "Drag & Drop PKG Folder Here";
    en["start_merge"] = "START MERGE";
    en["merging"] = "MERGING...";
    en["console_output"] = "Console Output";
    en["output_label"] = "Output:";
    en["same_as_input"] = "Same as Input folder";
    en["change_btn"] = "Change";
    en["ready"] = "Ready to merge";
    en["select_manually"] = "Or Select Folder manually";
    en["select_output"] = "Select Output Folder";
    en["waiting"] = "Waiting for folder...";
    en["eta"] = "ETA:";
    en["success"] = "Merge completed successfully!";
    en["err_code"] = "Merge failed with code";
    en["failed_run"] = "Failed to run CLI:";
    
    QMap<QString, QString> es_ve;
    es_ve["drag_drop"] = "Arrastra y suelta la carpeta PKG aquí";
    es_ve["start_merge"] = "INICIAR UNIÓN";
    es_ve["merging"] = "UNIENDO...";
    es_ve["console_output"] = "Salida de Consola";
    es_ve["output_label"] = "Salida:";
    es_ve["same_as_input"] = "Igual que la carpeta de entrada";
    es_ve["change_btn"] = "Cambiar";
    es_ve["ready"] = "Listo para unir";
    es_ve["select_manually"] = "O selecciona la carpeta manualmente";
    es_ve["select_output"] = "Selecciona la carpeta de salida";
    es_ve["waiting"] = "Esperando carpeta...";
    es_ve["eta"] = "Tiempo restante:";
    es_ve["success"] = "¡Unión completada exitosamente!";
    es_ve["err_code"] = "La unión falló con el código";
    es_ve["failed_run"] = "Fallo al ejecutar CLI:";

    QMap<QString, QString> fr;
    fr["drag_drop"] = "Glissez et déposez le dossier PKG ici";
    fr["start_merge"] = "DÉMARRER LA FUSION";
    fr["merging"] = "FUSION...";
    fr["console_output"] = "Sortie de la console";
    fr["output_label"] = "Sortie :";
    fr["same_as_input"] = "Identique au dossier d'entrée";
    fr["change_btn"] = "Modifier";
    fr["ready"] = "Prêt à fusionner";
    fr["select_manually"] = "Ou sélectionnez un dossier manuellement";
    fr["select_output"] = "Sélectionner le dossier de sortie";
    fr["waiting"] = "En attente du dossier...";
    fr["eta"] = "Temps restant :";
    fr["success"] = "Fusion terminée avec succès !";
    fr["err_code"] = "La fusion a échoué avec le code";
    fr["failed_run"] = "Échec de l'exécution de la CLI :";

    translations["en"] = en;
    translations["es_ve"] = es_ve;
    translations["fr"] = fr;
}

QString LanguageManager::get(const QString& key) const {
    if (translations[currentLanguage].contains(key))
        return translations[currentLanguage][key];
    if (translations["en"].contains(key))
        return translations["en"][key];
    return key;
}

void LanguageManager::setLanguage(const QString& langCode) {
    if (currentLanguage != langCode) {
        currentLanguage = langCode;
        emit languageChanged();
    }
}

QStringList LanguageManager::availableLanguages() const {
    return languageNames.keys();
}

QString LanguageManager::languageName(const QString& langCode) const {
    return languageNames.value(langCode, langCode);
}
