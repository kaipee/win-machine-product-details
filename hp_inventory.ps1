$machines = Get-ChildItem .\machines.txt
$Servers = Get-content $machines

foreach($Server in $Servers){

    #Read HP product number from registry
    $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Server)
    $regkey = $reg.OpenSubkey("HARDWARE\\DESCRIPTION\\System\\BIOS")
    $SystemSku = $regkey.GetValue("SystemSku")

    #Get Manufacturer, Model, SerialNumber from WMI query
    $HardwareInfo = Get-WmiObject win32_computersystem -ComputerName $Server
    $SerialNumber = Get-WmiObject win32_bios -ComputerName $Server

    #Create a CSV file with Inventory information
    $Server + "," + $HardwareInfo.Manufacturer + "," + $HardwareInfo.Model + "," + $SerialNumber.SerialNumber + "," + $SystemSku | Add-Content inventory.csv


    Remove-Variable REG, regkey, SystemSku
    Remove-Variable HardwareInfo, SerialNumber, Server
}
Remove-Variable Servers