#ifndef SLBUILDCONFIGWINDOW_H
#define SLBUILDCONFIGWINDOW_H

#include "slprogressionpanelmanager.h"

#include <QMainWindow>
#include <QStack>

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
private:
    Ui::SLBuildConfigWindow *ui;
    class QFileSystemModel* m_ConfigFileSystem;
    SLProgressionPanelManager m_ProgressionManager;
};

#endif // SLBUILDCONFIGWINDOW_H
