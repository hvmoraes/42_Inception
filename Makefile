NAME = inception
NGINX_DIR = srcs/requirements/nginx

all: ${NAME}

${NAME}:
	@mkdir -p /home/kasakh/data/wordpress /home/kasakh/data/mariadb
	@sudo docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@sudo docker compose -f ./srcs/docker-compose.yml down

clean:
	@sudo docker ps -qa | xargs -r sudo docker stop
	@sudo docker ps -qa | xargs -r sudo docker rm
	@sudo docker images -qa | xargs -r sudo docker rmi -f
	@sudo docker volume ls -q | xargs -r sudo docker volume rm
	@sudo docker network ls --format '{{.Name}}' | grep -vE 'bridge|host|none' | xargs -r sudo docker network rm
	@sudo rm -rf /home/kasakh/data/wordpress /home/kasakh/data/mariadb

re: down clean all

.PHONY: all re down clean