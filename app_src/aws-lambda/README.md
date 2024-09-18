# aws-lambda


## Run locally 
```bash
docker build --platform linux/amd64 -t lambdawriter:latest .
```
- Test image locally
```bash
docker run --platform linux/amd64 -p 9000:8080 --rm --name lambda_locally lambdawriter:latest 
curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```
