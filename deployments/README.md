## Compose Templates
1. When deploying a compose template, ensure you have copied the ".env.example" to ".env" and filled it with the appropriate values. 

## Compose Tips
- If you are having strange errors, try redeploying. 
  - Run "docker compose down -v" to shutdown all containers and delete their volumes.
  - Run "docker compose up -d" to create all containers once more.