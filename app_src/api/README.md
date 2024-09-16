# Local Setup Instructions
1. Install poetry
2. Run `poetry install` to install dependencies
3. Run `poetry shell` to activate the virtual environment
4. Run `fastapi dev main.py` to start the server


docker build -t api . --file Dockerfile
docker run -p 8000:8000 --name api_run --rm api 

