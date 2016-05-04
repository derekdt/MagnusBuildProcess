#include "slbuildconfigwindow.h"
#include "ui_slbuildconfigwindow.h"

#include <QFileSystemModel>
#include <QtDebug>
#include <QSettings>
#include <QFileSystemModel>
#include <QTreeWidgetItemIterator>
#include <QFileInfo>
#include <QToolButton>
#include <QToolBox>
#include <QLabel>
#include <QListWidgetItem>

SLBuildConfigWindow::SLBuildConfigWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::SLBuildConfigWindow)
{
    ui->setupUi(this);

    QSettings::setDefaultFormat(QSettings::IniFormat);

    ui->statusBar->showMessage("Root: " + QDir::currentPath());
    SetupConfigurationDirTree();
}

void SLBuildConfigWindow::InitializeDelegates()
{
    // Catch the signal emitted by the config file system once it is done loading the config file system
    QObject::connect(m_ConfigFileSystem, SIGNAL(directoryLoaded(const QString)),
                        this, SLOT(ConfigFileSystemLoaded(const QString&)));

    QObject::connect(ui->buildProcessDirTree, SIGNAL(clicked(QModelIndex)),
                        this, SLOT(ConfigFileRowClicked(QModelIndex)));
}

void SLBuildConfigWindow::SetupConfigurationDirTree()
{
    QStringList configFileFilterList;

    // Populate the QTreeView with the contents of the current directory the tool is running in
    m_ConfigFileSystem = new QFileSystemModel;

    InitializeDelegates();

    configFileFilterList.push_back("*.ini");

    m_ConfigFileSystem->setNameFilters(configFileFilterList);
    m_ConfigFileSystem->setNameFilterDisables(false);

    qDebug() << "Current Path: " << QDir::currentPath();
    m_ConfigFileSystem->setRootPath(QDir::currentPath());
    ui->buildProcessDirTree->setModel(m_ConfigFileSystem);
    ui->buildProcessDirTree->setRootIndex(m_ConfigFileSystem->index(QDir::currentPath()));
}

void SLBuildConfigWindow::LoadConfigFileInfo(const QString& absoluteConfigFilePath)
{
    // Only destruct the config panel stack if we select a different config file
    /*if (absoluteConfigFilePath != m_ActiveConfigFilePath)
    {
        m_ActiveConfigFilePath = absoluteConfigFilePath;

        // Clear out the configDetailsPanel for new file
        ClearDetailPanelStack();

        // Push on the first initial group list panel
        QListWidget* groupListWidget = new QListWidget;

        m_ConfigDetailStack.push(groupListWidget);

        // Load the configDetailPanel with the contents
        QSettings configSettings(absoluteConfigFilePath,QSettings::IniFormat);

        QStringList groupStrings = configSettings.childGroups();

        for (const auto& currentGroup : groupStrings)
        {
            configSettings.beginReadArray(currentGroup); // Set current group as current group context
            QStringList optionStrings = configSettings.childKeys();

            for (int i = 0;i < optionStrings.size(); ++i)
            {
                QListWidgetItem* newListWidget = new QListWidgetItem;
                ui->configWidgetList->addItem(newListWidget);
                ui->configWidgetList->setItemWidget(newListWidget,CreateConfigDetailWidget(optionStrings[i],configSettings.value(optionStrings[i]).toString()));
            }

            configSettings.endArray();
        }
    }*/
}

void SLBuildConfigWindow::ClearDetailPanelStack()
{

}

// Generates the widget for each option in a config file
QWidget* SLBuildConfigWindow::CreateConfigDetailWidget(const QString& optionNameString, const QString& optionValueString)
{
    return nullptr;
}

/*void SLBuildConfigWindow::ClearConfigDetailWidget(QLayout* currentLayout)
{
    while (QLayoutItem* item = ui->configDetailsPanel->takeAt(0))
    {
        if (QWidget* widget = item->widget())
        {
            delete widget;
        }

        if (QLayout* innerLayout = item->layout())
        {
            ClearConfigDetailWidget(innerLayout);
        }

        delete item;
    }
}*/

void SLBuildConfigWindow::ConfigFileSystemLoaded(const QString &path)
{
    for (int i = 0;i < m_ConfigFileSystem->columnCount(); ++i)
    {
        ui->buildProcessDirTree->resizeColumnToContents(i);
    }
}

void SLBuildConfigWindow::ConfigFileRowClicked(const QModelIndex& index)
{
    // Check if the selected file is of the .ini extension
    QFileInfo clickedFileInfo = m_ConfigFileSystem->fileInfo(index);

    if (clickedFileInfo.suffix() == "ini")
    {
        LoadConfigFileInfo(clickedFileInfo.absoluteFilePath());
    }
}

SLBuildConfigWindow::~SLBuildConfigWindow()
{
    delete ui;
    delete m_ConfigFileSystem;
}
