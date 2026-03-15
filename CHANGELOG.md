# Changelog

All notable changes to this project will be documented in this file.

---

## v1.2.0

### Added
- Added separate configuration for **web and SSH access CIDR**.
- Introduced new parameters:
  - `ssh_port`
  - `ssh_allowed_cidr`
  - `web_allowed_cidr`

### Changed
- Security group configuration now separates **web traffic** and **SSH access** rules.
- SSH access can now be restricted independently from web access.

### Notes
This change improves security by allowing different CIDR ranges for application access and administrative SSH access.

---

## v1.1.0

### Added
- Added support to optionally allow **SSH access (port 22)** in the EC2 security group.
- Introduced configuration option `enable_ssh` to control SSH access.

---

## v1.0.0

### Initial Release

- Provision a **basic EC2 instance on AWS**
- Automatically run a **Docker container on the EC2 instance**
- Create security group allowing application port access