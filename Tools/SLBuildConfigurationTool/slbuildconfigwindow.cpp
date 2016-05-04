#include "slbuildconfigwindow.h"
#include "ui_slbuildconfigwindow.h"

#include <QFileSystemModel>
#include <QtDebug>

SLBuildConfigWindow::SLBuildConfigWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::SLBuildConfigWindow)
{
    ui->setupUi(this);

    ui->statusBar->showMessage("Root: " + QDir::currentPath());

    SetupConfigurationDirTree();
}

void SLBuildConfigWindow::SetupConfigurationDirTree()
{
    // Populate the QTreeView with the contents of the current directory the tool is running in
    QFileSystemModel* configFileModel = new QFileSystemModel;
    QStringList configFileFilterList;

    configFileFilterList.push_back("*.ini");

    configFileModel->setNameFilters(configFileFilterList);
    configFileModel->setNameFilterDisables(false);

    qDebug() << "Current Path: " << QDir::currentPath();
    configFileModel->setRootPath(QDir::currentPath());
    ui->buildProcessDirTree->setModel(configFileModel);
    ui->buildProcessDirTree->setRootIndex(configFileModel->index(QDir::currentPath()));
}

SLBuildConfigWindow::~SLBuildConfigWindow()
{
    delete ui;
}
