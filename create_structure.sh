#!/bin/bash
# Este script cria a estrutura de arquivos vazios para documentar os estudos do LFCS.

echo "Criando arquivos de documentação para o LFCS..."

touch 01-kernel-info.md
touch 02-cronjobs.md
touch 03-time-sync.md
touch 04-environment-variables.md
touch 05-archives-compression.md
touch 06-users-groups-sudo.md
touch 07-iptables-firewall.md
touch 08-disk-management.md
touch 09-find-files.md
touch 10-sshfs-nfs.md
touch 11-docker-management.md
touch 12-git-workflow.md
touch 13-runtime-security-strace.md
touch 14-output-redirection.md
touch 15-build-from-source.md
touch 16-nginx-load-balancer.md
touch 17-openssh-config.md
touch 18-lvm-storage.md
touch 19-regex-log-filter.md
touch 20-user-group-limits.md

echo "Estrutura de arquivos criada com sucesso!"
ls -1 *.md
