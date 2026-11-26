# Internal Dashboard

Застосунок складається з API (Flask / Gunicorn), Web (Caddy) та Redis. Розгортання виконується через Helm, зовнішній доступ — через Traefik Ingress.

## Вимоги

`docker`, `kubectl`, `helm`, `k3d`.

## Локальне розгортання

```bash
k3d cluster create dashboard --port "80:80@loadbalancer" --port "443:443@loadbalancer"
docker build -t internal-dashboard-api:local .
docker build -t internal-dashboard-frontend:local ./frontend
k3d image import internal-dashboard-api:local -c dashboard
k3d image import internal-dashboard-frontend:local -c dashboard
helm upgrade --install dashboard ./charts/internal-dashboard \
  -n dashboard --create-namespace --wait --timeout 5m
```

Додати до `/etc/hosts`:

```text
127.0.0.1 dashboard.local
```

## Перевірка

```bash
sleep 180
kubectl get pods,svc,ingress,endpoints,networkpolicy -n dashboard
curl -i http://dashboard.local/
curl -i http://dashboard.local/api/
curl -i http://dashboard.local/api/health
helm test dashboard -n dashboard --logs
kubectl get pods -n dashboard
```

Очікуваний результат: усі три URL повертають HTTP 200, API повертає `{"message":"Hello","env":"prod","cache":"ok"}`, health endpoint — `{"status":"OK"}`. Сервісні Pod готові, без рестартів; smoke tests успішні.

## CI

На push виконуються збірка образів, `helm lint`, `helm template`, створення k3d-кластера, імпорт образів, розгортання та smoke tests.

## Звіт

[REPORT.md](REPORT.md) — опис проблем, виправлень та результатів локального тестування.
