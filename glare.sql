create database if not exists glare;
GRANT ALL PRIVILEGES ON glare.* TO 'glare'@'localhost' \
IDENTIFIED BY 'GLARE_DBPASS';
GRANT ALL PRIVILEGES ON glare.* TO 'glare'@'%' \
IDENTIFIED BY 'GLARE_DBPASS';
