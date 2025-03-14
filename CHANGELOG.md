# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres
to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2025-03-14

### Added

- Added fallback strategy using credentials stored in Kubernetes secrets for required namespaces.

### ⚠️ Breaking changes ⚠️

- Removed AWS Secrets Manager secret creation from the module.

## [0.2.0] - 2025-02-27

### Added

- Add a new output `ecr_pullthroughcache_repository_uri` to expose the ECR repository URI.

## [0.1.0] - 2025-02-26

- First release.
