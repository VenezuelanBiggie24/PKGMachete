import os
import sys
import time
import re
import threading
import subprocess
import customtkinter as ctk
from tkinter import filedialog, messagebox

# --- Translations ---
LANGUAGES = {
    "English": {"dir": "Select Directory", "out": "Select Output (Optional)", "start": "Start Merge", "ready": "Ready", "lang": "Language", "eta": "ETA:"},
    "Spanish (Venezuelan)": {"dir": "Seleccionar Directorio", "out": "Seleccionar Salida (Opcional)", "start": "Iniciar Fusión", "ready": "Listo", "lang": "Idioma", "eta": "Tiempo Estimado:"},
    "French": {"dir": "Sélectionner Répertoire", "out": "Sélectionner Sortie (Optionnel)", "start": "Démarrer Fusion", "ready": "Prêt", "lang": "Langue", "eta": "ETA:"},
    "Portuguese (Brazilian)": {"dir": "Selecionar Diretório", "out": "Selecionar Saída (Opcional)", "start": "Iniciar Mesclagem", "ready": "Pronto", "lang": "Idioma", "eta": "ETA:"},
    "Portuguese (Portugal)": {"dir": "Selecionar Diretoria", "out": "Selecionar Saída (Opcional)", "start": "Iniciar Fusão", "ready": "Pronto", "lang": "Idioma", "eta": "ETA:"},
    "Arabic": {"dir": "حدد المجلد", "out": "حدد المخرجات (اختياري)", "start": "بدء الدمج", "ready": "جاهز", "lang": "اللغة", "eta": "الوقت المتبقي:"},
    "German": {"dir": "Verzeichnis Auswählen", "out": "Ausgabe Auswählen (Optional)", "start": "Zusammenführen Starten", "ready": "Bereit", "lang": "Sprache", "eta": "ETA:"},
    "Mandarin": {"dir": "选择目录", "out": "选择输出 (可选)", "start": "开始合并", "ready": "准备就绪", "lang": "语言", "eta": "剩余时间:"},
    "Japanese": {"dir": "ディレクトリを選択", "out": "出力を選択 (オプション)", "start": "マージを開始", "ready": "準備完了", "lang": "言語", "eta": "残り時間:"},
    "Korean": {"dir": "디렉토리 선택", "out": "출력 선택 (선택 사항)", "start": "병합 시작", "ready": "준비 완료", "lang": "언어", "eta": "남은 시간:"},
    "Vietnamese": {"dir": "Chọn Thư mục", "out": "Chọn Đầu ra (Tùy chọn)", "start": "Bắt đầu Ghép", "ready": "Sẵn sàng", "lang": "Ngôn ngữ", "eta": "ETA:"},
    "Italian": {"dir": "Seleziona Cartella", "out": "Seleziona Output (Opzionale)", "start": "Avvia Unione", "ready": "Pronto", "lang": "Lingua", "eta": "ETA:"},
    "Esperanto": {"dir": "Elekti Dosierujon", "out": "Elekti Eligon (Laŭvola)", "start": "Komenci Kunfandi", "ready": "Preta", "lang": "Lingvo", "eta": "ETA:"},
    "Hindi": {"dir": "निर्देशिका चुनें", "out": "आउटपुट चुनें (वैकल्पिक)", "start": "मर्ज शुरू करें", "ready": "तैयार", "lang": "भाषा", "eta": "अनुमानित समय:"},
    "Tagalog": {"dir": "Piliin ang Direktoryo", "out": "Piliin ang Output (Opsiyonal)", "start": "Simulan Pagsasama", "ready": "Handa", "lang": "Wika", "eta": "ETA:"},
}

class PKGMacheteApp(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("PKGMachete")
        self.geometry("750x550")
        ctk.set_appearance_mode("dark")
        ctk.set_default_color_theme("blue")
        
        self.current_lang = "English"
        self.target_dir = ""
        self.output_dir = ""
        self.binary_path = "/opt/PKGMachete/bin/pkg-merge"
        
        # Test fallback for local dev
        if not os.path.exists(self.binary_path):
            fallback = os.path.join(os.path.dirname(__file__), "..", "build_linux", "pkg-merge")
            if os.path.exists(fallback):
                self.binary_path = fallback
            else:
                fallback = os.path.join(os.path.dirname(__file__), "..", "pkg-merge")
                if os.path.exists(fallback):
                    self.binary_path = fallback

        self.setup_ui()
        self.update_texts()

    def setup_ui(self):
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(3, weight=1)
        
        # Top Frame (Controls)
        self.top_frame = ctk.CTkFrame(self, fg_color="transparent")
        self.top_frame.grid(row=0, column=0, padx=20, pady=10, sticky="ew")
        self.top_frame.grid_columnconfigure(0, weight=1)
        self.top_frame.grid_columnconfigure(1, weight=1)

        self.btn_dir = ctk.CTkButton(self.top_frame, command=self.select_dir)
        self.btn_dir.grid(row=0, column=0, padx=5, pady=5, sticky="ew")

        self.btn_out = ctk.CTkButton(self.top_frame, command=self.select_out)
        self.btn_out.grid(row=0, column=1, padx=5, pady=5, sticky="ew")

        # Labels
        self.lbl_dir = ctk.CTkLabel(self.top_frame, text="...", text_color="gray")
        self.lbl_dir.grid(row=1, column=0, padx=5, pady=0, sticky="w")

        self.lbl_out = ctk.CTkLabel(self.top_frame, text="...", text_color="gray")
        self.lbl_out.grid(row=1, column=1, padx=5, pady=0, sticky="w")

        # Action & Lang
        self.mid_frame = ctk.CTkFrame(self, fg_color="transparent")
        self.mid_frame.grid(row=1, column=0, padx=20, pady=5, sticky="ew")
        self.mid_frame.grid_columnconfigure(0, weight=1)

        self.btn_start = ctk.CTkButton(self.mid_frame, command=self.start_merge, height=40)
        self.btn_start.grid(row=0, column=0, padx=5, pady=5, sticky="ew")
        
        self.lang_var = ctk.StringVar(value=self.current_lang)
        self.lang_menu = ctk.CTkOptionMenu(self.mid_frame, values=list(LANGUAGES.keys()), variable=self.lang_var, command=self.change_lang)
        self.lang_menu.grid(row=0, column=1, padx=5, pady=5)

        # Progress
        self.prog_frame = ctk.CTkFrame(self, fg_color="transparent")
        self.prog_frame.grid(row=2, column=0, padx=20, pady=5, sticky="ew")
        self.prog_frame.grid_columnconfigure(0, weight=1)
        
        self.progress = ctk.CTkProgressBar(self.prog_frame)
        self.progress.grid(row=0, column=0, columnspan=2, padx=5, pady=5, sticky="ew")
        self.progress.set(0)

        self.lbl_eta = ctk.CTkLabel(self.prog_frame, text="")
        self.lbl_eta.grid(row=1, column=0, padx=5, sticky="w")
        
        self.lbl_pct = ctk.CTkLabel(self.prog_frame, text="0%")
        self.lbl_pct.grid(row=1, column=1, padx=5, sticky="e")

        # Console Log
        self.console = ctk.CTkTextbox(self, font=("Courier", 12), state="disabled", wrap="word")
        self.console.grid(row=3, column=0, padx=20, pady=10, sticky="nsew")

    def update_texts(self):
        t = LANGUAGES[self.current_lang]
        self.btn_dir.configure(text=t["dir"])
        self.btn_out.configure(text=t["out"])
        self.btn_start.configure(text=t["start"])
        self.log(t["ready"] + "\n")

    def change_lang(self, choice):
        self.current_lang = choice
        self.update_texts()

    def select_dir(self):
        d = filedialog.askdirectory()
        if d:
            self.target_dir = d
            self.lbl_dir.configure(text=d[-40:])
            
    def select_out(self):
        d = filedialog.askdirectory()
        if d:
            self.output_dir = d
            self.lbl_out.configure(text=d[-40:])

    def log(self, msg, replace_last_line=False):
        self.console.configure(state="normal")
        if replace_last_line:
            # Delete last line
            self.console.delete("end-2l", "end-1c")
            self.console.insert("end", "\n" + msg)
        else:
            self.console.insert("end", msg)
        self.console.see("end")
        self.console.configure(state="disabled")

    def start_merge(self):
        if not self.target_dir:
            return
            
        if not os.path.exists(self.binary_path):
            self.log(f"[ERROR] Engine not found at {self.binary_path}\n")
            return

        self.btn_start.configure(state="disabled")
        self.progress.set(0)
        self.lbl_pct.configure(text="0%")
        self.lbl_eta.configure(text="")
        
        cmd = [self.binary_path, self.target_dir]
        if self.output_dir:
            cmd.append(self.output_dir)

        threading.Thread(target=self.run_process, args=(cmd,), daemon=True).start()

    def run_process(self, cmd):
        start_time = time.time()
        
        try:
            # We must use Popen to read stdout continuously
            process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1, universal_newlines=True)
            
            # Read character by character to handle \r
            current_line = ""
            while True:
                char = process.stdout.read(1)
                if not char:
                    break
                    
                if char == '\r':
                    self.parse_and_log(current_line, replace=True, start_time=start_time)
                    current_line = ""
                elif char == '\n':
                    self.parse_and_log(current_line, replace=False, start_time=start_time)
                    current_line = ""
                else:
                    current_line += char

            process.wait()
            self.after(0, lambda: self.log("\n[SUCCESS] Completed\n"))
        except Exception as e:
            self.after(0, lambda: self.log(f"\n[ERROR] {str(e)}\n"))
            
        self.after(0, lambda: self.btn_start.configure(state="normal"))

    def parse_and_log(self, line, replace, start_time):
        if not line.strip():
            return

        # Check for progress percentage, e.g., "merged 100/1000 bytes (10%)"
        match = re.search(r'\((\d+)%\)', line)
        if match:
            pct = int(match.group(1))
            self.after(0, lambda: self.progress.set(pct / 100.0))
            self.after(0, lambda: self.lbl_pct.configure(text=f"{pct}%"))
            
            # Calculate ETA
            elapsed = time.time() - start_time
            if pct > 0:
                total_est = elapsed / (pct / 100.0)
                rem = total_est - elapsed
                m, s = divmod(int(rem), 60)
                eta_str = f"{LANGUAGES[self.current_lang]['eta']} {m}m {s}s"
                self.after(0, lambda: self.lbl_eta.configure(text=eta_str))

        self.after(0, lambda: self.log(line + "\n", replace_last_line=replace))

if __name__ == "__main__":
    app = PKGMacheteApp()
    app.mainloop()
