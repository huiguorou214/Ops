# Poewrshell 命令集 cmdlets

> 本文复制于：<https://www.pstips.net/powershell-cmdlets.html>



cmdlets是Powershell的内部命令，cmdlet的类型名为System.Management.Automation.CmdletInfo，包含下列属性和方法：

| Name                | MemberType     | Definition                                                   |
| ------------------- | -------------- | ------------------------------------------------------------ |
| Equals              | Method         | bool Equals(System.Object obj)                               |
| GetHashCode         | Method         | int GetHashCode()                                            |
| GetType             | Method         | type GetType()                                               |
| ToString            | Method         | string ToString()                                            |
| CommandType         | Property       | System.Management.Automation.CommandTypes CommandType {get;} |
| DefaultParameterSet | Property       | System.String DefaultParameterSet {get;}                     |
| Definition          | Property       | System.String Definition {get;}                              |
| HelpFile            | Property       | System.String HelpFile {get;}                                |
| ImplementingType    | Property       | System.Type ImplementingType {get;}                          |
| Module              | Property       | System.Management.Automation.PSModuleInfo Module {get;}      |
| ModuleName          | Property       | System.String ModuleName {get;}                              |
| Name                | Property       | System.String Name {get;}                                    |
| Noun                | Property       | System.String Noun {get;}                                    |
| OutputType          | Property       | System.Collections.ObjectModel.ReadOnlyCollection`1[[System.Management.Automation.PSTypeName, System.Management.Automation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35]] OutputType {get;} |
| Parameters          | Property       | System.Collections.Generic.Dictionary`2[[System.String, mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089],[System.Management.Automation.ParameterMetadata, System.Management.Automation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35]] Parameters {get;} |
| ParameterSets       | Property       | System.Collections.ObjectModel.ReadOnlyCollection`1[[System.Management.Automation.CommandParameterSetInfo, System.Management.Automation, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35]] ParameterSets {get;} |
| PSSnapIn            | Property       | System.Management.Automation.PSSnapInInfo PSSnapIn {get;}    |
| Verb                | Property       | System.String Verb {get;}                                    |
| Visibility          | Property       | System.Management.Automation.SessionStateEntryVisibility Visibility {get;set;} |
| DLL                 | ScriptProperty | System.Object DLL {get=$this.ImplementingType.Assembly.Location;} |
| HelpUri             | ScriptProperty | System.Object HelpUri {get=try { # ok to cast CommandTypes enum to HelpCategory because string/indentifier for # cmdlet,function,filter,alias,externalscript is identical. # it is ok to fail for other enum values (i.e. for Application) $helpObject = get-help -Name ($this.Name) -Category ([string]($this.CommandType)) -ErrorAction SilentlyContinue# return first non-null uri (and try not to hit any strict mode things) if ($helpObject -eq $null) { return $null } if ($helpObject.psobject.properties[‘relatedLinks’] -eq $null) { return $null } if ($helpObject.relatedLinks.psobject.properties[‘navigationLink’] -eq $null) { return $null } $helpUri = [string]$( $helpObject.relatedLinks.navigationLink \| %{ if ($_.psobject.properties[‘uri’] -ne $null) { $_.uri } } \| ?{ $_ } \| select -first 1 ) return $helpUri } catch {};} |



**下面是全部的Cmdlets命令**

每个命令有一个动词和名词组成，命令的作用一目了然。

| Name                              | ModuleName                       | Help                                                  |
| --------------------------------- | -------------------------------- | ----------------------------------------------------- |
| Add-Computer                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135194) |
| Add-Content                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113278) |
| Add-History                       | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113279) |
| Add-Member                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113280) |
| Add-PSSnapin                      | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113281) |
| Add-Type                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135195) |
| Checkpoint-Computer               | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135197) |
| Clear-Content                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113282) |
| Clear-EventLog                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135198) |
| Clear-History                     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135199) |
| Clear-Item                        | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113283) |
| Clear-ItemProperty                | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113284) |
| Clear-Variable                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113285) |
| Compare-Object                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113286) |
| Complete-Transaction              | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135200) |
| Connect-WSMan                     | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141437) |
| ConvertFrom-Csv                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135201) |
| ConvertFrom-SecureString          | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113287) |
| ConvertFrom-StringData            | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113288) |
| Convert-Path                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113289) |
| ConvertTo-Csv                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135203) |
| ConvertTo-Html                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113290) |
| ConvertTo-SecureString            | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113291) |
| ConvertTo-Xml                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135204) |
| Copy-Item                         | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113292) |
| Copy-ItemProperty                 | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113293) |
| Debug-Process                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135206) |
| Disable-ComputerRestore           | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135207) |
| Disable-PSBreakpoint              | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113294) |
| Disable-PSSessionConfiguration    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144299) |
| Disable-WSManCredSSP              | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141438) |
| Disconnect-WSMan                  | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141439) |
| Enable-ComputerRestore            | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135209) |
| Enable-PSBreakpoint               | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113295) |
| Enable-PSRemoting                 | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144300) |
| Enable-PSSessionConfiguration     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144301) |
| Enable-WSManCredSSP               | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141442) |
| Enter-PSSession                   | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135210) |
| Exit-PSSession                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135212) |
| Export-Alias                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113296) |
| Export-Clixml                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113297) |
| Export-Console                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113298) |
| Export-Counter                    | Microsoft.PowerShell.Diagnostics | [help](http://go.microsoft.com/fwlink/?LinkID=138337) |
| Export-Csv                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113299) |
| Export-FormatData                 | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=144302) |
| Export-ModuleMember               | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141551) |
| Export-PSSession                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135213) |
| ForEach-Object                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113300) |
| Format-Custom                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113301) |
| Format-List                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113302) |
| Format-Table                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113303) |
| Format-Wide                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113304) |
| Get-Acl                           | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113305) |
| Get-Alias                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113306) |
| Get-AuthenticodeSignature         | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113307) |
| Get-ChildItem                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113308) |
| Get-Command                       | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113309) |
| Get-ComputerRestorePoint          | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135215) |
| Get-Content                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113310) |
| Get-Counter                       | Microsoft.PowerShell.Diagnostics | [help](http://go.microsoft.com/fwlink/?LinkID=138335) |
| Get-Credential                    | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113311) |
| Get-Culture                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113312) |
| Get-Date                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113313) |
| Get-Event                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113453) |
| Get-EventLog                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113314) |
| Get-EventSubscriber               | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135155) |
| Get-ExecutionPolicy               | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113315) |
| Get-FormatData                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=144303) |
| Get-Help                          | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113316) |
| Get-History                       | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113317) |
| Get-Host                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113318) |
| Get-HotFix                        | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135217) |
| Get-Item                          | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113319) |
| Get-ItemProperty                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113320) |
| Get-Job                           | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113328) |
| Get-Location                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113321) |
| Get-Member                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113322) |
| Get-Module                        | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141552) |
| Get-PfxCertificate                | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113323) |
| Get-Process                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113324) |
| Get-PSBreakpoint                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113325) |
| Get-PSCallStack                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113326) |
| Get-PSDrive                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113327) |
| Get-PSProvider                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113329) |
| Get-PSSession                     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135219) |
| Get-PSSessionConfiguration        | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144304) |
| Get-PSSnapin                      | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113330) |
| Get-Random                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113446) |
| Get-Service                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113332) |
| Get-TraceSource                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113333) |
| Get-Transaction                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135220) |
| Get-UICulture                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113334) |
| Get-Unique                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113335) |
| Get-Variable                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113336) |
| Get-WinEvent                      | Microsoft.PowerShell.Diagnostics | [help](http://go.microsoft.com/fwlink/?LinkID=138336) |
| Get-WmiObject                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113337) |
| Get-WSManCredSSP                  | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141443) |
| Get-WSManInstance                 | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141444) |
| Group-Object                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113338) |
| Import-Alias                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113339) |
| Import-Clixml                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113340) |
| Import-Counter                    | Microsoft.PowerShell.Diagnostics | [help](http://go.microsoft.com/fwlink/?LinkID=138338) |
| Import-Csv                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113341) |
| Import-LocalizedData              | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113342) |
| Import-Module                     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141553) |
| Import-PSSession                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135221) |
| Invoke-Command                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135225) |
| Invoke-Expression                 | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113343) |
| Invoke-History                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113344) |
| Invoke-Item                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113345) |
| Invoke-WmiMethod                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113346) |
| Invoke-WSManAction                | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141446) |
| Join-Path                         | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113347) |
| Limit-EventLog                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135227) |
| Measure-Command                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113348) |
| Measure-Object                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113349) |
| Move-Item                         | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113350) |
| Move-ItemProperty                 | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113351) |
| New-Alias                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113352) |
| New-Event                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135234) |
| New-EventLog                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135235) |
| New-Item                          | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113353) |
| New-ItemProperty                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113354) |
| New-Module                        | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141554) |
| New-ModuleManifest                | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141555) |
| New-Object                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113355) |
| New-PSDrive                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113357) |
| New-PSSession                     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135237) |
| New-PSSessionOption               | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144305) |
| New-Service                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113359) |
| New-TimeSpan                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113360) |
| New-Variable                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113361) |
| New-WebServiceProxy               | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135238) |
| New-WSManInstance                 | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141448) |
| New-WSManSessionOption            | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141449) |
| Out-Default                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113362) |
| Out-File                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113363) |
| Out-GridView                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113364) |
| Out-Host                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113365) |
| Out-Null                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113366) |
| Out-Printer                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113367) |
| Out-String                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113368) |
| Pop-Location                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113369) |
| Push-Location                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113370) |
| Read-Host                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113371) |
| Receive-Job                       | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113372) |
| Register-EngineEvent              | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135243) |
| Register-ObjectEvent              | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135244) |
| Register-PSSessionConfiguration   | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144306) |
| Register-WmiEvent                 | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135245) |
| Remove-Computer                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135246) |
| Remove-Event                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135247) |
| Remove-EventLog                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135248) |
| Remove-Item                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113373) |
| Remove-ItemProperty               | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113374) |
| Remove-Job                        | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113377) |
| Remove-Module                     | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141556) |
| Remove-PSBreakpoint               | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113375) |
| Remove-PSDrive                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113376) |
| Remove-PSSession                  | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=135250) |
| Remove-PSSnapin                   | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113378) |
| Remove-Variable                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113380) |
| Remove-WmiObject                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113381) |
| Remove-WSManInstance              | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141453) |
| Rename-Item                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113382) |
| Rename-ItemProperty               | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113383) |
| Reset-ComputerMachinePassword     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135252) |
| Resolve-Path                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113384) |
| Restart-Computer                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135253) |
| Restart-Service                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113385) |
| Restore-Computer                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135254) |
| Resume-Service                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113386) |
| Select-Object                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113387) |
| Select-String                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113388) |
| Select-Xml                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135255) |
| Send-MailMessage                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135256) |
| Set-Acl                           | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113389) |
| Set-Alias                         | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113390) |
| Set-AuthenticodeSignature         | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113391) |
| Set-Content                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113392) |
| Set-Date                          | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113393) |
| Set-ExecutionPolicy               | Microsoft.PowerShell.Security    | [help](http://go.microsoft.com/fwlink/?LinkID=113394) |
| Set-Item                          | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113395) |
| Set-ItemProperty                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113396) |
| Set-Location                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113397) |
| Set-PSBreakpoint                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113449) |
| Set-PSDebug                       | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113398) |
| Set-PSSessionConfiguration        | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144307) |
| Set-Service                       | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113399) |
| Set-StrictMode                    | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113450) |
| Set-TraceSource                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113400) |
| Set-Variable                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113401) |
| Set-WmiInstance                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113402) |
| Set-WSManInstance                 | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141458) |
| Set-WSManQuickConfig              | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkID=141463) |
| Show-EventLog                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135257) |
| Sort-Object                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113403) |
| Split-Path                        | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113404) |
| Start-Job                         | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113405) |
| Start-Process                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135261) |
| Start-Service                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113406) |
| Start-Sleep                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113407) |
| Start-Transaction                 | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135262) |
| Start-Transcript                  | Microsoft.PowerShell.Host        | [help](http://go.microsoft.com/fwlink/?LinkID=113408) |
| Stop-Computer                     | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135263) |
| Stop-Job                          | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113413) |
| Stop-Process                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113412) |
| Stop-Service                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113414) |
| Stop-Transcript                   | Microsoft.PowerShell.Host        | [help](http://go.microsoft.com/fwlink/?LinkID=113415) |
| Suspend-Service                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113416) |
| Tee-Object                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113417) |
| Test-ComputerSecureChannel        | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=137749) |
| Test-Connection                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135266) |
| Test-ModuleManifest               | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=141557) |
| Test-Path                         | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=113418) |
| Test-WSMan                        | Microsoft.WSMan.Management       | [help](http://go.microsoft.com/fwlink/?LinkId=141464) |
| Trace-Command                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113419) |
| Undo-Transaction                  | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135268) |
| Unregister-Event                  | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135269) |
| Unregister-PSSessionConfiguration | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=144308) |
| Update-FormatData                 | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113420) |
| Update-List                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113447) |
| Update-TypeData                   | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113421) |
| Use-Transaction                   | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135271) |
| Wait-Event                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=135276) |
| Wait-Job                          | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113422) |
| Wait-Process                      | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135277) |
| Where-Object                      | Microsoft.PowerShell.Core        | [help](http://go.microsoft.com/fwlink/?LinkID=113423) |
| Write-Debug                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113424) |
| Write-Error                       | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113425) |
| Write-EventLog                    | Microsoft.PowerShell.Management  | [help](http://go.microsoft.com/fwlink/?LinkID=135281) |
| Write-Host                        | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113426) |
| Write-Output                      | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113427) |
| Write-Progress                    | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113428) |
| Write-Verbose                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113429) |
| Write-Warning                     | Microsoft.PowerShell.Utility     | [help](http://go.microsoft.com/fwlink/?LinkID=113430) |