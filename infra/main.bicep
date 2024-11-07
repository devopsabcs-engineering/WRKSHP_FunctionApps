param azureFunctionName string = 'func-hello-world-${uniqueString(resourceGroup().id)}'
param appInsightsName string = 'appi-func-hello-world-${uniqueString(resourceGroup().id)}'
param storageAccountName string = 'stfunchello${uniqueString(resourceGroup().id)}'
param appServicePlanName string = 'asp-func-hello-world-${uniqueString(resourceGroup().id)}'
param logAnalyticsWorkspaceName string = 'log-func-hello-world-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    retentionInDays: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    WorkspaceResourceId: logAnalyticsWorkspace.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }

  resource storageAccounts_funchelloworldek001_name_default 'blobServices@2023-05-01' = {
    name: 'default'
  }

  resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_funchelloworldek001_name_default 'fileServices@2023-05-01' = {
    name: 'default'
  }

  resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_funchelloworldek001_name_default 'queueServices@2023-05-01' = {
    name: 'default'
  }

  resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_funchelloworldek001_name_default 'tableServices@2023-05-01' = {
    name: 'default'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource azureFunction 'Microsoft.Web/sites@2024-04-01' = {
  name: azureFunctionName
  location: location
  kind: 'functionapp'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${azureFunctionName}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${azureFunctionName}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: appServicePlan.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    vnetBackupRestoreEnabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }

  resource scm 'basicPublishingCredentialsPolicies@2024-04-01' = {
    name: 'scm'
    properties: {
      allow: true
    }
  }

  resource webConfig 'config@2024-04-01' = {
    name: 'web'
    properties: {
      numberOfWorkers: 1
      defaultDocuments: [
        'Default.htm'
        'Default.html'
        'Default.asp'
        'index.htm'
        'index.html'
        'iisstart.htm'
        'default.aspx'
        'index.php'
      ]
      netFrameworkVersion: 'v8.0'
      requestTracingEnabled: false
      remoteDebuggingEnabled: false
      httpLoggingEnabled: false
      acrUseManagedIdentityCreds: false
      logsDirectorySizeLimit: 35
      detailedErrorLoggingEnabled: false
      //publishingUsername: 'REDACTED'
      scmType: 'None'
      use32BitWorkerProcess: false
      webSocketsEnabled: false
      alwaysOn: false
      managedPipelineMode: 'Integrated'
      virtualApplications: [
        {
          virtualPath: '/'
          physicalPath: 'site\\wwwroot'
          preloadEnabled: false
        }
      ]
      loadBalancing: 'LeastRequests'
      experiments: {
        rampUpRules: []
      }
      autoHealEnabled: false
      vnetRouteAllEnabled: false
      vnetPrivatePortsCount: 0
      localMySqlEnabled: false
      ipSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 2147483647
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 2147483647
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictionsUseMain: false
      http20Enabled: false
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      preWarmedInstanceCount: 0
      functionAppScaleLimit: 200
      functionsRuntimeScaleMonitoringEnabled: false
      minimumElasticInstanceCount: 0
      azureStorageAccounts: {}
    }
  }
}

// resource azureFunctionHttpExample 'Microsoft.Web/sites/functions@2024-04-01' = {
//   parent: azureFunction
//   name: 'HttpExample'
//   properties: {
//     script_href: 'https://func-hello-world-ek001.azurewebsites.net/admin/vfs/site/wwwroot/WRKSHP_FunctionApps.dll'
//     test_data_href: 'https://func-hello-world-ek001.azurewebsites.net/admin/vfs/data/Functions/sampledata/HttpExample.dat'
//     href: 'https://func-hello-world-ek001.azurewebsites.net/admin/functions/HttpExample'
//     config: {
//       name: 'HttpExample'
//       entryPoint: 'DevOpsABCs.Function.HttpExample.Run'
//       scriptFile: 'WRKSHP_FunctionApps.dll'
//       language: 'dotnet-isolated'
//       functionDirectory: ''
//       bindings: [
//         {
//           name: 'req'
//           type: 'httpTrigger'
//           direction: 'In'
//           authLevel: 'Function'
//           methods: [
//             'get'
//             'post'
//           ]
//         }
//         {
//           name: '$return'
//           type: 'http'
//           direction: 'Out'
//         }
//       ]
//     }
//     invoke_url_template: 'https://func-hello-world-ek001.azurewebsites.net/api/httpexample'
//     language: 'dotnet-isolated'
//     isDisabled: false
//   }
// }
