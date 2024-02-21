# Containerized Development Environment for dbt and MotherDuck

1. configure `.env` file based on the sample

2. launch container

```bash
cd dbt_project
docker-compose up -d
```

3. connect to container via VS Code `Dev Containers` extension

4. when done working down container

```bash
docker compose down
```