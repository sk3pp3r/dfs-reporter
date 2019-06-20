##############################################################
# This script Export List of Sub-folder-DFS in dfsroot  
# and report Folder Paths vs folder targets.
#
# Haim Cohen 04-23-2019
# Version 1.0
##############################################################

Clear-Host
$date = get-date
$dfspath = "\FULL\PATH\OF\DFS\ROOT\*" # target dfs folder to report (e.g. \\server99\\dfsroot\*).
$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@


    #Get a list of all subfolders in dfsroot 
    Write-Progress -Activity "1/3 - Getting List of DFSRoot "
    $RootList = Get-DfsnFolder -Path $dfspath
 
    
    #Get a list of all Folder Targets in the Folder Paths, in the Namespaces"
    Write-Progress -Activity "2/3 - Getting List of Folder Targets"
    $FolderTargets = foreach ($item in $RootList)
    {
        Get-DfsnFolderTarget -Path $item.Path    
    }
	
	
	# Print List of Folder Targets
	Write-Progress -Activity "3/3 - Print list of Folder Targets"
    	
    return $FolderTargets |ConvertTo-Html -Property path, TargetPath -Head $Header -pre "<h2>DFS Folder Target Report</h2><br>Date of report $date</h2>" -post "<h3>Created by Haim Cohen Using PowerShell Script</h3>" | Out-File -FilePath .\dfs_report.html
    Invoke-Item  .\dfs_report.html
    