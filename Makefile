NAME = inception
NGINX_DIR = srcs/requirements/nginx
DATA_DIR = /home/$(USER)/data

all: ${NAME}

${NAME}:
	@sudo mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb
	@sudo docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@sudo docker compose -f ./srcs/docker-compose.yml down

clean:
	@sudo docker ps -qa | xargs -r sudo docker stop
	@sudo docker ps -qa | xargs -r sudo docker rm
	@sudo docker images -qa | xargs -r sudo docker rmi -f
	@sudo docker volume ls -q | xargs -r sudo docker volume rm
	@sudo docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none' | xargs -r sudo docker network rm
	@sudo rm -rf $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb

re: down clean all

.PHONY: all re down clean