# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-30

### Added
- **Interval Customization**: Users can now choose check interval (5, 10, or 20 minutes) during installation
- **Comprehensive Logging System**: All activities are now logged with timestamps and status levels (INFO, SUCCESS, ERROR, WARNING)
- **Utility Scripts**:
  - `Check-Status.bat`: Real-time status checker for Task Scheduler and Mobile Hotspot
  - `View-Logs.bat`: Log viewer to see the last 50 activity entries
  - `Uninstall.bat`: One-click uninstaller for easy removal
- **Improved Error Handling**: Better error detection and reporting in PowerShell script
- **Admin Rights Validation**: Script now validates administrator privileges before execution
- **Connection Profile Check**: Verifies active internet connection before attempting hotspot activation
- **Complete Documentation**:
  - `FAQ.md`: Comprehensive FAQ covering common questions
  - `TROUBLESHOOTING.md`: Detailed troubleshooting guide with solutions
  - Updated `readme.md` with badges, new features, and better structure
- **CHANGELOG.md**: Version tracking and release notes

### Changed
- Upgraded installer from v2 to v1.1 with better user experience
- Enhanced PowerShell script (`Start-Hotspot.ps1`) with:
  - Detailed logging for every action
  - Better exception handling
  - Connection profile validation
  - More informative error messages
- Improved installer feedback messages
- Better documentation structure and organization

### Fixed
- Silent failures now properly logged
- Better handling of missing connection profiles
- Improved task scheduler error reporting

## [1.0.0] - 2025-09-19

### Added
- Initial release
- Basic Mobile Hotspot auto-start functionality
- Task Scheduler integration
- 10-minute fixed interval checking
- Simple PowerShell script for hotspot activation
- Basic README documentation
- Auto-elevation for administrator rights
- Clean reinstall functionality (auto-removes old task before creating new)

### Features
- One-click installation via batch file
- Automatic hotspot restart when turned off
- Works after PC restart
- Works when no devices are connected
- Windows 10/11 compatibility

---

## Version Numbering

This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, backward compatible

## Release Links

- [1.1.0](https://github.com/adeism/auto-start-windows-mobile-hotspot/releases/tag/v1.1.0) - Latest
- [1.0.0](https://github.com/adeism/auto-start-windows-mobile-hotspot/releases/tag/v1.0.0) - Initial Release

## Future Plans (Roadmap)

### v1.2.0 (Planned)
- Toast notifications when hotspot is reactivated
- Statistics dashboard (activation count, uptime percentage)
- Network-specific conditional start
- GUI configurator (optional)

### v2.0.0 (Future)
- Advanced scheduling (time-based activation)
- Multiple hotspot profiles
- Bandwidth monitoring
- Auto-update mechanism

---

**Note**: Versions before 1.1.0 did not include logging, so upgrade is highly recommended for better troubleshooting capabilities.