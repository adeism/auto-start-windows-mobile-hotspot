try {
    $connectionProfile = [Windows.Networking.Connectivity.NetworkInformation, Windows.Networking.Connectivity, ContentType=WindowsRuntime]::GetInternetConnectionProfile()
    $tetheringManager = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager, Windows.Networking.NetworkOperators, ContentType=WindowsRuntime]::CreateFromConnectionProfile($connectionProfile)

    if ($tetheringManager.TetheringOperationalState -ne 'On') {
        $tetheringManager.StartTetheringAsync() | Out-Null
    }
}
catch {
    # Skrip akan berhenti jika ada error (misal: tidak ada koneksi internet)
}
