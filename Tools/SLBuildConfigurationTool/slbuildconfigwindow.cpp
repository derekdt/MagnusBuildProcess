#include "slbuildconfigwindow.h"
#include "ui_slbuildconfigwindow.h"

SLBuildConfigWindow::SLBuildConfigWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::SLBuildConfigWindow)
{
    ui->setupUi(this);
}

SLBuildConfigWindow::~SLBuildConfigWindow()
{
    delete ui;
}
