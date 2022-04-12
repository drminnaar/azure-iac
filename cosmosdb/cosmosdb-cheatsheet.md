# Cosmos DB Cheatsheet

## Manage Cosmos DB SQL

### List Cosmos Db Accounts

```pwsh
az cosmosdb list --output jsonc | jq ".[].name"

# powershell
Get-AzCosmosDBAccount -ResourceGroupName $rgName
Get-AzCosmosDBAccount -ResourceGroupName $rgName | Select-Object -Property Name, InstanceId
```

### Manage Cosmos DB SQL Database

```pwsh
# get help
az cosmosdb sql database --help

# list databases
az cosmosdb sql database list --account-name $accountName --resource-group $rgName --output table

# create sql database
az cosmosdb sql database create --account-name $accountName --resource-group $rgName --name $databaseName

# delete sql database
az cosmosdb sql database delete --account-name $accountName --resource-group $rgName --name $databaseName

# show database details
az cosmosdb sql database show --account-name $accountName --resource-group $rgName --name $databaseName
```

### Manage Cosmos DB SQL Container

```pwsh
# get help
az cosmosdb sql container --help

# list database containers
az cosmosdb sql container list --account-name $accountName --resource-group $rgName --database-name $databaseName

# create container
az cosmosdb sql container create --account-name $accountName --resource-group $rgName --database-name $dbName --partition-key-path $pkPath --name $containerName
```

```pwsh
# get help
Get-Help Get-AzCosmosDbAccount

# list database containers
Get-AzCosmosDBSqlContainer -ResourceGroupName $rgName -AccountName $accountName -DatabaseName $dbName

# create database container
New-AzCosmosDBSqlContainer -ResourceGroupName $rgName -AccountName $accountName -DatabaseName $dbName -Name $containerName -PartitionKeyPath $pkPath -PartitionKeyKind Hash
```