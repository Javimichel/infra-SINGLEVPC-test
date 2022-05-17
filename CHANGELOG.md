# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.3] - 2022-02-17
### Fix
- Increase chunksize to prevent errors uploading large layers. (see https://github.com/docker/distribution-library-image/issues/65)
- Increase root volume size to accomodate large images (new AMI)

## [1.0.2] - 2022-02-01
### Fix
- Fix problems pushing images to hub.furycloud.io

## [1.0.1] - 2022-01-31
### Added
- Add HTTPS LB port to ELB of hub.furycloud.io to enable "within-AWS" access

### Fixed
- Use correct AMI for hub.furycloud.io 

## [1.0.0] - 2022-01-31
### Added
- Infra to deploy hub.furycloud.io
