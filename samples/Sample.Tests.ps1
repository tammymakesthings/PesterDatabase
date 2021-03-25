Import-Module "Pester"
Import-Module "PesterDatabase"

$db = New-DatabaseContext -Driver "MSSQL" -Server "(local)" -Database "TestDB"
$db | Should -Not -BeNullOrEmpty
$db.GetType().TypeName | Should -Be "PesterDBContext"

$table = Test-GetDBObject -OfType "TABLE" -Named "MyTable" -From $db
$table | Should -Not -BeNullOrEmpty
$db.GetType().TypeName | Should -Be "PesterDBTable"

$table.Columns | Should -Contain "MyColumn"
$table.Records | Where-Object { $_.MyColumn -eq "Foo" } | Should -Not -BeNullOrEmpty
$table.Records.Length | Should -BeGreaterThan 0

$dbParameters = @{
    '@Value' = 43
}
$r = Test-RunDBQuery -From $db `
    -Query "SELECT * FROM MyTable WHERE MyColumn=@Value" `
    -Parameters $dbParameters
$r | Should -Not -BeNullOrEmpty
$r.Length | Should -BeGreaterThan 0
