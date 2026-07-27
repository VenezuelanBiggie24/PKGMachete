#include "MainWindow.h"
#include "LanguageManager.h"
#include <QDragEnterEvent>
#include <QDropEvent>
#include <QMimeData>
#include <QPainter>
#include <QFileDialog>
#include <QJsonDocument>
#include <QJsonObject>
#include <QApplication>
#include <QDateTime>
#include <QHBoxLayout>
#include <QCoreApplication>
#include <QUrl>
#include <QMessageBox>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), process(nullptr), globalProgress(0), startTime(0), logTimer(new QTimer(this)) {
    connect(logTimer, &QTimer::timeout, this, [this]() {
        if (!logBuffer.isEmpty()) {
            if (logBuffer.endsWith('\n')) {
                logBuffer.chop(1);
            }
            consoleLog->append(logBuffer);
            logBuffer.clear();
            
            QTextCursor cursor = consoleLog->textCursor();
            cursor.movePosition(QTextCursor::End);
            consoleLog->setTextCursor(cursor);
        }
    });

    setAcceptDrops(true);
    setMinimumSize(700, 500);
    setWindowTitle("PKGMachete Linux");
    
    // Set up style (Cyberpunk/Glassmorphism feel)
    setStyleSheet(R"(
        QWidget {
            color: #ffffff;
            font-family: monospace;
        }
        QLabel {
            color: #ffffff;
        }
        QPushButton {
            background-color: #1f2833;
            color: #00ffff;
            border: 1px solid #45a29e;
            border-radius: 6px;
            padding: 8px;
            font-weight: bold;
        }
        QPushButton:hover {
            background-color: #45a29e;
            color: #0b0c10;
        }
        QPushButton:disabled {
            background-color: #2b2b2b;
            color: #555555;
            border: 1px solid #444444;
        }
        QTextEdit {
            background-color: rgba(0, 0, 0, 0.5);
            color: #00ff00;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
        }
        QComboBox {
            background-color: #1f2833;
            color: #00ffff;
            border: 1px solid #45a29e;
            border-radius: 4px;
        }
        QProgressBar {
            background-color: #1f2833;
            border: 1px solid #45a29e;
            border-radius: 4px;
            text-align: center;
            color: white;
        }
        QProgressBar::chunk {
            background-color: #00ffff;
        }
    )");

    setupUi();
    connect(&LanguageManager::instance(), &LanguageManager::languageChanged, this, &MainWindow::updateTexts);
    updateTexts();
}

MainWindow::~MainWindow() {
    if (process) {
        process->kill();
        process->waitForFinished();
    }
}

void MainWindow::setupUi() {
    QWidget *centralWidget = new QWidget(this);
    QVBoxLayout *mainLayout = new QVBoxLayout(centralWidget);
    mainLayout->setContentsMargins(30, 20, 30, 20);
    mainLayout->setSpacing(15);
    
    // Header
    QHBoxLayout *headerLayout = new QHBoxLayout();
    langCombo = new QComboBox();
    for (const QString& code : LanguageManager::instance().availableLanguages()) {
        langCombo->addItem(LanguageManager::instance().languageName(code), code);
    }
    connect(langCombo, QOverload<int>::of(&QComboBox::currentIndexChanged), [this](int index) {
        LanguageManager::instance().setLanguage(langCombo->itemData(index).toString());
    });
    headerLayout->addWidget(langCombo);
    headerLayout->addStretch();
    
    QLabel *versionLabel = new QLabel("v5.0.0");
    versionLabel->setStyleSheet("color: gray;");
    headerLayout->addWidget(versionLabel);
    mainLayout->addLayout(headerLayout);
    
    // Title
    QLabel *titleLabel = new QLabel("🎮 PKGMachete");
    titleLabel->setStyleSheet("font-size: 32px; font-weight: bold; color: white;");
    titleLabel->setAlignment(Qt::AlignCenter);
    mainLayout->addWidget(titleLabel);
    
    // Drop Zone
    dropZoneLabel = new QLabel();
    dropZoneLabel->setAlignment(Qt::AlignCenter);
    dropZoneLabel->setStyleSheet("background-color: rgba(0, 0, 0, 0.3); border: 2px dashed rgba(255, 255, 255, 0.2); border-radius: 16px; font-size: 16px;");
    dropZoneLabel->setMinimumHeight(100);
    mainLayout->addWidget(dropZoneLabel);
    
    btnSelectFolder = new QPushButton();
    btnSelectFolder->setFlat(true);
    btnSelectFolder->setStyleSheet("border: none; color: #00ffff; text-decoration: underline; background: transparent;");
    connect(btnSelectFolder, &QPushButton::clicked, this, &MainWindow::selectFolder);
    mainLayout->addWidget(btnSelectFolder, 0, Qt::AlignCenter);
    
    // Output folder
    QHBoxLayout *outputLayout = new QHBoxLayout();
    outputLabel = new QLabel();
    btnSelectOutput = new QPushButton();
    connect(btnSelectOutput, &QPushButton::clicked, this, &MainWindow::selectOutputFolder);
    outputLayout->addWidget(outputLabel);
    outputLayout->addWidget(btnSelectOutput);
    mainLayout->addLayout(outputLayout);
    
    // Progress
    progressBar = new QProgressBar();
    progressBar->setRange(0, 100);
    progressBar->setValue(0);
    mainLayout->addWidget(progressBar);
    
    QHBoxLayout *statusLayout = new QHBoxLayout();
    statusLabel = new QLabel();
    statusLabel->setStyleSheet("color: #00ffff;");
    etaLabel = new QLabel();
    etaLabel->setStyleSheet("color: #cc88ff;");
    statusLayout->addWidget(statusLabel);
    statusLayout->addStretch();
    statusLayout->addWidget(etaLabel);
    mainLayout->addLayout(statusLayout);
    
    // Log
    QLabel *consoleTitle = new QLabel();
    consoleTitle->setText("Console Output:");
    consoleTitle->setStyleSheet("color: gray; font-size: 10px;");
    mainLayout->addWidget(consoleTitle);
    
    consoleLog = new QTextEdit();
    consoleLog->setReadOnly(true);
    mainLayout->addWidget(consoleLog);
    
    // Merge button
    btnMerge = new QPushButton();
    btnMerge->setMinimumHeight(45);
    btnMerge->setStyleSheet("font-size: 18px; font-weight: bold; background-color: #00ffff; color: #0b0c10; border-radius: 12px;");
    connect(btnMerge, &QPushButton::clicked, this, &MainWindow::startMerge);
    btnMerge->setEnabled(false);
    mainLayout->addWidget(btnMerge);
    
    setCentralWidget(centralWidget);
}

void MainWindow::updateTexts() {
    dropZoneLabel->setText(selectedFolder.isEmpty() ? LanguageManager::instance().get("drag_drop") : selectedFolder);
    btnSelectFolder->setText(LanguageManager::instance().get("select_manually"));
    outputLabel->setText(LanguageManager::instance().get("output_label") + " " + (outputFolder.isEmpty() ? LanguageManager::instance().get("same_as_input") : outputFolder));
    btnSelectOutput->setText(LanguageManager::instance().get("change_btn"));
    
    if (process && process->state() != QProcess::NotRunning) {
        btnMerge->setText(LanguageManager::instance().get("merging"));
    } else {
        btnMerge->setText(LanguageManager::instance().get("start_merge"));
    }
    
    if (statusLabel->text().isEmpty() || statusLabel->text() == LanguageManager::instance().get("waiting")) {
        statusLabel->setText(LanguageManager::instance().get(selectedFolder.isEmpty() ? "waiting" : "ready"));
    }
}

void MainWindow::dragEnterEvent(QDragEnterEvent *event) {
    if (event->mimeData()->hasUrls()) {
        event->acceptProposedAction();
        dropZoneLabel->setStyleSheet("background-color: rgba(0, 255, 255, 0.2); border: 2px dashed #00ffff; border-radius: 16px; font-size: 16px;");
    }
}

void MainWindow::dropEvent(QDropEvent *event) {
    dropZoneLabel->setStyleSheet("background-color: rgba(0, 0, 0, 0.3); border: 2px dashed rgba(255, 255, 255, 0.2); border-radius: 16px; font-size: 16px;");
    const QMimeData *mimeData = event->mimeData();
    if (mimeData->hasUrls()) {
        QList<QUrl> urlList = mimeData->urls();
        if (!urlList.isEmpty()) {
            selectedFolder = urlList.first().toLocalFile();
            updateTexts();
            statusLabel->setText(LanguageManager::instance().get("ready"));
            btnMerge->setEnabled(true);
        }
    }
}

void MainWindow::paintEvent(QPaintEvent *event) {
    QMainWindow::paintEvent(event);
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);

    // Linear gradient background matching SwiftUI's [Color(red: 0.1, green: 0.0, blue: 0.15), Color(red: 0.0, green: 0.05, blue: 0.2)]
    QLinearGradient bgGrad(0, 0, width(), height());
    bgGrad.setColorAt(0, QColor(25, 0, 38)); 
    bgGrad.setColorAt(1, QColor(0, 13, 51)); 
    painter.fillRect(rect(), bgGrad);

    // Purple circle for glassmorphism
    QRadialGradient grad1(0, 0, 300);
    grad1.setColorAt(0, QColor(128, 0, 128, 60));
    grad1.setColorAt(1, Qt::transparent);
    painter.setBrush(grad1);
    painter.setPen(Qt::NoPen);
    painter.drawEllipse(-100, -100, 400, 400);
    
    // Cyan circle for glassmorphism
    QRadialGradient grad2(width(), height(), 300);
    grad2.setColorAt(0, QColor(0, 255, 255, 50));
    grad2.setColorAt(1, Qt::transparent);
    painter.setBrush(grad2);
    painter.drawEllipse(width() - 300, height() - 300, 400, 400);
}

void MainWindow::selectFolder() {
    QString dir = QFileDialog::getExistingDirectory(this, LanguageManager::instance().get("select_manually"));
    if (!dir.isEmpty()) {
        selectedFolder = dir;
        updateTexts();
        statusLabel->setText(LanguageManager::instance().get("ready"));
        btnMerge->setEnabled(true);
    }
}

void MainWindow::selectOutputFolder() {
    QString dir = QFileDialog::getExistingDirectory(this, LanguageManager::instance().get("select_output"));
    if (!dir.isEmpty()) {
        outputFolder = dir;
        updateTexts();
    }
}

void MainWindow::startMerge() {
    if (selectedFolder.isEmpty()) return;
    
    if (process) {
        process->deleteLater();
    }
    
    process = new QProcess(this);
    
    // Path to CLI logic. Could be in same dir.
    QString cliPath = QCoreApplication::applicationDirPath() + "/pkgmachete-cli";
    process->setProgram(cliPath);
    
    QStringList args;
    args << selectedFolder;
    if (!outputFolder.isEmpty()) {
        args << outputFolder;
    }
    process->setArguments(args);
    
    connect(process, &QProcess::readyReadStandardOutput, this, &MainWindow::processReadyRead);
    connect(process, &QProcess::readyReadStandardError, this, &MainWindow::processReadyRead);
    connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &MainWindow::processFinished);
    connect(process, &QProcess::errorOccurred, this, &MainWindow::processError);
    
    consoleLog->clear();
    consoleLog->append("--- PKGMachete Engine Started ---");
    logBuffer.clear();
    logTimer->start(50);
    
    progressBar->setValue(0);
    globalProgress = 0;
    startTime = QDateTime::currentMSecsSinceEpoch();
    
    btnMerge->setEnabled(false);
    btnSelectFolder->setEnabled(false);
    btnSelectOutput->setEnabled(false);
    updateTexts();
    
    process->start();
}

void MainWindow::processReadyRead() {
    process->setReadChannel(QProcess::StandardOutput);
    while (process->canReadLine()) {
        QByteArray data = process->readLine();
        QString output = QString::fromUtf8(data);
        parseOutput(output);
    }
    
    process->setReadChannel(QProcess::StandardError);
    while (process->canReadLine()) {
        QByteArray data = process->readLine();
        QString output = QString::fromUtf8(data);
        logBuffer.append("[STDERR] " + output.trimmed() + "\n");
    }
}

void MainWindow::parseOutput(const QString& output) {
    QStringList lines = output.split('\n', Qt::SkipEmptyParts);
    for (const QString& line : lines) {
        QString trimmed = line.trimmed();
        if (trimmed.isEmpty()) continue;
        
        QJsonDocument doc = QJsonDocument::fromJson(trimmed.toUtf8());
        if (!doc.isNull() && doc.isObject()) {
            QJsonObject obj = doc.object();
            QString type = obj["type"].toString();
            
            if (type == "progress") {
                if (obj.contains("global")) {
                    globalProgress = obj["global"].toDouble();
                    progressBar->setValue(globalProgress);
                    
                    qint64 elapsed = QDateTime::currentMSecsSinceEpoch() - startTime;
                    if (globalProgress > 0) {
                        double totalEstimated = (elapsed / (globalProgress / 100.0));
                        double remaining = totalEstimated - elapsed;
                        if (remaining > 0) {
                            etaLabel->setText(LanguageManager::instance().get("eta") + QString(" %1s").arg(int(remaining / 1000)));
                        }
                    }
                }
                double prog = obj["progress"].toDouble();
                int thread = obj.contains("thread") ? obj["thread"].toInt() : obj["part"].toInt();
                threadProgress[thread] = prog;
                logBuffer.append(QString("> [SYS] THREAD_%1 ACTIVE | PROG: %2% | GLOBAL: %3%\n")
                    .arg(thread, 2, 10, QChar('0'))
                    .arg(prog, 5, 'f', 2)
                    .arg(globalProgress, 5, 'f', 2));
            } else if (type == "error") {
                logBuffer.append("[ERROR] " + obj["message"].toString() + "\n");
                statusLabel->setText(obj["message"].toString());
            } else if (type == "success") {
                logBuffer.append("[SUCCESS] " + obj["message"].toString() + "\n");
                statusLabel->setText(obj["message"].toString());
            } else {
                logBuffer.append("[INFO] " + obj["message"].toString() + "\n");
            }
        } else {
            logBuffer.append(trimmed + "\n");
            if (trimmed.contains("merged") && trimmed.contains("bytes")) {
                statusLabel->setText(trimmed);
            }
        }
    }
}

void MainWindow::processError(QProcess::ProcessError error) {
    logTimer->stop();
    if (!logBuffer.isEmpty()) {
        if (logBuffer.endsWith('\n')) logBuffer.chop(1);
        consoleLog->append(logBuffer);
        logBuffer.clear();
    }
    consoleLog->append(QString("\n--- Execution Error: %1 ---").arg(process->errorString()));
    statusLabel->setText(LanguageManager::instance().get("failed_run") + " " + process->errorString());
    btnMerge->setEnabled(true);
    btnSelectFolder->setEnabled(true);
    btnSelectOutput->setEnabled(true);
    updateTexts();
}

void MainWindow::processFinished(int exitCode, QProcess::ExitStatus exitStatus) {
    logTimer->stop();
    if (!logBuffer.isEmpty()) {
        if (logBuffer.endsWith('\n')) logBuffer.chop(1);
        consoleLog->append(logBuffer);
        logBuffer.clear();
    }
    
    if (exitStatus == QProcess::NormalExit && exitCode == 0) {
        consoleLog->append("\n--- Merge Completed ---");
        progressBar->setValue(100);
        statusLabel->setText(LanguageManager::instance().get("success"));
        etaLabel->clear();
    } else {
        consoleLog->append(QString("\n--- Merge Failed (Code %1) ---").arg(exitCode));
        statusLabel->setText(LanguageManager::instance().get("err_code") + " " + QString::number(exitCode));
    }
    
    btnMerge->setEnabled(true);
    btnSelectFolder->setEnabled(true);
    btnSelectOutput->setEnabled(true);
    updateTexts();
}
