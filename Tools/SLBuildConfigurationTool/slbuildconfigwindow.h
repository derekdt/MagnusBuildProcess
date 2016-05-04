#ifndef SLBUILDCONFIGWINDOW_H
#define SLBUILDCONFIGWINDOW_H

#include "slprogressionpanelmanager.h"

#include <QMainWindow>
#include <QVector>

namespace Ui {
class SLBuildConfigWindow;
}

class SLBuildConfigWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit SLBuildConfigWindow(QWidget *parent = 0);
    ~SLBuildConfigWindow();

private:
    void SetupConfigurationDirTree();
    void InitializeDelegates();
private slots:
    void ConfigFileSystemLoaded(const QString &path);
    void ConfigFileRowClicked(const QModelIndex& index);
    void LoadConfigFileInfo(const QString& absoluteConfigFilePath);
    void ClearDetailPanelStack();
    QWidget* CreateConfigDetailWidget(const QString& optionNameString, const QString& optionValueString);
    QWidget* CreateDetailPanelWidget(const QStringList& inOptionStrings);
private:
    Ui::SLBuildConfigWindow *ui;
    class QFileSystemModel* m_ConfigFileSystem;
    QVector<QWidget*> m_ConfigPanelVector;
    QString m_ActiveConfigFilePath;
};

#endif // SLBUILDCONFIGWINDOW_H
