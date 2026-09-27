# DevOps Practice Project

Практический проект для отработки навыков DevOps:
Docker, docker-compose, bash, мониторинг, Ansible, CI/CD.

## Стек технологий

- **Docker / Docker Compose** — контейнеризация и запуск сервисов
- **Bash** — скрипт проверки дисков
- **Nginx** — отдаёт статику
- **Prometheus + Grafana + Node Exporter** — мониторинг и визуализация
- **Ansible** — автоматизация настройки серверов
- **GitHub Actions** — CI/CD
## Структура проекта
.
├── case_one/
│ ├── Dockerfile # Сборка образа с bash-скриптом
│ ├── disk_check # Bash-скрипт проверки дисков
│ └── docker-compose.yml # nginx + disk
├── monitoring/
│ ├── docker-compose.yml # Prometheus + Grafana + Node Exporter
│ └── prometheus.yml # Конфигурация Prometheus
├── ansible/
│ └── playbook.yml # Установка nginx, копирование html, ufw
└── .github/
└── workflows/
└── deploy.yml # CI/CD: деплой на сервер через SSH


## Что делает проект

### 1. Bash-скрипт проверки дисков

#!/bin/bash
THRESHOLD=${THRESHOLD:-50}
echo "Disk usage check:"
df -h | awk 'NR>1 {print $1, $5}' | sed 's/%//' | while read -r partition usage; do
    if [ "$usage" -gt "$THRESHOLD" ]; then
        echo "WARNING: $partition is at $usage%"
    fi
done
Скрипт выводит предупреждения для дисков, заполненных выше порога.

### 2. Docker + docker-compose
Собственный Dockerfile на базе Ubuntu с bash-скриптом

docker-compose: nginx + контейнер с проверкой дисков

Healthcheck и depends_on: nginx стартует только после того, как disk сгенерирует index.html

### 3. Мониторинг (monitoring)
Prometheus — сбор метрик (порт 9090)

Grafana — визуализация метрик, дашборд Node Exporter Full (порт 3030, admin/admin)

Node Exporter — сбор метрик сервера (порт 9100)

### 4. Ansible
Плейбук автоматизирует:

установку nginx

копирование index.html

открытие порта 80 в ufw

вывод IP сервера

### 5. CI/CD (GitHub Actions)
При пуше в ветку case_one:

GitHub Actions подключается к серверу по SSH

Переходит в папку проекта

Пересобирает и перезапускает контейнеры через docker-compose
