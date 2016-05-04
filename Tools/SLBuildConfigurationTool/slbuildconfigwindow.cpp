#include "slbuildconfigwindow.h"
#include "ui_slbuildconfigwindow.h"

#include <QFileSystemModel>
#include <QtDebug>
#include <QSettings>
#include <QFileSystemModel>
#include <QTreeWidgetItemIterator>
#include <QFileInfo>
#include <QPushButton>
#include <QToolBox>
#include <QLabel>
#include <QListWidgetItem>

SLBuildConfigWindow::SLBuildConfigWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::SLBuildConfigWindow)
{
    ui->setupUi(this);
    ui->mainWidgetFrame->setLayout(new QHBoxLayout);

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
    if (absoluteConfigFilePath != m_ActiveConfigFilePath)
    {
        m_ActiveConfigFilePath = absoluteConfigFilePath;

        // Clear out the configDetailsPanel for new file
        ClearDetailPanelStack();

        // Load the configDetailPanel with the contents
        QToolBox* groupPanelToolBox = new QToolBox;
        QSettings configSettings(absoluteConfigFilePath,QSettings::IniFormat);
        QStringList groupStrings = configSettings.childGroups();

        for (const auto& currentGroup : groupStrings)
        {
            configSettings.beginReadArray(currentGroup);
            QStringList optionStrings = configSettings.childKeys();
            QListWidget* optionListWidget = new QListWidget;
            QVBoxLayout* optionListLayout = new QVBoxLayout;

            optionListLayout->setAlignment(Qt::AlignTop);
            optionListWidget->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
            optionListWidget->setLayout(optionListLayout);

            for (const auto& optionString : optionStrings)
            {
                optionListWidget->layout()->addWidget(new QPushButton(optionString));
            }

            groupPanelToolBox->addItem(optionListWidget, currentGroup);

            configSettings.endArray();
        }

        ui->mainWidgetFrame->layout()->addWidget(groupPanelToolBox);
        m_ConfigPanelVector.push_back(groupPanelToolBox);
    }
}

void SLBuildConfigWindow::ClearDetailPanelStack()
{
    for (auto& currentWidget : m_ConfigPanelVector)
    {
        delete currentWidget;
        currentWidget = nullptr;
    }

    m_ConfigPanelVector.clear();
}

// Generates the widget for each option in a config file
QWidget* SLBuildConfigWindow::CreateConfigDetailWidget(const QString& optionNameString, const QString& optionValueString)
{
    return nullptr;
}

QWidget* SLBuildConfigWindow::CreateDetailPanelWidget(const QStringList& inOptionStrings)
{
    return nullptr;
}

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
