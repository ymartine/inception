COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	mkdir -p /home/yamartin/data/volume-mariadb
	mkdir -p /home/yamartin/data/volume-wordpress
	grep -qxF '127.0.0.1 yamartin.42.fr' /etc/hosts || echo '127.0.0.1 yamartin.42.fr' | sudo tee -a /etc/hosts
	$(COMPOSE) up --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all

fclean:
	$(COMPOSE) down --rmi all -v
	sudo rm -rf /home/yamartin/data/volume-mariadb
	sudo rm -rf /home/yamartin/data/volume-wordpress

re: fclean all

.PHONY: all down clean fclean re