# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.9] - 2024-07-09

### Changed

- Fixed a crash using the `error` log method.

## [0.0.8] - 2024-07-09

### Added

- Added `source` parameter to `error` log method.

## [0.0.7] - 2024-07-08

### Added

- Added ability to log messages which are already ECS-formatted.

## [0.0.6] - 2024-07-08

### Added

- Added option to output logs in regular format when `isDevelopment` is `true`, otherwise use ECS log format.

## [0.0.5] - 2024-05-15

### Changed

- Fixed issue with fractional seconds removing default date formatting options.

## [0.0.4] - 2024-05-15

### Changed

- Timestamp field updated to include fractional seconds.

## [0.0.3] - 2024-05-15

### Added

- Added `ecs.version` field.

## [0.0.2] - 2024-05-12

### Changed

- Updated README.md with information on how to integrate with Vapor.

### Removed

- Removed Vapor extension for the time being.

## [0.0.1] - 2024-05-11

### Added

- Initial version.
