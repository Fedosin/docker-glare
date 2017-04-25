build:
	docker build -t mfedosin/openstack-glare .
run:
	docker run -t -i -d --hostname controller --name glare mfedosin/openstack-glare
clean:
	docker rm -f glare
exec:
	docker exec -t -i glare bash
log:
	docker logs -f glare
