#pragma once
#include <QMainWindow>
#include <QProcess>
#include <QProgressBar>
#include <QTextEdit>
#include <QLabel>
#include <QPushButton>
#include <QComboBox>
#include <QVBoxLayout>
#include <QMap>
#include <QString>
#include <QTimer>

class MainWindow : public QMainWindow {
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow() override;

protected:
    void dragEnterEvent(QDragEnterEvent *event) override;
    void dropEvent(QDropEvent *event) override;
    void paintEvent(QPaintEvent *event) override;

private slots:
    void updateTexts();
    void selectFolder();
    void selectOutputFolder();
    void startMerge();
    void processReadyRead();
    void processFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void processError(QProcess::ProcessError error);

private:
    void setupUi();
    void parseOutput(const QString& output);

    QString selectedFolder;
    QString outputFolder;
    QProcess *process;

    // UI elements
    QComboBox *langCombo;
    QLabel *headerLabel;
    QLabel *dropZoneLabel;
    QPushButton *btnSelectFolder;
    QLabel *outputLabel;
    QPushButton *btnSelectOutput;
    QProgressBar *progressBar;
    QLabel *statusLabel;
    QLabel *etaLabel;
    QTextEdit *consoleLog;
    QPushButton *btnMerge;
    
    // state
    QMap<int, double> threadProgress;
    double globalProgress;
    qint64 startTime;
    
    // throttling
    QString logBuffer;
    QTimer *logTimer;
};
