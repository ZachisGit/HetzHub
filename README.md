# HetzHub README

HetzHub is an orchestration project for Hetzner Cloud infrastructure. It automates the provisioning and deployment of servers and Docker services using the Hetzner project API key. The project aims to provide an AWS-like platform experience while maintaining the infrastructure in the user's Hetzner account.

## Features

- **Automated Provisioning**: Automatically sets up servers and Docker services on Hetzner Cloud.
- **Hetzner API Integration**: Utilizes the Hetzner project API key for orchestration.
- **Web Interface**: A forthcoming web interface for easy management (similar to AWS console).

## Getting Started

### Prerequisites

- Hetzner project account and API key.

### Setup

1. **Clone the Repository**: `git clone https://github.com/your-repo/HetzHub.git`
2. **Configure API Key**: Add your Hetzner API key to the configuration file.
3. **Run HetzHub**: Follow the instructions to start the HetzHub orchestration process.

## Currently Implemented Services

- **JupyterLab**: HTTPS encrypted service
- **S3-Storage**: HTTPS encrypted storage service with webui, persisted on three different physical locations via [Hetzner Volumes](https://docs.hetzner.com/de/cloud/volumes/overview)
- Coming soon **Redis** HTTPS encrypted redis db (non-cluster mode)



## Contribution

Contributions are welcome. Please submit pull requests for code, documentation, or feature suggestions.

## Licensing

HetzHub is free for personal and non-commercial use. I kindly ask companies and individuals profiting from HetzHub to reach out and discuss licensing options. The goal is to keep HetzHub accessible to all.
