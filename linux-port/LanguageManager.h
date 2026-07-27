#pragma once
#include <QObject>
#include <QString>
#include <QMap>

class LanguageManager : public QObject {
    Q_OBJECT
public:
    static LanguageManager& instance();
    QString get(const QString& key) const;
    void setLanguage(const QString& langCode);
    QStringList availableLanguages() const;
    QString languageName(const QString& langCode) const;

signals:
    void languageChanged();

private:
    LanguageManager();
    QString currentLanguage;
    QMap<QString, QMap<QString, QString>> translations;
    QMap<QString, QString> languageNames;
};
