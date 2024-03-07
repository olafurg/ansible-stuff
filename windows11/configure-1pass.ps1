# Define the source path (ensure to update this path if your source file is located elsewhere)
$sourcePath = "files/agent.toml"

# Use the LOCALAPPDATA environment variable to construct the destination path
$destinationDir = "$env:LOCALAPPDATA\1Password\config\ssh\"
$destinationPath = Join-Path -Path $destinationDir -ChildPath (Split-Path -Path $sourcePath -Leaf)

# Ensure the destination directory exists
If (-Not (Test-Path -Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force
}

# Copy the file
Copy-Item -Path $sourcePath -Destination $destinationPath -Force

Write-Host "File copied successfully to $destinationPath"
