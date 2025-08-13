all : up

up : 
	@docker compose -f ./srcs/docker-compose.yml up -d

down : 
	@docker compose -f ./srcs/docker-compose.yml down

stop : 
	@docker compose -f ./srcs/docker-compose.yml stop

start : 
	@docker compose -f ./srcs/docker-compose.yml start

status : 
	@docker ps

clean:
	@docker stop $$(docker ps -qa) 2>/dev/null || true;\
	docker rm $$(docker ps -qa) 2>/dev/null || true;\
	docker rmi -f $$(docker images -qa) 2>/dev/null || true;\
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true;\
	docker network ls --filter type=custom -q | xargs -r docker network rm 2>/dev/null || true;