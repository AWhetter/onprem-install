<#
	.SYNOPSIS
	Docker script for CodeStream. run `Get-Help codestream.ps1 -Full` for help
	.DESCRIPTION
	The CodeStream On-Prem Administration Guide is here:
	https//docs.codestream.com/onprem/
	.EXAMPLE
	PS> codestream.ps1 -Status
	.LINK
	support: support@codestream.com
#>

[cmdletbinding(SupportsShouldProcess=$true)]
Param ( 
	[switch]
	# Get up and running with CodeStream using this option. Begin here.
	$Quickstart = $false,
	[switch]
	# docker compose down, removes ALL CodeStream containers
	$Down = $false,
	[switch]
	# Resets and removes all CodeStream containers except mongo
	$Reset = $false,
	[switch]
	# Restarts the containers
	$Restart = $false,
    [switch]
	# Starts the containers
	$Start = $false,
	[switch]
	# Writes the containers status
	$Status = $false, 
	[switch]
	# Stops the containers
	$Stop = $false,
	[switch]
	# Updates the container versions
	$UpdateContainers = $false,
	[switch]
	# Updates this script
	$UpdateMyself = $false,

	[switch]
	# undocumented. create the docker compose file
	$BuildDockerCompose = $false
)
#----------------[ Declarations ]----------------

# Set Error Action
# $ErrorActionPreference = "Continue"

# Set any initial values
# NOTE: $HOME is built-in
$CS_ROOT="$HOME/.codestream";
[System.Environment]::SetEnvironmentVariable('CS_ROOT', $CS_ROOT, [System.EnvironmentVariableTarget]::User)
$INSTALLATION_BRANCH=Get-Content -Path "$CS_ROOT\installation-branch" -ErrorAction SilentlyContinue;
$CS_INSTALLATION_BRANCH=if ($INSTALLATION_BRANCH -eq $null) { "master" } else { $INSTALLATION_BRANCH }

class DockerService {	
	# this is the name in the ini file
	[string]$settingsName;
	# this is the name of the service in docker-compose
    [string]$name;
	# the image name from ini
    [string]$imageName;
	# the image version from ini
    [string]$imageVersion;
	# environment variables for this container
	[string[]]$envVars;
	# ports, if any
    [string[]]$ports;
	# mounted volumes, if any, formatted as /local/path:/container/path
    [string[]]$volumes;

    DockerService(	
	[string]$settingsName,
    [string]$name,
    [string]$imageName,
    [string]$imageVersion,
	[string[]]$envVars = $null,
    [string[]]$ports = $null,
    [string[]]$volumes = $null
    ) {
		$this.settingsName = $settingsName;
        $this.name = $name
        $this.imageName = $imageName
        $this.imageVersion = $imageVersion
		$this.envVars = $envVars
        $this.ports = $ports
        $this.volumes = $volumes        
    }
}
$containerEnvironmentVariables = @(
	"CSSVC_CFG_URL=mongodb://csmongo/codestream",
	"CS_API_DEFAULT_CFG_FILE=/opt/config/codestream-services-config.json"
);
$dockerServices = @(
 [DockerService]::new("mongo",       "csmongo",     "mongo",   "0.0.0", $null, $null, $null)
,[DockerService]::new("rabbit",      "csrabbitmq",  "unknown", "0.0.0", $containerEnvironmentVariables, $null, @("{CS_ROOT}:/opt/config"))
,[DockerService]::new("broadcaster", "csbcast",     "unknown", "0.0.0", $containerEnvironmentVariables, @('12004:12004'), @("{CS_ROOT}:/opt/config"))
,[DockerService]::new("api",         "csapi",       "unknown", "0.0.0", $containerEnvironmentVariables, @('12000:12000'), @("{CS_ROOT}:/opt/config"))
,[DockerService]::new("mailout",     "csmailout",   "unknown", "0.0.0", $containerEnvironmentVariables, $null, @("{CS_ROOT}:/opt/config"))
,[DockerService]::new("opadm",       "csadmin",     "unknown", "0.0.0", $containerEnvironmentVariables, @('12002:12002'), @("{CS_ROOT}:/opt/config"))
)

$ALL_CONTAINERS = $dockerServices | Select-Object -Property name | ForEach { $_.name}
$CS_CONTAINERS = $dockerServices | Where-Object { $_.settingsName -ne "mongo"} | Select-Object -Property name | ForEach { $_.name}
$dockerComposeTemplate = "version: '3.9'`nservices:`n"

Function StartContainers { docker-compose start }

#----------------[ Functions ]------------------
Function Quickstart {
	Write-Verbose "Quickstart..."

	if (-not(Test-Path -Path "$CS_ROOT\.tos-agreed")) {
		Read-Host -Prompt "
		Before proceeding with the installation, you will need to accept our
		Terms of Service. 		
		You'll then need agree to the terms to continue with the installation.		
		Press ENTER to read our Terms of Service..." 
		if (-not(Test-Path -Path "$CS_ROOT\terms.txt")) {
			Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TeamCodeStream/onprem-install/$CS_INSTALLATION_BRANCH/docs/src/assets/terms.txt" -OutFile "$CS_ROOT\terms.txt"
		}
		$content = Get-Content -Path "$CS_ROOT/terms.txt" -Raw -Encoding "UTF8"
		Write-Host $content

		$val = Read-Host "If you agree to these terms, please type 'i agree'"
		if ($val -ne "i agree") {
			Write-Verbose "did not agree, exiting..."
			exit 1
			return;
		}
		"ok" | Out-File -Encoding "UTF8" -FilePath "$CS_ROOT\.tos-agreed"
		Write-Verbose "Wrote $CS_ROOT\.tos-agreed"
	}
 
	LoadContainerVersions

	Write-Host "Running 'docker-compose -p 'codestream' up'...";	
	# $docker = "docker-compose"
	# $arguments = "up"
	# start-process -NoNewWindow $docker $arguments
	docker-compose -p "codestream" up
}

Function UpdateContainerVersion {
	Write-Verbose "Downloading latest from branch $CS_INSTALLATION_BRANCH... to $CS_ROOT\container-versions"
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TeamCodeStream/onprem-install/$CS_INSTALLATION_BRANCH/versions/preview-single-host.ver.beta" -OutFile "$CS_ROOT\container-versions"
}

Function LoadContainerVersions {
	Write-Verbose "LoadContainerVersions..."

	if (-not(Test-Path -Path "$CS_ROOT\container-versions")) {
		try {
			Write-Verbose "'container-versions' not found, updating container versions..."
			UpdateContainerVersion;
		}
		catch {
			Write-Host $_.Exception.Message		 
		}
	}
	# else {
	# 	Write-Host "Cannot create [$file] because a file with that name already exists."
	# }
	
	$versions = ConvertFrom-StringData((Get-Content "$CS_ROOT\container-versions") -join "`n")
	$versions.Keys | ForEach-Object {
		if ($_.Contains("Repo")) { 
			$key = ($_ -Replace "mqRepo","" -Replace "Repo", "" )
			$service = $dockerServices | Where-Object { $_.settingsName -eq $key} | Select -First 1	
			if ($service -ne $null) {
				$service.imageName =$versions[$_];
			}
			else {
				Write-Verbose "Warn: $key not found"
			}
		}
		if ($_.Contains("DockerVersion")) {	
			$key = ($_ -Replace "DockerVersion" )	 
			$service = $dockerServices | Where-Object { $_.settingsName -eq $key } | Select -First 1
			if ($service -ne $null) {
				$service.imageVersion =$versions[$_];
			}
			else {
				Write-Verbose "Warn: $key not found"
			}
		}
	}

	$str = $dockerComposeTemplate
	$dockerServices | ForEach-Object {
		$str+=" $($_.name):`n"
		$str+="  image: $($_.imageName):$($_.imageVersion)`n"
		if ($_.ports -ne $null) {
			$str+="  ports:`n"  
			$str+="    - $($_.ports)`n"
		}
		if ($_.volumes -ne $null) {
			$str+="  volumes:`n";  
			$_.volumes | ForEach-Object {
				$str+="    - $_`n"
			}   
		}
		if ($_.envVars -ne $null) {
			$str+="  environment:`n";  
			$_.envVars | ForEach-Object {
				$str+="    - $_`n"
			}   
		}
	}
	$str -Replace "{CS_ROOT}",$CS_ROOT | Out-File -Encoding "UTF8" -FilePath "docker-compose.yml"
	Write-Verbose "docker-compose.yml created"
}
  
Function DockerStatus {  
  docker ps -a
  docker volume ls -f name=csmongodata
}

Function ContainerState{
	Param(
	  [string]$Container
	)  
	$ret = docker inspect --format='{{.State.Status}}' $Container 
	return $ret;
}

Function StopContainers { 
	Write-Verbose "Stopping.."
	docker-compose -p "codestream" stop
}

Function StartContainers { 
	Write-Verbose "Starting.."
	docker-compose -p "codestream" start
}

Function ResetContainers {	
	Write-Host "Removing containers..."
	StopContainers;
	foreach ($container in $CS_CONTAINERS) {
		$container = $("codestream_$($container)_1")
		docker rm $container
		Write-Host "Removed $container"
	}
}

Function DownContainers {	
	Write-Host "Going down..."
	docker-compose -p "codestream" down
}

Function RestartContainers { 
	Write-Verbose "Restarting.."
	docker-compose -p "codestream" restart
}

Function UpdateMyself {
	Write-Verbose "Updating self from branch $CS_INSTALLATION_BRANCH to codestream.ps1"
	Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TeamCodeStream/onprem-install/$CS_INSTALLATION_BRANCH/install-scripts/codestream" -OutFile "$CS_ROOT/codestream.ps1"
}

#----------------[ Main Execution ]---------------

# Script Execution goes here and can call any of the functions above.

if ($Quickstart -eq $true) {
	Quickstart;
}
elseif ($Down -eq $true) {
	$confirmation = Read-Host "Are you sure you want to run 'docker-compose down'? (y/N)"
	if ($confirmation -eq 'y') {
		DownContainers;
	}
}
elseif ($Start -eq $true) {
	StartContainers;
}
elseif ($Stop -eq $true) {
	StopContainers;
}
elseif ($Reset -eq $true) {
	ResetContainers;
}
elseif ($Restart -eq $true) {
	RestartContainers;
}
elseif ($Status -eq $true) {
	DockerStatus;
}
elseif ($UpdateContainers -eq $true) {
	StopContainers;
	# backup?
	ResetContainers;
	UpdateContainerVersions;
	LoadContainerVersions
}
elseif ($UpdateMyself -eq $true) {
	UpdateMyself;
}
elseif ($BuildDockerCompose -eq $true) {
	LoadContainerVersions;
}
else {
	if ($args.Count -eq 0) {
		Get-Help $MyInvocation.MyCommand.Definition
		return
	}
}