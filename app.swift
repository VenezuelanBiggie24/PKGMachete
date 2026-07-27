import SwiftUI
import UniformTypeIdentifiers

@main
struct PKGMacheteApp: App {
    @StateObject private var lang = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(lang)
                .frame(minWidth: 700, minHeight: 500)
                .background(Color.black)
        }
        .windowResizability(.contentSize)
    }
}

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String = "en"
    
    let availableLanguages = [
        ("en", "English", "🇺🇸"),
        ("es_ve", "Español (VE)", "🇻🇪"),
        ("fr", "Français", "🇫🇷"),
        ("pt_br", "Português (BR)", "🇧🇷"),
        ("pt_pt", "Português (PT)", "🇵🇹"),
        ("ar", "العربية", "🇸🇦"),
        ("de", "Deutsch", "🇩🇪"),
        ("zh", "中文", "🇨🇳"),
        ("ja", "日本語", "🇯🇵"),
        ("ko", "한국어", "🇰🇷"),
        ("vi", "Tiếng Việt", "🇻🇳"),
        ("it", "Italiano", "🇮🇹"),
        ("eo", "Esperanto", "🟩"),
        ("hi", "हिन्दी", "🇮🇳"),
        ("tl", "Tagalog", "🇵🇭")
    ]
    
    func get(_ key: String) -> String {
        return translations[currentLanguage]?[key] ?? translations["en"]?[key] ?? key
    }
    
    private let translations: [String: [String: String]] = [
        "en": [
            "drag_drop": "Drag & Drop PKG Folder Here",
            "start_merge": "START MERGE",
            "merging": "MERGING...",
            "console_output": "Console Output",
            "output_label": "Output:",
            "same_as_input": "Same as Input folder",
            "change_btn": "Change",
            "ready": "Ready to merge",
            "select_manually": "Or Select Folder manually",
            "select_output": "Select Output Folder",
            "waiting": "Waiting for folder...",
            "starting": "Starting merge...",
            "calc_eta": "Calculating ETA...",
            "err_cli": "Error: CLI tool not found in app bundle.",
            "success": "Merge completed successfully!",
            "err_code": "Merge failed with code",
            "failed_run": "Failed to run CLI:",
            "eta": "ETA:",
            "credits": "Credits",
            "orig_engine": "Original C++ Engine by:",
            "macos_app": "macOS App by:",
            "close": "CLOSE",
            "bio": "Enthusiastic self-taught developer, Venezuelan living around the world thanks to a dictatorship that expelled me from my own country.",
            "glossary": "Glossary of Errors",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Cause: Binary deleted or blocked.",
            "err1_sol": "Solution: Reinstall using the DMG.",
            "err2_title": "Permission error (could not open piece X)",
            "err2_cause": "Cause: Corrupted or unreadable file.",
            "err2_sol": "Solution: Check permissions or redownload.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Cause: Execution failed.",
            "err3_sol": "Solution: Verify disk space."
        ],
        "es_ve": [
            "drag_drop": "Arrastra y suelta la carpeta PKG aquí",
            "start_merge": "INICIAR UNIÓN",
            "merging": "UNIENDO...",
            "console_output": "Salida de Consola",
            "output_label": "Salida:",
            "same_as_input": "Igual que la carpeta de entrada",
            "change_btn": "Cambiar",
            "ready": "Listo para unir",
            "select_manually": "O selecciona la carpeta manualmente",
            "select_output": "Selecciona la carpeta de salida",
            "waiting": "Esperando carpeta...",
            "starting": "Iniciando unión...",
            "calc_eta": "Calculando tiempo restante...",
            "err_cli": "Error: Herramienta CLI no encontrada en la app.",
            "success": "¡Unión completada exitosamente!",
            "err_code": "La unión falló con el código",
            "failed_run": "Fallo al ejecutar CLI:",
            "eta": "Tiempo restante:",
            "credits": "Créditos",
            "orig_engine": "Motor original C++ por:",
            "macos_app": "App de macOS por:",
            "close": "CERRAR",
            "bio": "Desarrollador autodidacta entusiasta, venezolano viviendo por el mundo gracias a una dictadura que me expulsó de mi propio país.",
            "glossary": "Glosario de Errores",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Causa: Binario borrado o bloqueado.",
            "err1_sol": "Solución: Reinstalar con el DMG.",
            "err2_title": "Error de permisos (could not open piece X)",
            "err2_cause": "Causa: Archivo corrupto o sin lectura.",
            "err2_sol": "Solución: Revisar permisos o re-descargar.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Causa: Fallo de ejecución.",
            "err3_sol": "Solución: Verificar espacio en disco."
        ],
        "fr": [
            "drag_drop": "Glissez et déposez le dossier PKG ici",
            "start_merge": "DÉMARRER LA FUSION",
            "merging": "FUSION...",
            "console_output": "Sortie de la console",
            "output_label": "Sortie :",
            "same_as_input": "Identique au dossier d'entrée",
            "change_btn": "Modifier",
            "ready": "Prêt à fusionner",
            "select_manually": "Ou sélectionnez un dossier manuellement",
            "select_output": "Sélectionner le dossier de sortie",
            "waiting": "En attente du dossier...",
            "starting": "Démarrage de la fusion...",
            "calc_eta": "Calcul du temps restant...",
            "err_cli": "Erreur : outil CLI introuvable dans l'application.",
            "success": "Fusion terminée avec succès !",
            "err_code": "La fusion a échoué avec le code",
            "failed_run": "Échec de l'exécution de la CLI :",
            "eta": "Temps restant :",
            "credits": "Crédits",
            "orig_engine": "Moteur C++ d'origine par :",
            "macos_app": "Application macOS par :",
            "close": "FERMER",
            "bio": "Développeur autodidacte enthousiaste, Vénézuélien vivant de par le monde à cause d'une dictature qui m'a expulsé de mon propre pays.",
            "glossary": "Glossaire des Erreurs",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Cause : Binaire supprimé ou bloqué.",
            "err1_sol": "Solution : Réinstaller avec le DMG.",
            "err2_title": "Erreur d'autorisation (could not open piece X)",
            "err2_cause": "Cause : Fichier corrompu ou illisible.",
            "err2_sol": "Solution : Vérifier les permissions ou retélécharger.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Cause : Échec de l'exécution.",
            "err3_sol": "Solution : Vérifier l'espace disque."
        ],
        "pt_br": [
            "drag_drop": "Arraste e solte a pasta PKG aqui",
            "start_merge": "INICIAR MESCLAGEM",
            "merging": "MESCLANDO...",
            "console_output": "Saída do Console",
            "output_label": "Saída:",
            "same_as_input": "Mesma pasta de entrada",
            "change_btn": "Alterar",
            "ready": "Pronto para mesclar",
            "select_manually": "Ou selecione a pasta manualmente",
            "select_output": "Selecionar pasta de saída",
            "waiting": "Aguardando pasta...",
            "starting": "Iniciando mesclagem...",
            "calc_eta": "Calculando tempo restante...",
            "err_cli": "Erro: ferramenta CLI não encontrada no app.",
            "success": "Mesclagem concluída com sucesso!",
            "err_code": "A mesclagem falhou com o código",
            "failed_run": "Falha ao executar CLI:",
            "eta": "Tempo restante:",
            "credits": "Créditos",
            "orig_engine": "Motor C++ original por:",
            "macos_app": "App macOS por:",
            "close": "FECHAR",
            "bio": "Desenvolvedor autodidata entusiasta, venezuelano vivendo pelo mundo graças a uma ditadura que me expulsou do meu próprio país.",
            "glossary": "Glossário de Erros",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Causa: Binário apagado ou bloqueado.",
            "err1_sol": "Solução: Reinstalar usando o DMG.",
            "err2_title": "Erro de permissão (could not open piece X)",
            "err2_cause": "Causa: Arquivo corrompido ou ilegível.",
            "err2_sol": "Solução: Verificar permissões ou baixar novamente.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Causa: Falha na execução.",
            "err3_sol": "Solução: Verificar espaço em disco."
        ],
        "pt_pt": [
            "drag_drop": "Arraste e solte a pasta PKG aqui",
            "start_merge": "INICIAR FUSÃO",
            "merging": "A FUNDIR...",
            "console_output": "Saída da Consola",
            "output_label": "Saída:",
            "same_as_input": "Igual à pasta de entrada",
            "change_btn": "Alterar",
            "ready": "Pronto para fundir",
            "select_manually": "Ou selecione a pasta manualmente",
            "select_output": "Selecionar pasta de saída",
            "waiting": "A aguardar pasta...",
            "starting": "A iniciar fusão...",
            "calc_eta": "A calcular tempo restante...",
            "err_cli": "Erro: ferramenta CLI não encontrada na app.",
            "success": "Fusão concluída com sucesso!",
            "err_code": "A fusão falhou com o código",
            "failed_run": "Falha ao executar a CLI:",
            "eta": "Tempo restante:",
            "credits": "Créditos",
            "orig_engine": "Motor C++ original por:",
            "macos_app": "App macOS por:",
            "close": "FECHAR",
            "bio": "Desenvolvedor autodidata entusiasta, venezuelano a viver pelo mundo graças a uma ditadura que me expulsou do meu próprio país.",
            "glossary": "Glossário de Erros",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Causa: Binário apagado ou bloqueado.",
            "err1_sol": "Solução: Reinstalar usando o DMG.",
            "err2_title": "Erro de permissão (could not open piece X)",
            "err2_cause": "Causa: Ficheiro corrompido ou ilegível.",
            "err2_sol": "Solução: Verificar permissões ou transferir novamente.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Causa: Falha na execução.",
            "err3_sol": "Solução: Verificar espaço em disco."
        ],
        "ar": [
            "drag_drop": "اسحب وأفلت مجلد PKG هنا",
            "start_merge": "بدء الدمج",
            "merging": "جاري الدمج...",
            "console_output": "إخراج وحدة التحكم",
            "output_label": "الإخراج:",
            "same_as_input": "نفس مجلد الإدخال",
            "change_btn": "تغيير",
            "ready": "جاهز للدمج",
            "select_manually": "أو حدد المجلد يدوياً",
            "select_output": "حدد مجلد الإخراج",
            "waiting": "في انتظار المجلد...",
            "starting": "بدء الدمج...",
            "calc_eta": "حساب الوقت المتبقي...",
            "err_cli": "خطأ: لم يتم العثور على أداة CLI في التطبيق.",
            "success": "تم الدمج بنجاح!",
            "err_code": "فشل الدمج مع الرمز",
            "failed_run": "فشل تشغيل CLI:",
            "eta": "الوقت المتبقي:",
            "credits": "الاعتمادات",
            "orig_engine": "المحرك الأصلي C++ بواسطة:",
            "macos_app": "تطبيق macOS بواسطة:",
            "close": "إغلاق",
            "bio": "مطور علم نفسه بنفسه متحمس، فنزويلي يعيش في جميع أنحاء العالم بفضل ديكتاتورية طردتني من بلدي.",
            "glossary": "مسرد الأخطاء",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "السبب: تم حذف الملف الثنائي أو حظره.",
            "err1_sol": "الحل: إعادة التثبيت باستخدام DMG.",
            "err2_title": "Permission error (could not open piece X)",
            "err2_cause": "السبب: ملف تالف أو غير قابل للقراءة.",
            "err2_sol": "الحل: التحقق من الأذونات أو إعادة التنزيل.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "السبب: فشل التنفيذ.",
            "err3_sol": "الحل: التحقق من مساحة القرص."
        ],
        "de": [
            "drag_drop": "PKG-Ordner hierher ziehen & ablegen",
            "start_merge": "ZUSAMMENFÜHREN STARTEN",
            "merging": "ZUSAMMENFÜHREN...",
            "console_output": "Konsolenausgabe",
            "output_label": "Ausgabe:",
            "same_as_input": "Gleich wie Eingabeordner",
            "change_btn": "Ändern",
            "ready": "Bereit zum Zusammenführen",
            "select_manually": "Oder Ordner manuell auswählen",
            "select_output": "Ausgabeordner auswählen",
            "waiting": "Warte auf Ordner...",
            "starting": "Zusammenführen startet...",
            "calc_eta": "Berechne verbleibende Zeit...",
            "err_cli": "Fehler: CLI-Tool nicht in App gefunden.",
            "success": "Zusammenführen erfolgreich abgeschlossen!",
            "err_code": "Zusammenführen fehlgeschlagen mit Code",
            "failed_run": "CLI konnte nicht ausgeführt werden:",
            "eta": "Verbleibende Zeit:",
            "credits": "Credits",
            "orig_engine": "Original C++ Engine von:",
            "macos_app": "macOS App von:",
            "close": "SCHLIESSEN",
            "bio": "Enthusiastischer autodidaktischer Entwickler, Venezolaner, der in der Welt lebt, dank einer Diktatur, die mich aus meinem eigenen Land vertrieben hat.",
            "glossary": "Fehlerglossar",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Ursache: Binärdatei gelöscht oder blockiert.",
            "err1_sol": "Lösung: Mit der DMG neu installieren.",
            "err2_title": "Berechtigungsfehler (could not open piece X)",
            "err2_cause": "Ursache: Beschädigte oder nicht lesbare Datei.",
            "err2_sol": "Lösung: Berechtigungen überprüfen oder neu herunterladen.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Ursache: Ausführung fehlgeschlagen.",
            "err3_sol": "Lösung: Speicherplatz überprüfen."
        ],
        "zh": [
            "drag_drop": "将 PKG 文件夹拖放到此处",
            "start_merge": "开始合并",
            "merging": "合并中...",
            "console_output": "控制台输出",
            "output_label": "输出：",
            "same_as_input": "与输入文件夹相同",
            "change_btn": "更改",
            "ready": "准备合并",
            "select_manually": "或手动选择文件夹",
            "select_output": "选择输出文件夹",
            "waiting": "等待文件夹...",
            "starting": "开始合并...",
            "calc_eta": "计算剩余时间...",
            "err_cli": "错误：应用程序包中找不到 CLI 工具。",
            "success": "合并成功完成！",
            "err_code": "合并失败，代码为",
            "failed_run": "运行 CLI 失败：",
            "eta": "剩余时间：",
            "credits": "鸣谢",
            "orig_engine": "原版 C++ 引擎：",
            "macos_app": "macOS 应用程序：",
            "close": "关闭",
            "bio": "热情的自学开发者，委内瑞拉人，因为独裁统治被驱逐出自己的国家而流落世界各地。",
            "glossary": "错误词汇表",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "原因：二进制文件被删除或阻止。",
            "err1_sol": "解决方案：使用 DMG 重新安装。",
            "err2_title": "权限错误 (could not open piece X)",
            "err2_cause": "原因：文件损坏或无法读取。",
            "err2_sol": "解决方案：检查权限或重新下载。",
            "err3_title": "Merge failed with code X",
            "err3_cause": "原因：执行失败。",
            "err3_sol": "解决方案：检查磁盘空间."
        ],
        "ja": [
            "drag_drop": "ここにPKGフォルダをドラッグ＆ドロップ",
            "start_merge": "マージ開始",
            "merging": "マージ中...",
            "console_output": "コンソール出力",
            "output_label": "出力：",
            "same_as_input": "入力フォルダと同じ",
            "change_btn": "変更",
            "ready": "マージ準備完了",
            "select_manually": "またはフォルダを手動で選択",
            "select_output": "出力フォルダを選択",
            "waiting": "フォルダを待機中...",
            "starting": "マージを開始...",
            "calc_eta": "残り時間を計算中...",
            "err_cli": "エラー: CLIツールがアプリ内に見つかりません。",
            "success": "マージが正常に完了しました！",
            "err_code": "マージ失敗、コード：",
            "failed_run": "CLIの実行に失敗しました：",
            "eta": "残り時間：",
            "credits": "クレジット",
            "orig_engine": "オリジナルC++エンジン：",
            "macos_app": "macOSアプリ：",
            "close": "閉じる",
            "bio": "熱心な独学開発者。母国から私を追放した独裁政権のおかげで世界中を旅しているベネズエラ人。",
            "glossary": "エラー用語集",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "原因：バイナリが削除またはブロックされました。",
            "err1_sol": "解決策：DMGを使用して再インストールします。",
            "err2_title": "権限エラー (could not open piece X)",
            "err2_cause": "原因：ファイルが破損しているか読み取れません。",
            "err2_sol": "解決策：権限を確認するか、再ダウンロードします。",
            "err3_title": "Merge failed with code X",
            "err3_cause": "原因：実行に失敗しました。",
            "err3_sol": "解決策：ディスク容量を確認してください."
        ],
        "ko": [
            "drag_drop": "여기에 PKG 폴더를 드래그 앤 드롭",
            "start_merge": "병합 시작",
            "merging": "병합 중...",
            "console_output": "콘솔 출력",
            "output_label": "출력:",
            "same_as_input": "입력 폴더와 동일",
            "change_btn": "변경",
            "ready": "병합 준비 완료",
            "select_manually": "또는 수동으로 폴더 선택",
            "select_output": "출력 폴더 선택",
            "waiting": "폴더 대기 중...",
            "starting": "병합 시작 중...",
            "calc_eta": "남은 시간 계산 중...",
            "err_cli": "오류: 앱에서 CLI 도구를 찾을 수 없습니다.",
            "success": "병합이 성공적으로 완료되었습니다!",
            "err_code": "병합 실패, 코드:",
            "failed_run": "CLI 실행 실패:",
            "eta": "남은 시간:",
            "credits": "크레딧",
            "orig_engine": "원본 C++ 엔진:",
            "macos_app": "macOS 앱:",
            "close": "닫기",
            "bio": "열정적인 독학 개발자. 모국에서 나를 추방한 독재 정권 덕분에 전 세계를 떠돌고 있는 베네수엘라인.",
            "glossary": "오류 용어집",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "원인: 바이너리가 삭제되었거나 차단되었습니다.",
            "err1_sol": "해결 방법: DMG를 사용하여 다시 설치하십시오.",
            "err2_title": "권한 오류 (could not open piece X)",
            "err2_cause": "원인: 손상되었거나 읽을 수 없는 파일입니다.",
            "err2_sol": "해결 방법: 권한을 확인하거나 다시 다운로드하십시오.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "원인: 실행 실패.",
            "err3_sol": "해결 방법: 디스크 공간을 확인하십시오."
        ],
        "vi": [
            "drag_drop": "Kéo & Thả thư mục PKG vào đây",
            "start_merge": "BẮT ĐẦU GỘP",
            "merging": "ĐANG GỘP...",
            "console_output": "Đầu ra Bảng điều khiển",
            "output_label": "Đầu ra:",
            "same_as_input": "Giống thư mục Đầu vào",
            "change_btn": "Thay đổi",
            "ready": "Sẵn sàng gộp",
            "select_manually": "Hoặc Chọn thư mục thủ công",
            "select_output": "Chọn thư mục đầu ra",
            "waiting": "Đang đợi thư mục...",
            "starting": "Đang bắt đầu gộp...",
            "calc_eta": "Đang tính thời gian còn lại...",
            "err_cli": "Lỗi: Không tìm thấy công cụ CLI trong ứng dụng.",
            "success": "Gộp thành công!",
            "err_code": "Gộp thất bại với mã",
            "failed_run": "Lỗi chạy CLI:",
            "eta": "Thời gian còn lại:",
            "credits": "Nguồn tham khảo",
            "orig_engine": "Công cụ C++ Gốc bởi:",
            "macos_app": "Ứng dụng macOS bởi:",
            "close": "ĐÓNG",
            "bio": "Nhà phát triển tự học nhiệt huyết, người Venezuela sống khắp thế giới nhờ chế độ độc tài đã trục xuất tôi khỏi chính đất nước của mình.",
            "glossary": "Bảng chú giải lỗi",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Nguyên nhân: Tệp nhị phân bị xóa hoặc bị chặn.",
            "err1_sol": "Giải pháp: Cài đặt lại bằng DMG.",
            "err2_title": "Lỗi cấp phép (could not open piece X)",
            "err2_cause": "Nguyên nhân: Tệp bị hỏng hoặc không thể đọc được.",
            "err2_sol": "Giải pháp: Kiểm tra quyền hoặc tải xuống lại.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Nguyên nhân: Không thể thực thi.",
            "err3_sol": "Giải pháp: Kiểm tra dung lượng ổ đĩa."
        ],
        "it": [
            "drag_drop": "Trascina e rilascia qui la cartella PKG",
            "start_merge": "INIZIA UNIONE",
            "merging": "UNIONE IN CORSO...",
            "console_output": "Output Console",
            "output_label": "Output:",
            "same_as_input": "Stessa cartella di input",
            "change_btn": "Cambia",
            "ready": "Pronto per l'unione",
            "select_manually": "Oppure seleziona manualmente",
            "select_output": "Seleziona cartella di output",
            "waiting": "In attesa della cartella...",
            "starting": "Avvio unione...",
            "calc_eta": "Calcolo tempo rimanente...",
            "err_cli": "Errore: strumento CLI non trovato nell'app.",
            "success": "Unione completata con successo!",
            "err_code": "Unione fallita con codice",
            "failed_run": "Impossibile eseguire CLI:",
            "eta": "Tempo rimanente:",
            "credits": "Crediti",
            "orig_engine": "Motore C++ originale di:",
            "macos_app": "App macOS di:",
            "close": "CHIUDI",
            "bio": "Sviluppatore autodidatta entusiasta, venezuelano che vive in giro per il mondo grazie a una dittatura che mi ha espulso dal mio stesso paese.",
            "glossary": "Glossario degli errori",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Causa: Binario eliminato o bloccato.",
            "err1_sol": "Soluzione: Reinstallare con il DMG.",
            "err2_title": "Errore di autorizzazione (could not open piece X)",
            "err2_cause": "Causa: File corrotto o illeggibile.",
            "err2_sol": "Soluzione: Controllare i permessi o riscaricare.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Causa: Esecuzione fallita.",
            "err3_sol": "Soluzione: Verificare lo spazio su disco."
        ],
        "eo": [
            "drag_drop": "Trenu kaj faligu PKG dosierujon ĉi tie",
            "start_merge": "KOMENCI KUNFANDON",
            "merging": "KUNFANDAS...",
            "console_output": "Konzola eligo",
            "output_label": "Eligo:",
            "same_as_input": "Sama kiel eniga dosierujo",
            "change_btn": "Ŝanĝi",
            "ready": "Preta por kunfandi",
            "select_manually": "Aŭ elektu dosierujon mane",
            "select_output": "Elekti eligan dosierujon",
            "waiting": "Atendas dosierujon...",
            "starting": "Komencas kunfandon...",
            "calc_eta": "Kalkulante restantan tempon...",
            "err_cli": "Eraro: CLI ilo ne trovita en apo.",
            "success": "Kunfando sukcese kompletigita!",
            "err_code": "Kunfando malsukcesis kun kodo",
            "failed_run": "Malsukcesis ruli CLI:",
            "eta": "Restanta tempo:",
            "credits": "Kreditaĵoj",
            "orig_engine": "Origina C++ Motoro de:",
            "macos_app": "macOS Apo de:",
            "close": "FERMI",
            "bio": "Entuziasma memlernanta programisto, venezuelano vivanta tra la mondo pro diktaturo kiu forpelis min de mia propra lando.",
            "glossary": "Glosaro de Eraroj",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Kaŭzo: Binaraĵo forigita aŭ blokita.",
            "err1_sol": "Solvo: Reinstalu per la DMG.",
            "err2_title": "Permes-eraro (could not open piece X)",
            "err2_cause": "Kaŭzo: Koruptita aŭ nelegebla dosiero.",
            "err2_sol": "Solvo: Kontrolu permesojn aŭ redownloadu.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Kaŭzo: Ekzekuto malsukcesis.",
            "err3_sol": "Solvo: Kontrolu diskospacon."
        ],
        "hi": [
            "drag_drop": "यहां PKG फ़ोल्डर खींचें और छोड़ें",
            "start_merge": "मर्ज शुरू करें",
            "merging": "मर्ज हो रहा है...",
            "console_output": "कंसोल आउटपुट",
            "output_label": "आउटपुट:",
            "same_as_input": "इनपुट फ़ोल्डर के समान",
            "change_btn": "बदलें",
            "ready": "मर्ज करने के लिए तैयार",
            "select_manually": "या मैन्युअल रूप से फ़ोल्डर चुनें",
            "select_output": "आउटपुट फ़ोल्डर चुनें",
            "waiting": "फ़ोल्डर की प्रतीक्षा कर रहा है...",
            "starting": "मर्ज शुरू हो रहा है...",
            "calc_eta": "शेष समय की गणना...",
            "err_cli": "त्रुटि: ऐप में CLI टूल नहीं मिला।",
            "success": "मर्ज सफलतापूर्वक पूर्ण हुआ!",
            "err_code": "मर्ज विफल, कोड:",
            "failed_run": "CLI चलाने में विफल:",
            "eta": "शेष समय:",
            "credits": "क्रेडिट",
            "orig_engine": "मूल C++ इंजन द्वारा:",
            "macos_app": "macOS ऐप द्वारा:",
            "close": "बंद करें",
            "bio": "उत्साही स्व-शिक्षित डेवलपर, एक तानाशाही की वजह से जो मुझे मेरे ही देश से निकाल दिया, दुनिया भर में रह रहा वेनेजुएलाई।",
            "glossary": "त्रुटियों की शब्दावली",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "कारण: बाइनरी हटा दी गई या अवरुद्ध हो गई।",
            "err1_sol": "समाधान: DMG का उपयोग करके पुनः इंस्टॉल करें।",
            "err2_title": "अनुमति त्रुटि (could not open piece X)",
            "err2_cause": "कारण: दूषित या अपठनीय फ़ाइल।",
            "err2_sol": "समाधान: अनुमतियाँ जाँचे या पुनः डाउनलोड करें।",
            "err3_title": "Merge failed with code X",
            "err3_cause": "कारण: निष्पादन विफल रहा।",
            "err3_sol": "समाधान: डिस्क स्थान सत्यापित करें।"
        ],
        "tl": [
            "drag_drop": "I-drag at I-drop ang PKG Folder Dito",
            "start_merge": "SIMULAN ANG MERGE",
            "merging": "NAGME-MERGE...",
            "console_output": "Console Output",
            "output_label": "Output:",
            "same_as_input": "Kapareho ng Input folder",
            "change_btn": "Palitan",
            "ready": "Handa nang i-merge",
            "select_manually": "O Piliin nang mano-mano",
            "select_output": "Pumili ng Output Folder",
            "waiting": "Naghihintay ng folder...",
            "starting": "Sinisimulan ang merge...",
            "calc_eta": "Kinakalkula ang natitirang oras...",
            "err_cli": "Error: CLI tool hindi natagpuan sa app.",
            "success": "Matagumpay na natapos ang merge!",
            "err_code": "Nabigo ang merge na may code",
            "failed_run": "Nabigong patakbuhin ang CLI:",
            "eta": "Natitirang oras:",
            "credits": "Mga Kredito",
            "orig_engine": "Orihinal na C++ Engine ni:",
            "macos_app": "macOS App ni:",
            "close": "ISARA",
            "bio": "Masigasig na developer na nag-aral sa sarili, Venezuelan na naninirahan sa buong mundo salamat sa isang diktadura na nagpaalis sa akin mula sa aking sariling bansa.",
            "glossary": "Talasalitaan ng mga Error",
            "err1_title": "CLI tool not found / pkgmachete-cli not found",
            "err1_cause": "Dahilan: Na-delete o na-block ang binary.",
            "err1_sol": "Solusyon: I-reinstall gamit ang DMG.",
            "err2_title": "Error sa pahintulot (could not open piece X)",
            "err2_cause": "Dahilan: Sira o hindi mabasa na file.",
            "err2_sol": "Solusyon: Suriin ang mga pahintulot o i-download muli.",
            "err3_title": "Merge failed with code X",
            "err3_cause": "Dahilan: Nabigo ang execution.",
            "err3_sol": "Solusyon: I-verify ang disk space."
        ]
    ]
}

struct CLIMessage: Decodable {
    let type: String
    let thread: Int?
    let part: Int?
    let progress: Double?
    let global: Double?
    let message: String?
    let dracarys_needed: Bool?
}

class MergeViewModel: ObservableObject {
    @Published var isHovering = false
    @Published var selectedFolder: URL?
    @Published var outputFolder: URL?
    @Published var isProcessing = false
    @Published var progress: Double = 0
    @Published var threadProgress: [Int: Double] = [:]
    @Published var showDracarysAlert = false
    
    @Published var statusKey: String = "waiting"
    @Published var statusArg: String = ""
    @Published var statusRaw: String? = nil
    
    @Published var etaKey: String = ""
    @Published var etaArg: String = ""
    @Published var logOutput: String = ""
    
    var startTime: Date?
    private var process: Process?
    
    private var logAccumulator: String = ""
    private var logUpdateTimer: Timer?
    private let maxLogLength = 10000
    private let logQueue = DispatchQueue(label: "com.pkgmachete.logQueue")
    
    private func flushLogs(force: Bool = false) {
        var newLogs = ""
        logQueue.sync {
            if !self.logAccumulator.isEmpty {
                if force {
                    newLogs = self.logAccumulator
                    self.logAccumulator = ""
                } else if let lastNewlineIndex = self.logAccumulator.lastIndex(of: "\n") {
                    let splitIndex = self.logAccumulator.index(after: lastNewlineIndex)
                    newLogs = String(self.logAccumulator[..<splitIndex])
                    self.logAccumulator = String(self.logAccumulator[splitIndex...])
                }
            }
        }
        if !newLogs.isEmpty {
            self.parseOutput(newLogs)
        }
    }
    
    func startMerge() {
        startMerge(force: false)
    }
    
    func startMerge(force: Bool) {
        guard let folder = selectedFolder else { return }
        isProcessing = true
        progress = 0
        threadProgress = [:]
        startTime = Date()
        
        statusRaw = nil
        statusKey = "starting"
        statusArg = ""
        
        etaKey = "calc_eta"
        etaArg = ""
        
        logOutput = "--- PKGMachete Engine Started ---\n"
        logAccumulator = ""
        
        logUpdateTimer?.invalidate()
        logUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.flushLogs()
        }
        
        let outPath = outputFolder?.path
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.runCLI(folderPath: folder.path, outPath: outPath, force: force)
        }
    }
    
    func runCLI(folderPath: String, outPath: String?, force: Bool) {
        guard let cliPath = Bundle.main.url(forResource: "pkgmachete-cli", withExtension: nil)?.path else {
            DispatchQueue.main.async {
                self.statusRaw = nil
                self.statusKey = "err_cli"
                self.logOutput += "Error: pkgmachete-cli not found.\n"
                self.isProcessing = false
            }
            return
        }
        
        let process = Process()
        DispatchQueue.main.async {
            self.process = process
        }
        process.environment = [:] // Clear environment to prevent injection attacks
        process.executableURL = URL(fileURLWithPath: cliPath)
        var args = [folderPath]
        if let out = outPath {
            args.append(out)
        }
        if force {
            args.append("--force")
        }
        process.arguments = args
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        
        let fileHandle = pipe.fileHandleForReading
        fileHandle.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if data.isEmpty { return }
            if let str = String(data: data, encoding: .utf8) {
                self?.logQueue.sync {
                    self?.logAccumulator += str
                }
            }
        }
        
        do {
            try process.run()
            process.waitUntilExit()
            
            DispatchQueue.main.async {
                fileHandle.readabilityHandler = nil
                self.logUpdateTimer?.invalidate()
                self.flushLogs(force: true)
                
                self.isProcessing = false
                self.process = nil
                if process.terminationStatus == 0 {
                    self.progress = 100
                    self.statusRaw = nil
                    self.statusKey = "success"
                    self.etaKey = ""
                    self.logOutput += "\n--- Merge Completed ---\n"
                } else if !self.showDracarysAlert {
                    if self.statusRaw == nil || !(self.statusRaw!.lowercased().contains("error")) {
                        self.statusRaw = nil
                        self.statusKey = "err_code"
                        self.statusArg = "\(process.terminationStatus)"
                    }
                    self.logOutput += "\n--- Merge Failed (Code \(process.terminationStatus)) ---\n"
                }
            }
        } catch {
            DispatchQueue.main.async {
                fileHandle.readabilityHandler = nil
                self.logUpdateTimer?.invalidate()
                self.flushLogs(force: true)
                self.process = nil
                self.statusRaw = nil
                self.statusKey = "failed_run"
                self.statusArg = error.localizedDescription
                self.logOutput += "Exception: \(error.localizedDescription)\n"
                self.isProcessing = false
            }
        }
    }
    
    func parseOutput(_ output: String) {
        let lines = output.components(separatedBy: .newlines)
        
        DispatchQueue.global(qos: .userInitiated).async {
            var newLogs = ""
            var localStatusRaw: String?
            var localProgress: Double?
            var localThreadProgress = [Int: Double]()
            var localEtaKey: String?
            var localEtaArg: String?
            var triggerDracarys = false
            var finishProgress = false
            
            for line in lines {
                let tLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if tLine.isEmpty { continue }
                
                if let data = tLine.data(using: .utf8),
                   let msg = try? JSONDecoder().decode(CLIMessage.self, from: data) {
                    
                    switch msg.type {
                    case "progress":
                        if let thread = msg.thread ?? msg.part, let p = msg.progress {
                            localThreadProgress[thread] = p
                        }
                        if let g = msg.global {
                            localProgress = g
                            if let start = self.startTime, g > 0 {
                                let elapsed = Date().timeIntervalSince(start)
                                let totalEstimated = (elapsed / (g / 100.0))
                                let remaining = totalEstimated - elapsed
                                if remaining > 0 {
                                    localEtaKey = "eta"
                                    localEtaArg = "\(Int(remaining))s"
                                }
                            }
                        }
                        
                        let th = msg.thread ?? msg.part ?? 0
                        let part = msg.part ?? 0
                        let pStr = String(format: "%05.2f%%", msg.progress ?? 0.0)
                        let gStr = String(format: "%05.2f%%", msg.global ?? 0.0)
                        newLogs += "> [SYS] THREAD_\(String(format: "%02d", th)) ACTIVE | CHUNK: \(String(format: "%02d", part)) | PROG: \(pStr) | GLOBAL: \(gStr)\n"
                    case "error":
                        localStatusRaw = msg.message ?? "Error"
                        newLogs += "[ERROR] \(msg.message ?? "Error")\n"
                        if msg.dracarys_needed == true {
                            triggerDracarys = true
                        }
                    case "success":
                        localStatusRaw = msg.message ?? "Success"
                        newLogs += "[SUCCESS] \(msg.message ?? "Success")\n"
                        finishProgress = true
                    case "info":
                        localStatusRaw = msg.message ?? "Info"
                        newLogs += "[INFO] \(msg.message ?? "Info")\n"
                    default:
                        newLogs += line + "\n"
                    }
                } else {
                    newLogs += line + "\n"
                    if tLine.contains("merged") && tLine.contains("bytes") {
                        if let percentRange = tLine.range(of: "(?<=)\\d+(?=\\%)", options: .regularExpression) {
                            let percentStr = String(tLine[percentRange])
                            if let p = Double(percentStr) {
                                localProgress = p
                                localStatusRaw = tLine
                            }
                        }
                    } else if tLine.contains("[success]") || tLine.contains("[error]") || tLine.contains("[warn]") {
                        localStatusRaw = tLine
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.logOutput += newLogs
                if self.logOutput.count > self.maxLogLength {
                    self.logOutput = String(self.logOutput.suffix(self.maxLogLength))
                }
                if let status = localStatusRaw { self.statusRaw = status }
                if let p = localProgress { self.progress = p }
                if let ek = localEtaKey, let ea = localEtaArg {
                    self.etaKey = ek
                    self.etaArg = ea
                }
                for (t, p) in localThreadProgress {
                    self.threadProgress[t] = p
                }
                if triggerDracarys {
                    self.process?.terminate()
                    self.showDracarysAlert = true
                }
                if finishProgress {
                    self.progress = 100
                }
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var lang: LanguageManager
    @StateObject private var vm = MergeViewModel()
    @State private var showAbout = false
    @State private var showGlossary = false
    @State private var showChangelog = false
    
    var body: some View {
        ZStack {
            // Animated background or Cyberpunk gradients
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.0, blue: 0.15), Color(red: 0.0, green: 0.05, blue: 0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // Floating circles for glass effect
            Circle()
                .fill(Color.purple.opacity(0.5))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: -250, y: -200)
            
            Circle()
                .fill(Color.cyan.opacity(0.4))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 250, y: 200)

            VStack(spacing: 15) {
                // Header
                HStack {
                    Menu {
                        ForEach(lang.availableLanguages, id: \.0) { language in
                            Button(action: {
                                lang.currentLanguage = language.0
                            }) {
                                Text("\(language.2) \(language.1)")
                            }
                        }
                    } label: {
                        if let current = lang.availableLanguages.first(where: { $0.0 == lang.currentLanguage }) {
                            Text("\(current.2) \(current.1)")
                                .font(.headline)
                                .foregroundColor(.cyan)
                        }
                    }
                    .menuStyle(.borderlessButton)
                    .frame(width: 160, alignment: .leading)
                    
                    Spacer()
                    
                    Text("v5.0.0")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                        
                    Button(action: {
                        if let url = URL(string: "https://github.com/Tustin/pkg-merge") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        Image(systemName: "curlybraces.square.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { showChangelog.toggle() }) {
                        Image(systemName: "list.clipboard.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { showGlossary.toggle() }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: { showAbout.toggle() }) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.cyan)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 15)
                .padding(.horizontal, 30)

                HStack {
                    Image(systemName: "gamecontroller.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan, radius: 10, x: 0, y: 0)
                    
                    Text("PKGMachete")
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 5, x: 0, y: 0)
                }
                
                // Drop Zone
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(vm.isHovering ? Color.cyan : Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [10]))
                        )
                        .frame(height: 100)
                        .shadow(color: vm.isHovering ? Color.cyan.opacity(0.5) : Color.clear, radius: 10)
                    
                    if let folder = vm.selectedFolder {
                        VStack(spacing: 8) {
                            Image(systemName: "folder.fill")
                                .font(.title)
                                .foregroundColor(.cyan)
                            Text(folder.lastPathComponent)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(folder.path)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .truncationMode(.middle)
                                .lineLimit(1)
                                .padding(.horizontal, 20)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.down.doc.fill")
                                .font(.title)
                                .foregroundColor(.white.opacity(0.6))
                            Text(lang.get("drag_drop"))
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.horizontal, 40)
                .onDrop(of: [.fileURL], isTargeted: $vm.isHovering) { providers in
                    if let provider = providers.first {
                        _ = provider.loadObject(ofClass: URL.self) { url, _ in
                            if let url = url {
                                DispatchQueue.main.async {
                                    var isDir: ObjCBool = false
                                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
                                        vm.selectedFolder = isDir.boolValue ? url : url.deletingLastPathComponent()
                                        vm.statusRaw = nil
                                        vm.statusKey = "ready"
                                        vm.statusArg = ""
                                        vm.progress = 0
                                        vm.etaKey = ""
                                        vm.etaArg = ""
                                    }
                                }
                            }
                        }
                        return true
                    }
                    return false
                }
                
                // Select folder manually
                Button(action: {
                    let panel = NSOpenPanel()
                    panel.canChooseFiles = false
                    panel.canChooseDirectories = true
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            vm.selectedFolder = url
                            vm.statusRaw = nil
                            vm.statusKey = "ready"
                            vm.statusArg = ""
                            vm.progress = 0
                            vm.etaKey = ""
                            vm.etaArg = ""
                        }
                    }
                }) {
                    Text(lang.get("select_manually"))
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(vm.isProcessing)
                
                if vm.selectedFolder != nil {
                    HStack {
                        Text(lang.get("output_label"))
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text(vm.outputFolder?.path ?? lang.get("same_as_input"))
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Button(lang.get("change_btn")) {
                            let panel = NSOpenPanel()
                            panel.canChooseFiles = false
                            panel.canChooseDirectories = true
                            panel.allowsMultipleSelection = false
                            panel.prompt = lang.get("select_output")
                            if panel.runModal() == .OK {
                                if let url = panel.url {
                                    vm.outputFolder = url
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.cyan)
                    }
                    .font(.caption)
                    .padding(.horizontal, 40)
                }
                
                // Progress Bar
                VStack(spacing: 6) {
                    ProgressView(value: vm.progress, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .cyan))
                        .padding(.horizontal, 40)
                    
                    if !vm.threadProgress.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(vm.threadProgress.keys.sorted(), id: \.self) { threadId in
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Thread \(threadId)")
                                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                                            .foregroundColor(.purple)
                                        ProgressView(value: vm.threadProgress[threadId] ?? 0, total: 100)
                                            .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                                            .frame(width: 60)
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        .frame(height: 25)
                    }
                    
                    HStack {
                        let statusText = vm.statusRaw ?? (vm.statusKey.isEmpty ? "" : lang.get(vm.statusKey) + (vm.statusArg.isEmpty ? "" : " " + vm.statusArg))
                        Text(statusText)
                            .font(.footnote)
                            .foregroundColor(.cyan)
                            .lineLimit(1)
                            
                        Spacer()
                        
                        let etaText = vm.etaKey.isEmpty ? "" : lang.get(vm.etaKey) + (vm.etaArg.isEmpty ? "" : " " + vm.etaArg)
                        Text(etaText)
                            .font(.footnote)
                            .foregroundColor(.purple)
                    }
                    .padding(.horizontal, 40)
                }
                .opacity(vm.selectedFolder == nil ? 0 : 1)
                
                // Logs View
                VStack(alignment: .leading, spacing: 5) {
                    Text(lang.get("console_output"))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                    
                    ScrollViewReader { proxy in
                        ScrollView {
                            Text(vm.logOutput)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .id("LogBottom")
                        }
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        .padding(.horizontal, 40)
                        .frame(maxHeight: .infinity)
                        .onChange(of: vm.logOutput) { _, _ in
                            withAnimation {
                                proxy.scrollTo("LogBottom", anchor: .bottom)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 10)
                
                // Action Button
                Button(action: { vm.startMerge() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(vm.selectedFolder == nil || vm.isProcessing ? Color.gray.opacity(0.5) : Color.cyan)
                            .shadow(color: vm.selectedFolder == nil || vm.isProcessing ? .clear : .cyan.opacity(0.8), radius: 10, x: 0, y: 0)
                        
                        Text(vm.isProcessing ? lang.get("merging") : lang.get("start_merge"))
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(vm.selectedFolder == nil || vm.isProcessing ? .white.opacity(0.5) : .black)
                    }
                    .frame(height: 45)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .disabled(vm.selectedFolder == nil || vm.isProcessing)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAbout) {
            AboutView()
                .environmentObject(lang)
        }
        .sheet(isPresented: $showGlossary) {
            GlossaryView()
                .environmentObject(lang)
        }
        .sheet(isPresented: $showChangelog) {
            ChangelogView()
                .environmentObject(lang)
        }
        .alert(isPresented: $vm.showDracarysAlert) {
            Alert(
                title: Text("Dracarys"),
                message: Text("Por los Siete Dioses, la matemática original dice que esto es imposible. A menos que estés usando magia de sangre o trucos oscuros de la Scene... ¿Deseas despertar al dragón?"),
                primaryButton: .destructive(Text("🔥 Dracarys! (Usar Magia)")) {
                    vm.startMerge(force: true)
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var lang: LanguageManager
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 25) {
                Image(systemName: "gamecontroller.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan, radius: 10, x: 0, y: 0)
                    .padding(.top, 20)
                
                Text("PKGMachete")
                    .font(.system(size: 32, weight: .heavy, design: .monospaced))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    Text(lang.get("credits"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(systemName: "cpu")
                                .foregroundColor(.cyan)
                                .frame(width: 20)
                            VStack(alignment: .leading) {
                                Text(lang.get("orig_engine"))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Link("Tustin (github.com/Tustin/pkg-merge)", destination: URL(string: "https://github.com/Tustin/pkg-merge")!)
                                    .font(.body)
                                    .foregroundColor(.cyan)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            Image(systemName: "macwindow")
                                .foregroundColor(.purple)
                                .frame(width: 20)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(lang.get("macos_app"))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("VenezuenBiggie24")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                
                                Text(lang.get("bio"))
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text(lang.get("close"))
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 120, height: 40)
                        .background(Color.cyan)
                        .cornerRadius(8)
                        .shadow(color: .cyan.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 30)
            }
        }
        .frame(width: 450, height: 500)
    }
}

struct GlossaryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var lang: LanguageManager
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan, radius: 5, x: 0, y: 0)
                    
                    Text(lang.get("glossary"))
                        .font(.system(size: 28, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ErrorItemView(
                            title: lang.get("err1_title"),
                            cause: lang.get("err1_cause"),
                            solution: lang.get("err1_sol")
                        )
                        
                        ErrorItemView(
                            title: lang.get("err2_title"),
                            cause: lang.get("err2_cause"),
                            solution: lang.get("err2_sol")
                        )
                        
                        ErrorItemView(
                            title: lang.get("err3_title"),
                            cause: lang.get("err3_cause"),
                            solution: lang.get("err3_sol")
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text(lang.get("close"))
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 120, height: 40)
                        .background(Color.cyan)
                        .cornerRadius(8)
                        .shadow(color: .cyan.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
            }
        }
        .frame(width: 550, height: 600)
    }
}

struct ErrorItemView: View {
    let title: String
    let cause: String
    let solution: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.purple)
                .fontWeight(.bold)
            
            HStack(alignment: .top) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 20)
                Text(cause)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack(alignment: .top) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: 20)
                Text(solution)
                    .font(.subheadline)
                    .foregroundColor(.cyan)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
    }
}

struct ChangelogView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Changelog - PKGMachete")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.cyan)
                .padding(.top, 30)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ChangelogItemView(
                        version: "v5.0.0",
                        date: "Jul 2026",
                        features: [
                            "Optimización de C++: Cada hilo ahora usa su propio descriptor de archivo (VFS Lock Contention resuelto).",
                            "Implementado F_NOCACHE para evitar la saturación de RAM (Page Cache Trashing) en macOS.",
                            "Validación estricta de Magic Bytes implementada para prevenir la unión de archivos PKG falsos.",
                            "Protección total contra Inyección JSON desde el motor C++.",
                            "Decodificación asíncrona de JSON en Swift para evitar caídas de FPS en la interfaz.",
                            "Mejoras de UI: Botón hacia GitHub, Versión y Changelog dinámicos."
                        ]
                    )
                    
                    ChangelogItemView(
                        version: "v4.0.0",
                        date: "Jul 2026",
                        features: [
                            "Migración completa del motor de backend a C++20.",
                            "Soporte nativo para Multi-Threading con concurrencia por hardware.",
                            "Implementada salida JSON estandarizada para comunicación asíncrona.",
                            "Barra de progreso general con ETA (Tiempo Estimado) en vivo."
                        ]
                    )
                }
                .padding(.horizontal, 30)
            }
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            .background(Color.purple.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
        }
        .frame(minWidth: 500, minHeight: 600)
        .background(Color.black)
    }
}

struct ChangelogItemView: View {
    let version: String
    let date: String
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(version)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                Spacer()
                Text(date)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Divider().background(Color.gray.opacity(0.3))
            
            ForEach(features, id: \.self) { feature in
                HStack(alignment: .top) {
                    Text("•")
                        .foregroundColor(.purple)
                    Text(feature)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
