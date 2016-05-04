#ifndef SLBUILDCONFIGWINDOW_H
#define SLBUILDCONFIGWINDOW_H

#include <QMainWindow>

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
private:
    Ui::SLBuildConfigWindow *ui;
};

#endif // SLBUILDCONFIGWINDOW_H
