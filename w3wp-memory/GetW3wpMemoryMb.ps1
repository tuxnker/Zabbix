param(
	[string]
	$appPoolName = ""
)

$sum = Get-WmiObject -NameSpace 'root\WebAdministration' -class 'WorkerProcess' | 
	#If a named app pool was passed in, restict the query to just that - otherwise get all app pools
	?{ $appPoolName -eq "" -or $_.AppPoolName -eq $appPoolName } |
	Select-Object AppPoolName, ProcessId, @{Name = "PrivateMemorySize"; Expression = {
				(Get-Process -Id $_.ProcessId).PrivateMemorySize64 / 1Mb
		}
	} |
	#There can be more than one process running one appPool (think recycling), so we need to sum the private bytes
	Measure-Object PrivateMemorySize -sum | 
	%{
		$_.Sum
	}

#Make sure we always return a value, even if there are no w3wp processes running
$sum += 0.0
$sum