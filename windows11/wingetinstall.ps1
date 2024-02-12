# PowerShell script to install applications using winget

# List of applications to install (Replace the placeholders with actual package IDs)
$apps = @(
    "AltSnap.AltSnap",
    "XP8C9QZMS2PC1T", # Brave Browser, msstore
    "Git.Git",
    "XP89DCGQ3K6VLD", # MS PowerToys, msstore
    "OpenWhisperSystems.Signal",
    "9NCBCSZSJRSB" # Spotify, msstore
    # Add more package IDs here
)

# Iterate over each application and install it
foreach ($app in $apps) {
    Write-Output "Installing $app..."
    winget install $app --accept-package-agreements --accept-source-agreements
}

Write-Output "All applications have been installed."
